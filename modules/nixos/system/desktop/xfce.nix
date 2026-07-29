{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.desktop.xfce;
in {
  options.modules.system.desktop.xfce = {
    enable = mkEnableOption "XFCE desktop environment";

    screenshot = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Bind PrintScreen keys to xfce4-screenshooter via xfconf";
      };
    };
  };

  config = mkIf cfg.enable {
    # Enable LightDM display manager
    modules.system.desktop.lightdm.enable = true;
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

    # Session startup commands
    services.xserver.displayManager.sessionCommands = let
      xfconf = "${pkgs.xfce.xfconf}/bin/xfconf-query";
    in
      # PrintScreen keybinding for xfce4-screenshooter
      (optionalString cfg.screenshot.enable ''
        ${xfconf} \
          -c xfce4-keyboard-shortcuts \
          -p /commands/custom/Print \
          -s "${pkgs.xfce4-screenshooter}/bin/xfce4-screenshooter -f" \
          --create -t string 2>/dev/null || true
        ${xfconf} \
          -c xfce4-keyboard-shortcuts \
          -p /commands/custom/<Primary>Print \
          -s "${pkgs.xfce4-screenshooter}/bin/xfce4-screenshooter -r" \
          --create -t string 2>/dev/null || true
        ${xfconf} \
          -c xfce4-keyboard-shortcuts \
          -p /commands/custom/<Alt>Print \
          -s "${pkgs.xfce4-screenshooter}/bin/xfce4-screenshooter -w" \
          --create -t string 2>/dev/null || true
      '')
      + ''
        # Disable xfwm4 compositor — picom handles compositing instead
        ${xfconf} -c xfwm4 -p /general/use_compositing -s false 2>/dev/null || true
      '';
  };
}
