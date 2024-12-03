{
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # just until implementing the impermanence module
  users.mutableUsers = true;
  programs.zsh.enable = true;
  users.users.tlh = {
    description = "Thomas Leon Highbaugh";
    initialPassword = "password";
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups =
      [
        "wheel"
        "video"
        "nix"
        "audio"
        "input"
      ]
      ++ ifTheyExist [
        "docker"
        "git"
        "libvirtd"
        "lp"
        "mysql"
        "network"
        "networkmanager"
        "plugdev"
        "podman"
        "power"
        "systemd-journal"
        "tss"
        "video"
        "wireshark"
      ];

    packages = [pkgs.home-manager];
  };

  home-manager.users.tlh = import ../../../home/tlh/default.nix;
}
