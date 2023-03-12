# this file basically configures everything needed to get working
# a virtualization with virt-manager.

{ ... }:

{
  virtualisation.libvirtd.enable = true;
  #virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "tlh" ];
  programs.dconf.enable = true;
    # docker
  virtualisation.docker.enable = true;
}
