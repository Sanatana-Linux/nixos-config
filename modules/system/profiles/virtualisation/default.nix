# Because virtualization remains one of things I find most fascinating

{ ... }:

{
  virtualisation.libvirtd.enable = true;
  #virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "tlh" ];
  programs.dconf.enable = true;
    # docker
  virtualisation.docker.enable = true;

  virtualisation.appvm = {
  enable = true;
  user = "tlh";
};
}
