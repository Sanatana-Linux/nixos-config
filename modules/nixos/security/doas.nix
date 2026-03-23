{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.security.doas;
in {
  options.modules.security.doas = {
    enable = mkEnableOption "doas privilege escalation";
    adminUser = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Primary user to grant passwordless doas access";
    };
  };

  config = mkIf cfg.enable {
    security.doas = {
      enable = true;
      extraRules = [
        {
          users =
            if cfg.adminUser != null
            then [cfg.adminUser]
            else ["tlh" "smg"];
          groups = ["wheel" "networkmanager"];
          noPass = true;
          keepEnv = true;
          persist = false;
        }
      ];
    };
  };
}
