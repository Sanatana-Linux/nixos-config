{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.security.pam;
in {
  options.modules.security.pam = {
    enable = mkEnableOption "PAM authentication, polkit, and rtkit";
  };

  config = mkIf cfg.enable {
  security = {
    pam = {
      sshAgentAuth.enable = true;
      loginLimits = [
        {
          domain = "*";
          type = "soft";
          item = "nofile";
          value = "81920";
        }
        {
          domain = "*";
          type = "hard";
          item = "nproc";
          value = "unlimited";
        }
        {
          domain = "*";
          type = "soft";
          item = "nproc";
          value = "unlimited";
        }
      ];
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

    environment.systemPackages = [pkgs.linux-pam];
  };
}
