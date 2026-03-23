{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.users.smg;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.modules.users.smg = {
    enable = mkEnableOption "Create user account for smg";

    shell = mkOption {
      type = types.package;
      default = pkgs.zsh;
      description = "Default shell for user smg";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional groups for user smg";
    };

    initialPassword = mkOption {
      type = types.str;
      default = "password";
      description = "Initial password for user smg";
    };

    homeManagerConfig = mkOption {
      type = types.path;
      default = ../../../home/smg/default.nix;
      description = "Path to home-manager configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.mutableUsers = true;

    users.users.smg = {
      name = "smg";
      description = "Sara Marie Guidotti";
      initialPassword = "password";
      isNormalUser = true;
      uid = 1001;
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
          "plugdev"
          "adbusers"
          "docker"
          "podman"
          "git"
          "libvirtd"
          "lp"
          "mysql"
          "network"
          "networkmanager"
          "power"
          "i2c"
          "systemd-journal"
          "tss"
          "video"
          "wireshark"
        ]
        ++ cfg.extraGroups;

      packages = [pkgs.home-manager];
    };

    home-manager.users.smg = import cfg.homeManagerConfig;
  };
}
