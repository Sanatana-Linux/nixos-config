{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.attrValues {
    inherit
      (pkgs)
      dbus-broker
      eggdbus
      bc
      feh
      fzf
      gnome-keyring
      meson-tools
      meson
      go
      gopls
      grex
      imagemagick
      keychain
      killall
      libgnome-keyring
      walk
      wf-recorder
      xdg-desktop-portal
      ;
    inherit
      (pkgs.xorg)
      xev
      ;
    pylsp = pkgs.python311.withPackages (p:
      with p; [
        flake8
        python-lsp-server
      ]);
  };
}
