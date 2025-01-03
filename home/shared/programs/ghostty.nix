{pkgs, inputs, config, ...}:{
  imports =[ inputs.ghostty-hm-module.homeModules.default];
  programs.ghostty = {
  enable = true;
  package = pkgs.ghostty;
  shellIntegration.enable = true;
  shellIntegration.enableZshIntegration = true;
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

