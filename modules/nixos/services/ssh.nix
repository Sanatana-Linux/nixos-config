{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
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
  };
}
