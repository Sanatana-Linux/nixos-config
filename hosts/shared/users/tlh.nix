{
  config,
  inputs,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  programs.zsh.enable = true;
  # Please don't mute me since I am mutable!
  users.mutableUsers = true;
  users.users.tlh = {
    name = "tlh";
    description = "Thomas Leon Highbaugh"; # That's me in case you didn't know :P
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
