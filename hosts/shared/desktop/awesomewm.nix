{pkgs, ...}: {
  services.xserver.displayManager = {
    setupCommands = ''
      ${pkgs.xss-lock}/bin/xss-lock -l ${pkgs.multilockscreen} --lock dimblur --span
    '';
    lightdm = {
      enable = true;
      background = ../wallpaper/monokaiprospectrum.png;
      greeters.gtk = {
        enable = true;
        theme = {
          name = "Orchis-Grey-Dark-Compact";
          package = pkgs.orchis-theme;
        };
        cursorTheme = {
          name = "Phinger Cursors (light)";
          package = pkgs.phinger-cursors;
          size = 48;
        };
        iconTheme = {
          name = "Reversal";
          package = pkgs.reversal-icon-theme;
        };
        indicators = ["~session" "~spacer"];
      };
    };
  };
  services.displayManager.defaultSession = "none+awesome";
  services.xserver.windowManager.awesome = {
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

  # ------------------------------------------------- #
  environment.systemPackages = with pkgs; [
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
}
