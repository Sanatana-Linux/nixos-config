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
      default = "";
      description = "Initial password for user smg (empty = locked, use passwd)";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.mutableUsers = true;

    users.users.smg = {
      name = "smg";
      description = "Sara Marie Guidotti";
      initialPassword = cfg.initialPassword;
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

    # home-manager.users.smg is configured in flake.nix via:
    #   home-manager.users.smg = {imports = [./modules/home-manager/users/smg/default.nix];}
    # Do NOT set it here — double-wiring causes home-manager generation
    # conflicts where zsh init files fail to symlink on fresh shells.
  };
}
