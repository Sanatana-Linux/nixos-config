#!/usr/bin/env bash
set -euo pipefail

# --- Robust Color Definitions using tput ---
# Check if the terminal supports colors
if tput setaf 1 >/dev/null 2>&1; then
    C_BLUE=$(tput setaf 4)
    C_GREEN=$(tput setaf 2)
    C_YELLOW=$(tput setaf 3)
    C_RED=$(tput setaf 1)
    C_BOLD=$(tput bold)
    C_RESET=$(tput sgr0)
else
    # If colors are not supported, set variables to empty strings
    C_BLUE=""
    C_GREEN=""
    C_YELLOW=""
    C_RED=""
    C_BOLD=""
    C_RESET=""
fi

# --- Helper Functions using printf ---
info() {
    printf "%sINFO:%s %s\n" "${C_BLUE}" "${C_RESET}" "$1"
}

success() {
    printf "%sSUCCESS:%s %s\n" "${C_GREEN}" "${C_RESET}" "$1"
}

warn() {
    printf "%sWARNING:%s %s\n" "${C_YELLOW}" "${C_RESET}" "$1"
}

error() {
    printf "%sERROR:%s %s\n" "${C_RED}" "${C_RESET}" "$1" >&2
    exit 1
}

# --- Pre-flight Checks ---
check_deps() {
    info "Checking for required dependencies..."
    if [ "$(id -u)" -eq 0 ]; then
        error "This script should not be run as root. Please run as a regular user."
    fi

    for cmd in git gpg sops ssh-keyscan nix; do
        if ! command -v "$cmd" &>/dev/null; then
            error "Command not found: '$cmd'. Please install it and ensure it's in your PATH."
        fi
    done
    success "Found core command-line tools."

    info "Checking if Nix Flakes are enabled..."
    if ! nix-instantiate --eval -E 'builtins.getFlake "nixpkgs"' >/dev/null 2>&1; then
        error "Nix Flakes are not enabled or working. Please add 'experimental-features = nix-command flakes' to your nix.conf and restart the Nix daemon."
    fi
    success "Nix Flakes appear to be enabled and working."
}

