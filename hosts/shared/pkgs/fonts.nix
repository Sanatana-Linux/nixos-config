{pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [
      cantarell-fonts
      fira
      font-awesome
      font-awesome_4
      font-awesome_5
      google-fonts
      inter
      kreative-square-fonts
      lato
      line-awesome
      maple-mono
      maple-mono-NF
      maple-mono-SC-NF
      material-symbols
      mplus-outline-fonts.githubRelease
      nerdfonts
      norwester-font
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      powerline-fonts
      profont
      proggyfonts
      psftools
      roboto-slab
      terminus-nerdfont
      terminus_font
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
        emoji = ["Noto Color Emoji"];
        monospace = ["Maple Mono NF"];
        sansSerif = ["Lato"];
        serif = ["Roboto Slab"];
      };
    };
  };
}
