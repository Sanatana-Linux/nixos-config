{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.packages.development;
in {
  options.modules.packages.development = {
    enable = mkEnableOption "Development tools and programming utilities";

    rustTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Rust development tools";
    };

    webTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable web development tools (Node.js, Bun, etc.)";
    };

    gitTools = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Git and version control tools";
    };

    linters = mkOption {
      type = types.bool;
      default = true;
      description = "Enable linting and code quality tools";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional development packages to install";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        # Core development tools
        bc
        cmake
        direnv
        fuse3
        getopt
        gettext
        boxes
        brotli
      ]
      ++ optionals cfg.rustTools [
        cargo
      ]
      ++ optionals cfg.webTools [
        bun
        cached-nix-shell
        any-nix-shell
      ]
      ++ optionals cfg.gitTools [
        git
        gh
        gist
        bfg-repo-cleaner
      ]
      ++ optionals cfg.linters [
        actionlint
        deadnix
        eslint_d
        commitlint-rs
        dotenv-linter
        diagnostic-languageserver
      ]
      ++ cfg.extraPackages;
  };
}
