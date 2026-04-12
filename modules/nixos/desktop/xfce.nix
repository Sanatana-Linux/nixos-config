{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.xfce;
in {
  options.modules.desktop.xfce = {
    enable = mkEnableOption "XFCE desktop environment";

    displayManager = mkOption {
      type = types.enum ["sddm" "lightdm"];
      default = "sddm";
      description = "Display manager to use with XFCE";
    };
  };

  config = mkIf cfg.enable {
    # Enable appropriate display manager based on configuration
    modules.desktop.sddm.enable = mkIf (cfg.displayManager == "sddm") true;
    modules.desktop.lightdm.enable = mkIf (cfg.displayManager == "lightdm") true;
    gtk.iconCache.enable = true;
    xdg.icons.enable = true;
    # Common XFCE configuration
    services = {
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = false;
          disableWhileTyping = true;
        };
      };

      xserver = {
        enable = true;
        autorun = true;
        exportConfiguration = true;
        updateDbusEnvironment = true;
        desktopManager.runXdgAutostartIfNone = true;
        desktopManager.xfce.enable = true;
      };

      devmon.enable = true;
      udisks2.enable = true;
      acpid.enable = true;
    };

    environment.variables = {
      GDK_BACKEND = "x11";
      QT_QPA_PLATFORM = mkForce "xcb";
      SDL_VIDEODRIVER = "x11";
      _JAVA_AWT_WM_NONREPENTING = "1";
    };
  };
}
