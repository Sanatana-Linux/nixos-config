{
  config,
  pkgs,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # just until implementing the impermanence module
  programs.zsh.enable = true;
  users.mutableUsers = true;
  users.users.smg = {
    description = "Sara Marie Guidotti";
    initialPassword = "password";
    isNormalUser = true;
    uid = 1001;
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

  home-manager.users.smg = import ../../../home/smg/default.nix;
}
