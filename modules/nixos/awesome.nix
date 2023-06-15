{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.xserver.windowManager.awesome;
  # ------------------------------------------------- #
  dbus_proxy = pkgs.callPackage ({
    luajit,
    luajitPackages,
    fetchFromGitHub,
  }:
    luajit.pkgs.buildLuaPackage rec {
      pname = "dbus_proxy";
      version = "0.10.3";
      name = "${pname}-${version}";

      src = fetchFromGitHub {
        owner = "stefano-m";
        repo = "lua-${pname}";
        rev = "v${version}";
        sha256 = "sha256-Yd8TN/vKiqX7NOZyy8OwOnreWS5gdyVMTAjFqoAuces=";
      };

      propagatedBuildInputs = [luajitPackages.lgi];
      buildPhase = ":";

      installPhase = ''
        mkdir -p "$out/share/lua/${luajit.luaversion}"
        cp -r src/${pname} "$out/share/lua/${luajit.luaversion}/"
      '';
    }) {};
  # ------------------------------------------------- #
  async-lua = pkgs.callPackage ({
    luajit,
    fetchFromGitHub,
  }:
    luajit.pkgs.buildLuarocksPackage rec {
      pname = "async.lua";
      version = "scm-1";

      src = fetchFromGitHub {
        owner = "sclu1034";
        repo = pname;
        rev = "f8d8f70a1ef1f7c4d5e3e65a36e0e23d65129e92";
        hash = "sha256-zWeIZkdO5uOHI2dkzseCEj8+BldH7X1ZtfIQhDFjaQY=";
      };

      preConfigure = ''
        ln -s rocks/${pname}-${version}.rockspec .
      '';

      propagatedBuildInputs = [luajit];
    }) {};
  # ------------------------------------------------- #
  lgi-async-extra = pkgs.callPackage ({
    luajit,
    luajitPackages,
    fetchFromGitHub,
  }:
    luajit.pkgs.buildLuarocksPackage rec {
      pname = "lgi-async-extra";
      version = "scm-1";

      src = fetchFromGitHub {
        owner = "sclu1034";
        repo = pname;
        rev = "45281ceaf42140f131861ca6d1717912f94f0bfd";
        hash = "sha256-4Lydw1l3ETLzmsdQu53116rn2oV+XKDDpgxpa3yFbYM=";
      };

      preConfigure = ''
        ln -s rocks/${pname}-${version}.rockspec .
      '';

      propagatedBuildInputs = [async-lua luajit luajitPackages.lgi];
    }) {};
  # ------------------------------------------------- #
  # Insure Awesome can access lgi
  getLuaPath = lib: dir: "${lib}/${dir}/lua/${pkgs.luajit.luaversion}";
  makeSearchPath = lib.concatMapStrings (
    path:
      " --search "
      + (getLuaPath path "share")
      + " --search "
      + (getLuaPath path "lib")
  );
  # ------------------------------------------------- #
  # lua modules that Awesome requires

  luaModules = with pkgs.luajitPackages; [
    lgi
    ldbus
    #luadbi-mysql
    luaposix
    cjson
    # custom modules
    dbus_proxy
    async-lua
    lgi-async-extra
  ];
in {
  options = {
    services.xserver.windowManager.awesome = {
      enable = mkEnableOption (lib.mdDoc "Awesome Window Manager Luajit");
    };
  };

  config = mkIf cfg.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        xfce.thunar-archive-plugin
        xfce.thunar-volman
        xfce.thunar-dropbox-plugin
        xfce.thunar-media-tags-plugin
        xarchiver
        archiver
        gnome.file-roller
      ];
    };
    services.xserver = {
      enable = true;
      exportConfiguration = true;
      # ------------------------------------------------- #
      # lightdm configuration
      displayManager = {
        defaultSession = "none+awesome";
        lightdm = {
          enable = true;
          background = ../../hosts/shared/wallpaper/wallpaper.png;
          # TODO use lightdm-webkit2 greeter from NUR, or maybe
          greeters.gtk = {
            enable = true;
            theme = {
              package = pkgs.colloid-gtk-theme;
              name = "Colloid-Dark";
            };
            cursorTheme = {
              package = pkgs.phinger-cursors;
              name = "Phinger Cursors (light)";
            };
            iconTheme = {
              package = pkgs.qogir-icon-theme;
              name = "Qogir-dark";
            };
            indicators = ["~session" "~spacer"];
          };
        };
      };

      windowManager.session =
        singleton
        {
          name = "awesome";
          start = ''
            ${pkgs.awesome-git-luajit}/bin/awesome ${makeSearchPath luaModules} &
            waitPID=$!
          '';
        };
    };
    # ------------------------------------------------- #
    # TODO lint the other packages and pull out the awesome dependencies
    environment.systemPackages = lib.attrValues {
      inherit
        (pkgs)
        awesome-git-luajit
        maim
        xclip
        xdotool
        xsel
        ;

      inherit
        (pkgs.gnome3)
        dconf-editor
        ;

      inherit
        (pkgs.xfce)
        xfce4-clipman-plugin
        xfconf
        xfce4-settings
        xfce4-dev-tools
        libxfce4util
        libxfce4ui
        exo
        ;

      inherit
        (pkgs.xorg)
        xwininfo
        ;
    };
  };
}
