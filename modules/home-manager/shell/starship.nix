{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.starship;
in {
  options.modules.shell.starship = {
    enable = mkEnableOption "Starship prompt with custom configuration";

    enableZshIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable ZSH integration";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

    programs.starship = {
      enable = true;
      enableZshIntegration = cfg.enableZshIntegration;
      settings = {
        scan_timeout = 10;
        add_newline = true;
        line_break.disabled = true;

        format = "$directory$git_branch$git_metrics$git_commit$git_state$git_status$all";

        character = {
          success_symbol = "[🕉](green)";
          error_symbol = "[🕉](red)";
          vimcmd_symbol = "[🕉](green)";
        };

        directory = {
          home_symbol = "home";
          style = "cyan";
          read_only = " ro";
        };

        git_commit.tag_symbol = " tag ";
        git_branch = {
          style = "purple";
          symbol = "";
        };

        git_metrics = {
          added_style = "bold yellow";
          deleted_style = "bold red";
          disabled = false;
        };

        # Programming language symbols
        aws.symbol = "aws ";
        bun.symbol = "bun ";
        c.symbol = "C ";
        cobol.symbol = "cobol ";
        conda.symbol = "conda ";
        crystal.symbol = "cr ";
        cmake.symbol = "cmake ";
        daml.symbol = "daml ";
        dart.symbol = "dart ";
        deno.symbol = "deno ";
        dotnet.symbol = ".NET ";
        docker_context.symbol = "docker ";
        elixir.symbol = "exs ";
        elm.symbol = "elm ";
        golang.symbol = "go ";
        guix_shell.symbol = "guix ";
        hg_branch.symbol = "hg ";
        java.symbol = "java ";
        julia.symbol = "jl ";
        kotlin.symbol = "kt ";
        lua.symbol = "lua ";
        memory_usage.symbol = "memory ";
        meson.symbol = "meson ";
        nim.symbol = "nim ";
        nix_shell.symbol = "nix ";
        ocaml.symbol = "ml ";
        opa.symbol = "opa ";
        nodejs.symbol = "nodejs ";
        package.symbol = "pkg ";
        perl.symbol = "pl ";
        php.symbol = "php ";
        pulumi.symbol = "pulumi ";
        purescript.symbol = "purs ";
        python.symbol = "py ";
        raku.symbol = "raku ";
        ruby.symbol = "rb ";
        rust.symbol = "rs ";
        scala.symbol = "scala ";
        spack.symbol = "spack ";
        sudo.symbol = "sudo ";
        swift.symbol = "swift ";
        terraform.symbol = "terraform ";
        zig.symbol = "zig ";
      };
    };
  };
}
