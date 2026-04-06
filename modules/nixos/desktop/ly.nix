{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.ly = {
    enable = mkEnableOption "ly display manager";
    
    settings = mkOption {
      type = types.attrsOf types.str;
      default = {
        animation = "matrix";
        bigclock = "%c";
        blank_box = "true";
        clock = "%c";
        hide_borders = "false";
        load_config = "true";
        max_desktop_len = "100";
        max_login_len = "100";
        max_password_len = "100";
        min_refresh_delta = "5";
        nav_type = "0";
        numlock = "true";
        save_file = "/etc/ly/save";
        shutdown_cmd = "shutdown -a";
        term_reset_cmd = "tput reset";
        tty = "2";
        waylandsessions = "/usr/share/wayland-sessions";
        x11sessions = "/usr/share/xsessions";
        xinitrc = "/etc/X11/xinit/xinitrc";
      };
      description = "ly configuration settings";
    };
  };

  config = mkIf config.modules.desktop.ly.enable {
    services.displayManager.ly = {
      enable = true;
      settings = config.modules.desktop.ly.settings;
    };

    # Ensure ly can access session files
    environment.systemPackages = with pkgs; [
      ly
    ];
    
    # Create ly configuration directory
    environment.etc."ly/config.ini".text = lib.generators.toINI {} config.modules.desktop.ly.settings;
  };
}