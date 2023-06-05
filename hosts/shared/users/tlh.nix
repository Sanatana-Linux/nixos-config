{
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # just until implementing the impermanence module
  users.mutableUsers = true;
  users.users.tlh = {
    description = "Thomas Leon Highbaugh";
    initialPassword = "nixos";
    isNormalUser = true;
    uid = 1000;
    extraGroups =
      [
        "wheel"
        "video"
        "audio"
        "input"
      ]
      ++ ifTheyExist [
        "network"
        "networkmanager"
        "wireshark"
        "mysql"
        "docker"
        "podman"
        "git"
        "libvirtd"
      ];

    packages = [pkgs.home-manager];
  };

  home-manager.users.tlh = import ../../../home/tlh/${config.networking.hostName};
}
