{pkgs, ...}: {
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
