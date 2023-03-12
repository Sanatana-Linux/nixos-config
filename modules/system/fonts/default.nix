{ config, pkgs, ... }:

{
  fonts = {
    fonts =  with pkgs; [
      google-fonts
      inter
      kreative-square-fonts
      material-symbols
      mplus-outline-fonts.githubRelease
      nerdfonts
      norwester-font
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      powerline-fonts
      profont
      proggyfonts
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = true;
        style = "hintslight";
      };

      subpixel.lcdfilter = "default";

      defaultFonts = {
        monospace = [ "mplus Nerd Font Mono Medium " ];
        sansSerif = [ "mplus Nerd Font Mono Medium " ];
        serif = [ "mplus Nerd Font Mono Medium " ];
      };
    };
  };
}
