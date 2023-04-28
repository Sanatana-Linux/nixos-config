{ config, pkgs, lib, ... }:

{
 # For saving passwords
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  programs.seahorse.enable = true;
    programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  # good old dbus
  services.dbus = {
    enable = true;
    packages = with pkgs; [ dconf gcr ];
  };


  # Everything is bad without it
  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # upower
  services.upower.enable = true;

  # Enable touchpad support (enabled default in most desktopManagers but this is linux so better to be safe than irritated).
  services.xserver.libinput= {
    enable = true;
                pointer_accel = "0.63";
      accel_profile = "flat"; # flat good adaptive trash
  };
  hardware.opengl = { enable = true; };

  # light
  programs.light.enable = true;

  services.xserver.desktopManager.xfce.enable = true;

  # automount usb
  services.devmon.enable = true;
  services.udisks2.enable = true;

  # acpid
  services.acpid.enable = true;




}
