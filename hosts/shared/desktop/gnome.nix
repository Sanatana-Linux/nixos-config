{pkgs, ...}: {
  imports = [
    ./dconf.nix
  ];
  services.desktopManager.gnome.enable = true;

  services.gnome.gnome-initial-setup.enable = false;
  services.gnome.games.enable = true;

  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-tour
    pkgs.gnome-text-editor
    pkgs.gnome-user-docs
  ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.burn-my-windows
    gnomeExtensions.compact-top-bar
    gnomeExtensions.custom-accent-colors
    gradience
    gnomeExtensions.gtile
    gnomeExtensions.dash-to-panel
    gnomeExtensions.tray-icons-reloaded
    gnome-tweaks
    gnomeExtensions.arcmenu
    gnomeExtensions.paperwm
    gnomeExtensions.just-perfection
    gnomeExtensions.vitals
  ];
}
