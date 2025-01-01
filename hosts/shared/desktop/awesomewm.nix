{pkgs, ...}: {
  services = {
    displayManager = {
      defaultSession = "none+awesome";
    }; # ends display manager
    xserver = {
      enable = true;
      autorun = true;
      exportConfiguration = true;
      updateDbusEnvironment = true;

      displayManager = {
        lightdm = {
          enable = true;
          background = ../wallpaper/monokaiprospectrum.png;
          greeters.gtk = {
            enable = true;
            theme = {
              package = pkgs.orchis-theme;
              name = "Orchis-Grey-Dark-Compact";
            };
            cursorTheme = {
              package = pkgs.phinger-cursors;
              name = "Phinger Cursors (light)";
              size = 48;
            };
            iconTheme = {
              package = pkgs.reversal-icon-theme;
              name = "Reversal";
            };
            indicators = ["~session" "~spacer" "~clock" "--spacer" "~power"];
          };
        };
      }; # ends displayManager not xserver
      windowManager.awesome = {
        enable = true;
        package = pkgs.awesome-git-luajit;
        luaModules = with pkgs.luajitPackages; [
          luaposix
          cqueues
          cjson
          ldbus
          ldoc
          lgi
          lpeg
          lpeg_patterns
          lpeglabel
          lua
          lua-messagepack
          luarocks
          luasocket
          luasql-sqlite3
          mpack
          std-_debug
          std-normalize
          stdlib
          vicious
          wrapLua
        ];
      };
    }; # ends xserver
  }; # ends services
  # ------------------------------------------------- #
  environment.systemPackages = with pkgs; [
    dbus
    dbus-broker
    dbus-glib
    gobject-introspection-unwrapped
    maim
    menu-cache
    pango
    pangomm
    polkit_gnome
    xfce.exo
    xfce.garcon
    xfce.libxfce4ui
    xfce.libxfce4util
    xfce.tumbler
    xfce.xfce4-power-manager
    xfce.xfconf
    cairo
    cairomm
    awesome-git-luajit
    maim
    pango
    pangomm
    xclip
    xdotool
    xsel
    xsettingsd
    dconf-editor
    xfce.xfce4-clipman-plugin
    xfce.xfconf
    xfce.xfce4-settings
    xfce.exo
    xfce.libxfce4ui
    xfce.libxfce4util
    xorg.xwininfo
  ];
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
}
