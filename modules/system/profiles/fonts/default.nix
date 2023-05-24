{
  config,
  pkgs,
  ...
}: {
  fonts = {
    fonts = with pkgs; [
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
        monospace = ["GohuFont uni-11 Nerd Font Propo "];
        sansSerif = ["Asap Condensed, Semi-Bold Condensed "];
        serif = ["Agave Nerd Font Propo Bold "];
      };
    };
  };
}
