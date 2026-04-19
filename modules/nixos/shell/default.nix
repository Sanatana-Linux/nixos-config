{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.modules.shell;
in {
  imports = [./variables.nix];

  options.modules.shell = {
    enable = mkEnableOption "Shell environment configuration";

    zsh = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ZSH as default shell";
    };

    defaultShell = mkOption {
      type = types.enum ["bash" "zsh"];
      default =
        if cfg.zsh
        then "zsh"
        else "bash";
      description = "Default shell for users";
    };
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = mkIf cfg.zsh pkgs.zsh;

    programs.zsh = mkIf cfg.zsh {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    environment.pathsToLink = mkIf cfg.zsh ["/share/zsh"];

    environment.systemPackages = with pkgs;
      mkIf cfg.zsh [
        zsh
        zsh-completions
      ];
  };
}
