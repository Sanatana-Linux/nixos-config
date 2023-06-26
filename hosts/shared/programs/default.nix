{
  lib,
  pkgs,
  ...
}: {
  imports = [./nix-ld.nix];

  hardware = {
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
  programs = {
    # bash.promptInit = ''eval "$(${lib.getExhosts/shared/programs/default.nixe pkgs.starship} init bash)"'';

    java = {
      enable = true;
      package = pkgs.jre;
    };
    # gnome's keyring manager
    seahorse.enable = true;

    # help manage android devices via command line
    adb.enable = true;

    # networkmanager tray uility
    nm-applet.enable = false;

    # allow users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        xfce.thunar-archive-plugin
        xfce.thunar-volman
        xfce.thunar-dropbox-plugin
        xfce.thunar-media-tags-plugin
        xarchiver
        archiver
        _7zz
        mozlz4a
        arj
        zip
        runzip
        tarlz
        unzip
        ranger
        dejsonlz4
        gnutar
        zziplib
        libfm
        libfm-extra
        gnome.file-roller
      ];
    };
    # ------------------------------------------------- #
  };
}
