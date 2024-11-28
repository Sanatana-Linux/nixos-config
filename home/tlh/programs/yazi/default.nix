{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "r";
  };

  home.file = {
    ".config/yazi/yazi.toml".source = ./yazi.toml;
    ".config/yazi/keymap.toml".source = ./keymap.toml;
    ".config/yazi/theme.toml".source = ./theme.toml;
  };

}
