{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bitwarden #password management
    bitwarden-desktop # password management native app
    ghorg # mass clone git repos
    libtpms # tpm library
    linux-pam # pam
    nmap # network scanner
    openssl.dev # TSL/SSL
    python312Packages.tpm2-pytss
    ssh-tpm-agent
    swtpm # software tpm
    tor # privacy network protocol
    tor-browser-bundle-bin # firefox with integrated tor connections by default
    tpm2-abrmd # TPM2 resource manage
    tpm2-tools # tools for working with TPM chip
    tpm2-tss #  OSS implementation of the TCG TPM2 Software Stack
    tpmmanager # manage TPM hardware
  ];
  security = {
    # I am told this is a better choice, I don't notice much difference but its more ergonomic to type
    doas = {
      enable = true;
      extraRules = [
        {
          # TODO implement users variable determined in /hosts/[host]/default.nix instead
          users = ["tlh" "smg"];
          groups = ["wheel" "networkmanager"];
          noPass = true;
          keepEnv = true;
          persist = false;
        }
      ];
    };
    # Just in case ;]
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
      extraConfig = ''
        # clear warning in sudo lectures after each reboot.
        Defaults lecture = never
         # password input feedback - makes typed password visible as asterisks.
        Defaults pwfeedback # WARNING: where the buffer overload vulnerability comes from
        # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
        Defaults env_keep+=SSH_AUTH_SOCK
      '';
    };

    pam = {
      sshAgentAuth.enable = true;
      # solve open file limits
      loginLimits = [
        {
          domain = "*";
          type = "soft";
          item = "nofile";
          value = "81920";
        }
      ];
    };
    polkit.enable = true;
    rtkit.enable = true;
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      abrmd.enable = true;
    };
  };
}
