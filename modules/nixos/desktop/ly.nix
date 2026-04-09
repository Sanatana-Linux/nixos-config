{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.ly = {
    enable = mkEnableOption "ly display manager";
  };

  config = mkIf config.modules.desktop.ly.enable {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
        bigclock = "%c";
        blank_box = true;
        clock = "%c";
        hide_borders = false;
        load_config = true;
        max_desktop_len = 100;
        max_login_len = 100;
        max_password_len = 100;
        min_refresh_delta = 5;
        nav_type = 0;
        numlock = true;
        save_file = "/etc/ly/save";
        shutdown_cmd = "doas poweroff";
        restart_cmd = "doas reboot";
        term_reset_cmd = "tput reset";
        waylandsessions = "/run/current-system/sw/share/wayland-sessions";
        xinitrc = "/etc/X11/xinit/xinitrc";
      };
    };

    # Critical: Enable PAM session management for ly
    security.pam.services.ly.startSession = true;

    # Ensure ly can access session files and has required X11 authentication
    environment.systemPackages = with pkgs; [
      ly
      xauth  # Required for X11 authentication with ly
    ];
  };
}