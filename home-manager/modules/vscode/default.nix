{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.programs.vscode;
in {
  options.tlh.programs.vscode.enable = mkEnableOption "enable vscode";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      userSettings = {
        "nix" = {
          "enableLanguageServer" = true;
          "serverPath" = "${pkgs.nil}/bin/nil";
          "serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = ["${pkgs.alejandra}/binalejandra"];
              };
            };
          };
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
      };

      extensions = with pkgs.vscode-extensions; [
        adpyke.codesnap
        dracula-theme.theme-dracula
        eamodio.gitlens
        file-icons.file-icons
        github.copilot
        jnoortheen.nix-ide
        mechatroner.rainbow-csv
        ms-python.python
        ms-toolsai.jupyter
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.powershell
        ms-vscode-remote.remote-ssh
        ms-vsliveshare.vsliveshare
        oderwat.indent-rainbow
        ritwickdey.liveserver
        valentjn.vscode-ltex
      ];
    };
  };
}
