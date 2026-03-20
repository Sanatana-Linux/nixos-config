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
      type = types.enum ["x11", "wayland"];
      default = "x11";
      description = "Session type to use: x11 or wayland";
    };
  };

  config = mkIf config.modules.desktop.wayland.enable {
    # Wayland-specific packages and configuration
    environment.systemPackages = with pkgs; [
      # Wayland core components
      wayland
      wayland-protocols
    ] ++ optionals (config.modules.desktop.wayland.sessionType == "wayland") [
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
    ];

    # X11-specific packages (when not using Wayland)
    environment.systemPackages = with pkgs; [
      # X11 core components (when using X11)
    ] ++ optionals (config.modules.desktop.wayland.sessionType == "x11") [
      # X11-specific applications and libraries that aren't needed for XWayland
      # These would be the traditional X11 packages
    ];

    # Environment variables for Wayland/X11 session
    environment.variables = if config.modules.desktop.wayland.sessionType == "wayland" then {
      # Wayland session environment variables
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPETITIVE = "1";
      # Enable Ozone Wayland for Electron/Chromium
      NIXOS_OZONE_WL = "1";
    } else {
      # X11 session environment variables
      GDK_BACKEND = "x11";
      QT_QPA_PLATFORM = "xcb";
      SDL_VIDEODRIVER = "x11";
      _JAVA_AWT_WM_NONREPETITIVE = "1";
    };
  };
}