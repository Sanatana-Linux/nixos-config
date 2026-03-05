{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.programs.zathura.enable = mkEnableOption "Zathura PDF viewer";

  config = mkIf config.modules.programs.zathura.enable {
    programs.zathura = {
      enable = true;
      options = {
        default-bg = "#1e1e1e";
        default-fg = "#e6e6e6";

        statusbar-bg = "#2d2d2d";
        statusbar-fg = "#e6e6e6";

        inputbar-bg = "#2d2d2d";
        inputbar-fg = "#e6e6e6";

        notification-bg = "#2d2d2d";
        notification-fg = "#e6e6e6";

        notification-error-bg = "#cc6666";
        notification-error-fg = "#2d2d2d";

        notification-warning-bg = "#f0c674";
        notification-warning-fg = "#2d2d2d";

        highlight-color = "#f0c674";
        highlight-active-color = "#81a2be";

        completion-bg = "#2d2d2d";
        completion-fg = "#e6e6e6";
        completion-group-bg = "#373b41";
        completion-group-fg = "#e6e6e6";
        completion-highlight-bg = "#81a2be";
        completion-highlight-fg = "#2d2d2d";

        index-bg = "#2d2d2d";
        index-fg = "#e6e6e6";
        index-active-bg = "#81a2be";
        index-active-fg = "#2d2d2d";

        render-loading = true;
        scroll-step = 50;
        zoom-min = 10;
        guioptions = "";
      };
    };
  };
}