# --- Main Script Logic ---
main() {
    clear
    printf "%s\n" \
        "${C_BOLD}NixOS Secrets Management Setup using sops-nix${C_RESET}" \
        "" \
        "This script will set up a private repository for managing your NixOS secrets." \
        "It will create a set of configuration files with detailed comments to guide you." \
        "" \
        "You will need:" \
        "1. A GPG key already configured on your system." \
        "2. An SSH server running on your NixOS host (localhost) for key discovery." \
        "" \
        "The script will create the following structure:" \
        "  ${C_YELLOW}your-secrets-repo/" \
        "  ├── .git/" \
        "  ├── .gitignore" \
        "  ├── .sops.yaml            # Configures which keys can encrypt/decrypt files" \
        "  ├── flake.nix             # Makes secrets easily importable" \
        "  └── secrets.yaml          # Your encrypted secrets file${C_RESET}"
    
    read -p "Press Enter to continue..."

    # 1. Gather Information
    info "First, I need some information from you."
    read -p "Enter the path for the new secrets repository (e.g., ~/nix-secrets): " SECRETS_REPO_PATH
    SECRETS_REPO_PATH="${SECRETS_REPO_PATH/#\~/$HOME}" # Expand tilde

    if [ -d "$SECRETS_REPO_PATH" ]; then
        error "Directory '$SECRETS_REPO_PATH' already exists. Please choose a different path."
    fi

    printf "\n"
    info "Please provide your GPG key identifier (e.g., your email address or key ID)."
    info "You can list your keys with: ${C_BOLD}gpg --list-secret-keys${C_RESET}"
    read -p "Your GPG Key ID: " GPG_KEY_ID

    # 2. Validate GPG Key and get Fingerprint
    info "Validating GPG key and retrieving fingerprint..."
    GPG_FINGERPRINT=$(gpg --fingerprint "$GPG_KEY_ID" 2>/dev/null | grep 'key fingerprint' | sed -E 's/.*= *//;s/ //g')
    if [ -z "$GPG_FINGERPRINT" ]; then
        error "Could not find GPG key for '$GPG_KEY_ID'. Please check the identifier and try again."
    fi
    success "Found GPG key with fingerprint: $GPG_FINGERPRINT"

    # 3. Get Host's Public Age Key
    info "Now, getting the public key for your NixOS host."
    info "This allows the machine to decrypt secrets automatically during activation."
    if ! ssh-keyscan -t ed25519 localhost &>/dev/null; then
        warn "Could not connect to the SSH server on 'localhost'."
        warn "Please ensure 'services.openssh.enable = true;' is set in your NixOS config and the service is running."
        error "SSH server on localhost is required to get the host's public key."
    fi
    HOST_AGE_KEY=$(ssh-keyscan -t ed25519 localhost 2>/dev/null | nix run nixpkgs#ssh-to-age)
    success "Retrieved host's public age key: $HOST_AGE_KEY"

    # 4. Create Repository Structure
    info "Creating directory structure at '$SECRETS_REPO_PATH'..."
    mkdir -p "$SECRETS_REPO_PATH"
    cd "$SECRETS_REPO_PATH"
    git init -b main >/dev/null
    success "Initialized a new git repository."

    # 5. Create .gitignore
    cat >.gitignore <<'EOF'
# Nix build results
result*

# Direnv cache
.direnv/
EOF

    # 6. Create .sops.yaml
    info "Creating .sops.yaml configuration file..."
    cat >.sops.yaml <<EOF
creation_rules:
  - path_regex: .*.yaml
    pgp: &pgp_keys
      - ${GPG_FINGERPRINT}
    age: &age_keys
      - ${HOST_AGE_KEY}
EOF
    success "Created .sops.yaml"

    # 7. Create example secrets.yaml
    info "Creating a template secrets.yaml file..."
    cat >secrets.yaml <<EOF
# This is a template for your secrets. Edit it by running: sops secrets.yaml
# Sops will automatically encrypt values when you save and quit.
some_service:
    api_token: "REPLACE_WITH_YOUR_SECRET_API_TOKEN"
    username: "hiro"
another_secret: "REPLACE_WITH_A_VERY_SECRET_PASSWORD"
# This section below is managed by sops. You don't need to edit it.
sops:
    pgp:
        - fp: "${GPG_FINGERPRINT}"
          # ... encrypted data will appear here on first save ...
    age:
        - recipient: "${HOST_AGE_KEY}"
          # ... encrypted data will appear here on first save ...
    lastmodified: "$(date --utc --iso-8601=seconds)"
    version: "3.8.1"
EOF
    success "Created secrets.yaml. You can edit it with 'sops secrets.yaml'."

    # 8. Create flake.nix for the secrets repo
    info "Creating a flake.nix for this repository..."
    cat >flake.nix <<'EOF'
{
  description = "My private NixOS secrets, managed with sops-nix";
  outputs = { self, ... }: {
    # This makes the secrets file path discoverable from your main flake:
    # `sops.defaultSopsFile = inputs.nix-secrets.sopsFile;`
    sopsFile = ./secrets.yaml;
  };
}
EOF
    success "Created flake.nix"

    # 9. Final Instructions
    printf "\n\n%s======================================================\n" "${C_GREEN}"
    printf "      Setup Complete! Here are your next steps:       \n"
    printf "======================================================%s\n\n" "${C_RESET}"
    
    printf "%s1. Navigate to your new secrets repository:%s\n" "${C_BOLD}" "${C_RESET}"
    printf "   %scd \"%s\"%s\n\n" "${C_YELLOW}" "$SECRETS_REPO_PATH" "${C_RESET}"
    
    printf "%s2. Open and edit your secrets file for the first time:%s\n" "${C_BOLD}" "${C_RESET}"
    printf "   This will encrypt the file using the keys in .sops.yaml.\n"
    printf "   %ssops secrets.yaml%s\n\n" "${C_YELLOW}" "${C_RESET}"
    
    printf "%s3. Integrate with your main NixOS configuration flake:%s\n" "${C_BOLD}" "${C_RESET}"
    printf "   a) Add this repo as an input in your main flake.nix:\n"
    printf "      %snix-secrets.url = \"git+file://%s\";%s\n\n" "${C_BLUE}" "$SECRETS_REPO_PATH" "${C_RESET}"
    
    printf "   b) Create a sops module (e.g., /etc/nixos/modules/sops.nix) with the following contents and import it:\n"
    printf "%s------------------- COPY FROM HERE -------------------%s\n" "${C_YELLOW}" "${C_RESET}"
    printf "{ config, inputs, ... }:\n\n{\n"
    printf "  imports = [ inputs.sops-nix.nixosModules.sops ];\n\n"
    printf "  sops.defaultSopsFile = inputs.nix-secrets.sopsFile;\n"
    printf "  sops.age.sshKeyPaths = [ \"/etc/ssh/ssh_host_ed25519_key\" ];\n\n"
    printf "  sops.secrets.my_api_token = {\n"
    printf "    key = \"some_service.api_token\";\n"
    printf "    # owner = config.users.users.some_user.name;\n"
    printf "  };\n\n"
    printf "  sops.secrets.another_secret = {}; # If name matches key in yaml\n"
    printf "}\n"
    printf "%s-------------------- TO HERE --------------------%s\n\n" "${C_YELLOW}" "${C_RESET}"

    printf "%s4. Rebuild your NixOS system:%s\n" "${C_BOLD}" "${C_RESET}"
    printf "   %ssudo nixos-rebuild switch --flake .#yourHostname%s\n\n" "${C_YELLOW}" "${C_RESET}"
    
    printf "%s5. Commit and push to a PRIVATE git repository:%s\n" "${C_BOLD}" "${C_RESET}"
    printf "   %sgit add . && git commit -m \"Initial secrets setup\"%s\n" "${C_YELLOW}" "${C_RESET}"
    printf "   %sgit remote add origin <your-private-repo-url>%s\n" "${C_YELLOW}" "${C_RESET}"
    printf "   %sgit push -u origin main%s\n\n" "${C_YELLOW}" "${C_RESET}"
    
    printf "%sYou are all set! Your secrets are now managed securely.%s\n" "${C_GREEN}" "${C_RESET}"
}

# --- Script Entrypoint ---
check_deps
main
