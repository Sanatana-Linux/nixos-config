{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  marketplace-extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
    johnnymorganz.stylua
    ms-python.black-formatter
    ms-python.python
    rvest.vs-code-prettier-eslint
    sndst00m.markdown-github-dark-pack
  ];
in {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    extensions = with pkgs.vscode-extensions;
      [
        adpyke.codesnap
        bbenoist.nix
        brettm12345.nixfmt-vscode
        catppuccin.catppuccin-vsc
        christian-kohler.path-intellisense
        coolbear.systemd-unit-file
        dbaeumer.vscode-eslint
        eamodio.gitlens
        editorconfig.editorconfig
        esbenp.prettier-vscode
        formulahendry.auto-close-tag
        formulahendry.auto-rename-tag
        foxundermoon.shell-format
        golang.go
        irongeek.vscode-env
        jnoortheen.nix-ide
        jock.svg
        kamadorueda.alejandra
        mads-hartmann.bash-ide-vscode
        mkhl.direnv
        ms-python.vscode-pylance
        naumovs.color-highlight
        oderwat.indent-rainbow
        pkief.material-icon-theme
        pkief.material-product-icons
        rioj7.commandonallfiles
        spywhere.guides
        stkb.rewrap
        streetsidesoftware.code-spell-checker
        sumneko.lua
        timonwong.shellcheck
        tyriar.sort-lines
        usernamehw.errorlens
        usernamehw.errorlens
        vadimcn.vscode-lldb
        xaver.clang-format
      ]
      ++ marketplace-extensions;

    userSettings = {
      breadcrumbs.enabled = true;
      emmet.useInlineCompletions = true;
      security.workspace.trust.enabled = false;
      black-formatter.path = "${pkgs.black}/bin/black";
      stylua.styluaPath = "${pkgs.stylua}/bin/stylua";
      Lua.misc.executablePath = "${pkgs.sumneko-lua-language-server}/bin/lua-language-server";
      CodeGPT.Autocomplete.enabled = true;
      github.copilot.enable.markdown = true;
      github.copilot.enable.plaintext = true;
      codeium.enableConfig."*" = true;
      codeium.aggressiveShutdown = true;
      "[c]".editor.defaultFormatter = "xaver.clang-format";
      "[cpp]".editor.defaultFormatter = "xaver.clang-format";
      "[css]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[html]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[javascript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[json]".editor.defaultFormatter = "esbenp.prettier-vscode";
      "[jsonc]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[lua]".editor.defaultFormatter = "johnnymorganz.stylua";
      "[nix]".editor.defaultFormatter = "kamadorueda.alejandra";
      "[rust]".editor.defaultFormatter = "rust-lang.rust-analyzer";
      "[scss]".editor.defaultFormatter = "sibiraj-s.vscode-scss-formatter";
      "[typescript]".editor.defaultFormatter = "rvest.vs-code-prettier-eslint";
      "[python]".editor = {
        defaultFormatter = "ms-python.black-formatter";
        formatOnType = true;
      };

      editor = {
        cursorBlinking = "smooth";
        cursorSmoothCaretAnimation = "on";
        cursorWidth = 2;
        find.addExtraSpaceOnTop = false;
        formatOnSave = true;
        inlayHints.enabled = "off";
        inlineSuggest.enabled = true;
        largeFileOptimizations = false;
        lineNumbers = "on";
        linkedEditing = true;
        maxTokenizationLineLength = 60000;
        overviewRulerBorder = false;
        quickSuggestions.strings = true;
        renderWhitespace = "none";
        renderLineHighlight = "all";
        smoothScrolling = true;
        suggest.showStatusBar = true;
        suggestSelection = "first";
        bracketPairColorization = {
          enabled = true;
          independentColorPoolPerBracketType = true;
        };
        codeActionsOnSave.source = {
          organizeImports = true;
          fixAll.eslint = true;
        };
        guides = {
          bracketPairs = true;
          indentation = true;
        };
      };

      explorer = {
        confirmDragAndDrop = true;
        confirmDelete = true;
      };

      files = {
        autoSave = "afterDelay";
        eol = "\n";
        insertFinalNewline = true;
        trimTrailingWhitespace = true;
        autoSaveDelay = 1000;
        exclude = {
          "**/.classpath" = true;
          "**/.direnv" = true;
          "**/.factorypath" = true;
          "**/.git" = true;
          "**/.project" = true;
          "**/.settings" = true;
          "**/.settings*" = true;
        };
        autoSaveExclude = {
          "**/.settings.json" = true;
        };
        watcherExclude = {
          "**/.settings.json" = true;
        };
      };

      git = {
        autofetch = true;
        confirmSync = false;
        enableSmartCommit = true;
      };

      terminal.integrated = {
        cursorBlinking = true;
        cursorStyle = "line";
        cursorWidth = 2;
        fontFamily = "'monospace'";
        fontSize = 11;
        smoothScrolling = true;
      };

      window = {
        menuBarVisibility = "toggle";
        zoomLevel = 1;
      };

      workbench = {
        settings.enableEdit = false;
        ignoreInvalidSettings = true;
        editor.tabCloseButton = "left";
        iconTheme = "material-icon-theme";
        list.smoothScrolling = true;
        productIconTheme = "material-product-icons";
        smoothScrolling = true;
      };
    };
  };
}
