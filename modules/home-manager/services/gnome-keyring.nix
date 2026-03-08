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

    enableSSH = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SSH agent component in GNOME Keyring";
    };

    components = mkOption {
      type = types.listOf types.str;
      default = ["secrets" "pkcs11"];
      description = "GNOME Keyring components to enable (base components, SSH added conditionally)";
    };
  };

  config = mkIf cfg.enable {
    services.gnome-keyring = {
      enable = true;
      components = cfg.components ++ (optional cfg.enableSSH "ssh");
    };
  };
}
