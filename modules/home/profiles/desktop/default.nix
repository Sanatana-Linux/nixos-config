{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    cursorTheme.name = "phinger-cursors-light";
    iconTheme.name = "Fluent-dark";
    theme.name = "Jasper-Grey-Dark-Compact";
  };


  # services
  services.playerctld.enable = true;

  # editor (nvim)
  systemd.user.sessionVariables.EDITOR = "nvim";

}
