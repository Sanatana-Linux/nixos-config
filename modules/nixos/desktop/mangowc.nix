{ lib, config, inputs, pkgs, ... }:
with lib;
let
  cfg = config.modules.mango;
in {
  imports = [
    inputs.mango.nixosModules.mango
  ];

  options.modules.mango = {
    enable = lib.mkEnableOption "Enable the mangowc feature";
  };

  config = lib.mkIf cfg.enable {
    programs.mango.enable = true;
    xdg.portal.wlr.enable = true;

    environment.systemPackages = with pkgs; [
      wayland
      wayland-protocols
      glfw
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

    environment.variables = {
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = mkForce "wayland-egl";
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      CLUTTER_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
  };
}
