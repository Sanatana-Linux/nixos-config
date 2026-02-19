{
  config,
  inputs,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  programs.zsh.enable = true;
  environment.variables.EDITOR = "nvim";
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
        "i2c"
        "plugdev"
        "adbusers"
        "docker"
        "podman"
        "git"
        "libvirtd"
        "lp"
        "mysql"
        "network"
        "qemu"
        "libvirt-qemu"
        "libvirt"
        "kvm"
        "networkmanager"
        "plugdev"
        "podman"
        "power"
        "systemd-journal"
        "tss"
        "video"
        "waydroid"
        "wireshark"
      ];

    packages = [pkgs.home-manager];
  };
  home-manager.users.tlh = import ../../../home/tlh/default.nix;
}
