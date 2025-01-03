{pkgs, config, ...}:{
  imports = inputs.ghostty;
  {
  enable = true;
  package = inputs.ghostty.packages.${system}.default;
  shellIntegration.enable = true;

  settings = {
    background-blur-radius = 20;
    theme = "dark:catppuccin-mocha,light:catppuccin-latte";
    window-theme = "dark";
    background-opacity = 0.8;
    minimum-contrast = 1.1;
  };

  keybindings = {
    # keybind = global:ctrl+`=toggle_quick_terminal
    "global:ctrl+`" = "toggle_quick_terminal";
  };
};
}

