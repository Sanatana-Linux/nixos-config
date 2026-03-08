{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.security.sudo;
in {
  options.modules.security.sudo = {
    enable = mkEnableOption "sudo with kernel network hardening";
  };

  config = mkIf cfg.enable {
    security.sudo = {
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

    boot = {
      kernel.sysctl = {
        "kernel.sysrq" = 0;

        # TCP hardening (NetworkManager-compatible)
        "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
        "net.ipv4.conf.default.rp_filter" = 2;
        "net.ipv4.conf.all.rp_filter" = 2;
        "net.ipv4.conf.default.accept_source_route" = 0;
        "net.ipv4.conf.all.accept_source_route" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.secure_redirects" = 1;
        "net.ipv4.conf.all.secure_redirects" = 1;
        "net.ipv4.conf.default.send_redirects" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;

        # TCP optimization
        "net.ipv4.tcp_fastopen" = 3;
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };

      blacklistedKernelModules = [
        "ax25"
        "netrom"
        "rose"
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

      kernelModules = ["tcp_bbr"];
    };
  };
}
