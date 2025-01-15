{
  pkgs,
  inputs,
  config,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    installVimSyntax = true;

    settings = {
      background-blur-radius = 20;
      theme = "dark:Monokai Pro Spectrum,light:Monokai Pro Light";
      window-theme = "dark";
      window-decoration = false;
      background-opacity = 0.8;
      minimum-contrast = 1.1;
      window-padding-x = 2;
      window-padding-y = 2;
      gtk-adwaita = false;
      gtk-single-instance = false;
    };
  };
}
