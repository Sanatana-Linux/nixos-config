{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.wayland = {
    enable = mkEnableOption "Wayland display server protocol";

    sessionType = mkOption {
      type = types.enum ["x11" "wayland"];
      default = "wayland";
      description = "Session type to use: x11 or wayland";
    };
  };

  config = mkIf config.modules.desktop.wayland.enable {
    # Wayland-specific packages and configuration
    environment.systemPackages = with pkgs; [
      # Wayland core components
      wayland
      wayland-protocols
      # Wayland-native applications and libraries
      firefox-wayland
      glfw-wayland
      egl-wayland
      qt6.qtwayland
      qt5.qtwayland
      xwayland
      xwayland-run
      wayland-pipewire-idle-inhibit
      way-displays
      qt5.qtdeclarative
      qt6.qtdeclarative
    ];

    # Environment variables for Wayland/X11 session
    environment.variables = {
      # Wayland session environment variables
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland-egl";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPETITIVE = "1";
      # Enable Ozone Wayland for Electron/Chromium
      NIXOS_OZONE_WL = "1";
    };
  };
}
