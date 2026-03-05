{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.security.doas;
in {
  options.modules.security.doas = {
    enable = mkEnableOption "Doas and security configuration";
  };

  config = mkIf cfg.enable {
    # Doas configuration
    security.doas = {
      enable = true;
      extraRules = [
        {
          users = ["tlh" "smg"];
          groups = ["wheel" "networkmanager"];
          noPass = true;
          keepEnv = true;
          persist = false;
        }
      ];
    };

    # Sudo configuration (as backup)
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
      extraConfig = ''
        Defaults lecture = never
        Defaults pwfeedback
        Defaults env_keep += "SSH_AUTH_SOCK"
      '';
    };

    # PAM and authentication
    security.pam = {
      sshAgentAuth.enable = true;
      loginLimits = [
        {
          domain = "*";
          type = "soft";
          item = "nofile";
          value = "81920";
        }
      ];
    };

    # Additional security services
    security.polkit.enable = true;
    security.rtkit.enable = true;
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      abrmd.enable = true;
    };

    # Kernel security hardening
    boot = {
      kernel.sysctl = {
        # Kernel security hardening
        "kernel.sysrq" = 0; # Disable Magic SysRq key

        # TCP hardening (NetworkManager-compatible)
        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        # Use loose reverse path filtering instead of strict for NetworkManager compatibility
        "net.ipv4.conf.default.rp_filter" = 2;
        "net.ipv4.conf.all.rp_filter" = 2;
        "net.ipv4.conf.default.accept_source_route" = 0;
        "net.ipv4.conf.all.accept_source_route" = 0;
        # Allow secure redirects for NetworkManager functionality
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 1;
        "net.ipv4.conf.all.secure_redirects" = 1;
        # Disable sending redirects but allow receiving secure ones
        "net.ipv4.conf.default.send_redirects" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;

        # TCP optimization
        "net.ipv4.tcp_fastopen" = 3;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };

      # Blacklist obscure network protocols for security
      blacklistedKernelModules = [
        # Network protocols
        "ax25"
        "netrom"
        "rose"
        # Filesystems
        "adfs"
        "affs"
        "bfs"
        "befs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "freevxfs"
        "f2fs"
        "hfs"
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "ntfs"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"
        "ufs"
      ];

      # Enable required kernel modules
      kernelModules = ["tcp_bbr"];
    };

    # Security-related packages
    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      ghorg
      libtpms
      linux-pam
      nmap
      openssl.dev
      python312Packages.tpm2-pytss
      ssh-tpm-agent
      swtpm
      tor
      tor-browser
      tpm2-abrmd
      tpm2-tools
      tpm2-tss
      tpmmanager
    ];
  };
}
