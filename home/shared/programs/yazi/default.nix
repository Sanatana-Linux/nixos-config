{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "r";
    enableZshIntegration = true;
    enableBashIntegration = true;
    plugins = {
      "yazi-plugin-mount" = pkgs.yaziPlugins.mount;
      "yazi-plugin-mime-ext" = pkgs.yaziPlugins.mime-ext;
      "yazi-plugin-ouch" = pkgs.yaziPlugins.ouch;
      "yazi-plugin-restore" = pkgs.yaziPlugins.restore;
    };
  };

  home.file = {
    ".config/yazi/yazi.toml".source = ./yazi.toml;
    ".config/yazi/keymap.toml".source = ./keymap.toml;
    ".config/yazi/theme.toml".source = ./theme.toml;
  };
}
