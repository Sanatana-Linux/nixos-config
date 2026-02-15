{pkgs, ...}: {
  # Enable VirtualBox with the Extension Pack
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true; # Adds USB support
}
