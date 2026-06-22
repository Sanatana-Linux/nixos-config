{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.shell;
in {
  imports = [./variables.nix];

  options.modules.base.shell = {
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

    tools = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Shell utility packages (modern tools, system utils, zsh plugins)";
      };
      modernTools = mkOption {
        type = types.bool;
        default = true;
        description = "Modern shell tools (bat, eza, fd)";
      };
      systemUtils = mkOption {
        type = types.bool;
        default = true;
        description = "System utility commands";
      };
      fileManagement = mkOption {
        type = types.bool;
        default = true;
        description = "File management tools";
      };
      downloadTools = mkOption {
        type = types.bool;
        default = true;
        description = "Download utilities";
      };
      zshPlugins = mkOption {
        type = types.bool;
        default = true;
        description = "ZSH plugins and enhancements";
      };
      inputSupport = mkOption {
        type = types.bool;
        default = true;
        description = "Input device support";
      };
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
      optionals cfg.zsh [
        zsh
        zsh-completions
      ]
      # Shell utility packages (modern tools, system utils, file management, zsh plugins)
      ++ optionals cfg.tools.enable (
        [
          bash-completion
          curl
        ]
        ++ optionals cfg.tools.modernTools [
          bat
          eza
          fd
          fzf
          fzy
          ripgrep
          btop
        ]
        ++ optionals cfg.tools.systemUtils [
          killall
          trash-cli
          jdupes
          clipster
          boxes
          beep
          viu
          chafa
          ueberzugpp
        ]
        ++ optionals cfg.tools.fileManagement [
          tree
        ]
        ++ optionals cfg.tools.downloadTools [
          aria2
          rclone
        ]
        ++ optionals cfg.tools.zshPlugins [
          zsh-autocomplete
          zsh-edit
          zsh-navigation-tools
          zsh-you-should-use
        ]
        ++ optionals cfg.tools.inputSupport [
          libinput
          libdbusmenu
          libdbusmenu-gtk3
        ]
      );
  };
}
