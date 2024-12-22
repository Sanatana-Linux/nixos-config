{pkgs}:
with pkgs;
  writeScriptBin "shell" ''
#!/usr/bin/env bash
# Initialize empty arrays for package names and options
ps=()
os=()

# Loop through all the arguments
for p in "$@"; do
    if [[ "$p" != --* ]]; then
        # If not an option, add it to the package names array
        ps+=("nixpkgs#$p")
    else
        # If it is an option, add it to the options array
        os+=("$p")
    fi
done

# Construct the command
cmd="SHELL=$(which zsh) IN_NIX_SHELL=\"impure\" nix shell ${os[*]} ${ps[*]}"
echo "Executing \`$cmd\`..."

# Execute the command
eval $cmd
  ''

