{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.users.user;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  options.modules.users.user = {
    enable = mkEnableOption "Create default user account for live ISO";

    shell = mkOption {
      type = types.package;
      default = pkgs.zsh;
      description = "Default shell for user";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional groups for user";
    };

    initialPassword = mkOption {
      type = types.str;
      default = "";
      description = "Initial password for user (empty = locked, use passwd)";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    environment.variables.EDITOR = "nvim";
    users.mutableUsers = true;

    users.users.user = {
      name = "user";
      description = "Default User";
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
          "plugdev"
          "docker"
          "podman"
          "git"
          "lp"
          "network"
          "networkmanager"
          "power"
          "systemd-journal"
        ]
        ++ cfg.extraGroups;

      packages = [pkgs.home-manager];
    };

    # home-manager.users.user is configured in flake.nix via:
    #   home-manager.users.user = {imports = [./home/user/default.nix];}
    # Do NOT set it here — double-wiring causes home-manager generation conflicts.
  };
}
