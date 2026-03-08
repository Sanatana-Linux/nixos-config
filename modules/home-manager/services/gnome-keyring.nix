{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.services.gnome-keyring;
in {
  options.modules.services.gnome-keyring = {
    enable = mkEnableOption "GNOME Keyring service";

    components = mkOption {
      type = types.listOf types.str;
      default = ["secrets" "pkcs11"];
      description = "GNOME Keyring components to enable";
    };
  };

  config = mkIf cfg.enable {
    services.gnome-keyring = {
      enable = true;
      inherit (cfg) components;
    };
  };
}
