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
  };

  config = mkIf cfg.enable {
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
  };
}
