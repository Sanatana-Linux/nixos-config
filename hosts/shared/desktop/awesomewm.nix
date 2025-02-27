{
  pkgs,
  config,
  ...
}: {
  services = {
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
              package = pkgs.materia-theme-transparent;
              name = "Materia-dark-compact";
            };
            cursorTheme = {
              package = pkgs.phinger-cursors;
              name = "Phinger Cursors (light)";
              size = 48;
            };
            iconTheme = {
              package = pkgs.papirus-icon-theme;
              name = "Papirus-Dark";
            };
            indicators = ["~session" "--spacer" "~power"];
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

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = false;
        disableWhileTyping = true;
      };
    }; #ends libinput
  }; # ends services
  # ------------------------------------------------- #
  environment.systemPackages = with pkgs; [
    dbus
    dbus-broker
    dbus-glib
    gobject-introspection-unwrapped
    scrot
    menu-cache
    pango
    pangomm
    polkit_gnome
    xfce.garcon
    xfce.libxfce4ui
    xfce.libxfce4util
    xfce.tumbler
    cairo
    cairomm
    awesome-git-luajit
    pango
    pangomm
    xclip
    xdotool
    xsel
    xsettingsd
    dconf-editor
    xfce.libxfce4ui
    xfce.libxfce4util
    xorg.xwininfo
  ];
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
}
