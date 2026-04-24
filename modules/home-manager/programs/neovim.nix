{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.neovim;
in {
  options.modules.programs.neovim = {
    enable = mkEnableOption "Neovim text editor with comprehensive configuration";

    withNodeJs = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Node.js support for Neovim";
    };
    withPython3 = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Python support for Neovim";
    };

    withRuby = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Ruby support for Neovim";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages to include with Neovim";
    };
  };

  config = mkIf cfg.enable {
    home.activation.linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ -L ${config.home.homeDirectory}/.config/nvim ]; then
        rm -f ${config.home.homeDirectory}/.config/nvim
      elif [ -d ${config.home.homeDirectory}/.config/nvim ]; then
        rm -rf ${config.home.homeDirectory}/.config/nvim
      fi
      mkdir -p ${config.home.homeDirectory}/.config
      $DRY_RUN_CMD ln -sfn /etc/nixos/external/nvim ${config.home.homeDirectory}/.config/nvim
    '';

    home.packages =
      [
        (pkgs.neovim.override {
          withNodeJs = cfg.withNodeJs;
          withPython3 = cfg.withPython3;
          withRuby = cfg.withRuby;
        })
      ]
      ++ (with pkgs; [
        yarn
        fswatch
        cmake
        imagemagick
        tree-sitter
        nodejs
        gcc
      ])
      ++ cfg.extraPackages;

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Shell aliases for vi/vim/vimdiff
    programs.bash.shellAliases = mkIf config.programs.bash.enable {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };

    programs.zsh.shellAliases = mkIf config.programs.zsh.enable {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };

    programs.fish.shellAliases = mkIf config.programs.fish.enable {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
  };
}
