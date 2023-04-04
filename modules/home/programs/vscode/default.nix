{ config, pkgs }:

{
  home.packages = with pkgs; [
    luaFormatter
  ];

  programs.vscode = {
    enable = true;
    userSettings = {
      "workbench.colorTheme" = "Xresources Bordered Theme";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.bracketPairColorization.enabled" = true;
      "editor.fontFamily" = "mplus Nerd Font Mono Medium";
      "terminal.integrated.fontFamily" = "monospace";
      "editor.fontLigatures" = true;
      "editor.cursorStyle" = "line-thin";
      "editor.fontSize" = 13;
      "editor.defaultFormatter" = "Koihik.vscode-lua-format";
      "vscode-lua-format.binaryPath" = "${pkgs.luaFormatter}/bin/lua-format";
      "vscode-lua-format.configPath" = "${config.xdg.configHome}/LuaFormatter.cfg";
      "window.menuBarVisibility" = "toggle";
      "editor.tabSize" = 2;
      "editor.inlineSuggest.enabled" = true;
      "[python]"."editor.tabSize" = 4;
      "editor.wordWrap" = "on";
       "files.autoSave" = "onFocusChange";
       "nix.enableLanguageServer.enabled" = true;
    };
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      esbenp.prettier-vscode
      naumovs.color-highlight
      svelte.svelte-vscode
      sumneko.lua
      stkb.rewrap
      spywhere.guides
      adpyke.codesnap
      tyriar.sort-lines
      timonwong.shellcheck
      rioj7.commandOnAllFiles
      naumovs.color-highlight
      foxundermoon.shell-format
      editorconfig.editorconfig
      coolbear.systemd-unit-file
      brettm12345.nixfmt-vscode
      formulahendry.auto-close-tag
      alefragnani.project-manager
      mads-hartmann.bash-ide-vscode
      streetsidesoftware.code-spell-checker
      christian-kohler.path-intellisense
      ms-toolsai.jupyter

    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "volar";
        publisher = "vue";
        version = "1.0.12";
        sha256 = "sha256-D9E3KRUOlNVXH4oMv1W0+/mbqO8Se7+6E2F5P/KvCro=";
      }
      {
        name = "material-icon-theme";
        publisher = "pkief";
        version = "4.22.0";
        sha256 = "sha256-U9P9BcuZi+SUcvTg/fC2SkjGRD4CvgJEc1i+Ft2OOUc=";
      }
      {
        name = "vscode-lua-format";
        publisher = "koihik";
        version = "1.3.8";
        sha256 = "sha256-ACdjiy+Rj2wmxvSojaJmtCwyryWWB+OA/9hBEMJi39g=";
      }
    ];
  };

  xdg.configFile."LuaFormatter.cfg".text = ''
    indent_width: 2
    use_tab: false
    keep_simple_control_block_one_line: false
    keep_simple_function_one_line: false
    single_quote_to_double_quote: true
    chop_down_table: true
    chop_down_kv_table: true
  '';
}
