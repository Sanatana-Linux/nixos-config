{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.services.gnome-keyring = {
    enable = mkEnableOption "GNOME Keyring service";
    components = mkOption {
      type = types.listOf types.str;
      default = ["secrets" "ssh" "pkcs11"];
      description = "Components to enable for GNOME Keyring";
    };
  };

  config = mkIf config.modules.services.gnome-keyring.enable {
    services.gnome-keyring = {
      enable = true;
      components = config.modules.services.gnome-keyring.components;
    };
  };
}
