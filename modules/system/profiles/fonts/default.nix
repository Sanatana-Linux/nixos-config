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
      font-awesome
      line-awesome 
      font-awesome_4
      font-awesome_5
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
        monospace = [ "BigBlueTerm Nerd Font Mono Regular " ];
        sansSerif = [ "BigBlueTerm Nerd Font Mono Regular " ];
        serif = [ "BigBlueTerm Nerd Font Mono Regular " ];
      };
    };
  };
}
