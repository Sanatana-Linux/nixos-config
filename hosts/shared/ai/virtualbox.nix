{pkgs, ...}: {
  # Enable VirtualBox with the Extension Pack
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true; # Adds USB support

  # Add your user to the vboxusers group
  users.users.yourusername.extraGroups = ["vboxusers"];
}
