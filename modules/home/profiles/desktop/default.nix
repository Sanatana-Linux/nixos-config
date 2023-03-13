{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    cursorTheme.name = "Numix-Cursor-Light";
    iconTheme.name = "Fluent-dark";
    theme.name = "Jasper-Grey-Dark-Compact";
  };
}
