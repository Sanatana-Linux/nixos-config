{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop;
in {
  imports = [
    ./gtk.nix
    ./x11
  ];

  options.modules.desktop = {
    enable = mkEnableOption "Desktop environment modules (GTK, X11, etc.)";
  };

  config = mkIf cfg.enable {
    # When desktop is enabled, automatically enable gtk by default
    modules.desktop.gtk.enable = mkDefault true;
  };
}
