{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.security.ssh;
in {
  options.modules.security.ssh = {
    enable = mkEnableOption "openssh server with secure defaults";

    passwordAuthentication = mkOption {
      type = types.bool;
      default = false;
      description = "Allow password authentication";
    };

    permitRootLogin = mkOption {
      type = types.str;
      default = "no";
      description = "Permit root login setting";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = lib.mkForce cfg.passwordAuthentication;
        PermitRootLogin = lib.mkForce cfg.permitRootLogin;
      };
    };

    programs.ssh.startAgent = true;

    security.pam.services.sshd.rules.auth.rssh = {
      order = config.security.pam.services.sshd.rules.auth.unix.order + 10;
      control = "sufficient";
      modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
    };
  };
}
