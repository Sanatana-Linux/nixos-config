{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.users.tlh;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.modules.users.tlh = {
    enable = mkEnableOption "Create user account for tlh";

    shell = mkOption {
      type = types.package;
      default = pkgs.zsh;
      description = "Default shell for user tlh";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional groups for user tlh";
    };

    initialPassword = mkOption {
      type = types.str;
      default = "";
      description = "Initial password for user tlh (empty = locked, use passwd)";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    environment.variables.EDITOR = "nvim";
    users.mutableUsers = true;
    # xdg.userDirs.setSessionVariables = true;
    users.users.tlh = {
      name = "tlh";
      description = "Thomas Leon Highbaugh";
      initialPassword = cfg.initialPassword;
      initialHashedPassword = "!";
      isNormalUser = true;
      uid = 1000;
      shell = cfg.shell;
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
          "power"
          "systemd-journal"
          "tss"
          "waydroid"
          "wireshark"
          "zfs_member"
        ]
        ++ cfg.extraGroups;

      packages = [pkgs.home-manager];
    };

    # home-manager.users.tlh is configured in flake.nix via:
    #   home-manager.users.tlh = {imports = [./home/tlh/default.nix];}
    # Do NOT set it here — double-wiring causes home-manager generation
    # conflicts where zsh init files (.zshrc, .zshenv, .zprofile) fail to
    # symlink into ~/.config/zsh/ on fresh shells.
  };
}
