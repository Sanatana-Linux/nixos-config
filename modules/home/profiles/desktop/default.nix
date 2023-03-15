{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    cursorTheme.name = "phinger-cursors-light";
    iconTheme.name = "Fluent-dark";
    theme.name = "Jasper-Grey-Dark-Compact";
  };
}
