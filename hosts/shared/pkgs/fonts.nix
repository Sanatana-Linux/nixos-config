{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      agave
      ankacoder
      ankacoder-condensed
      annapurna-sil
      b612
      cascadia-code # microsoft ligatures font
      corefonts
      d2coding
      font-awesome_4
      font-awesome_5
      font-awesome_6
      icomoon-feather
      inter
      jost
      kanit-font
      material-symbols
      material-design-icons
      mplus-outline-fonts.githubRelease
      nerd-fonts._3270
      nerd-fonts.agave
      #      nerd-fonts.mplus
      nerd-fonts.ubuntu
      norwester-font
      noto-fonts # I really hate these fonts
      noto-fonts-cjk-sans # but its better than scripts not rendering
      noto-fonts-emoji # I guess...
      noto-fonts-extra
      ocr-a
      pixel-code
      proggyfonts
      rounded-mgenplus
      siji
      sudo-font
      terminus_font
      undefined-medium
      vistafonts
      xkcd-font
    ];

    fontconfig = {
      enable = true;
      cache32Bit = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = true;
        style = "slight";
      };

      subpixel.lcdfilter = "default";

      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["BerkeleyMono Nerd Font Bold"];
        sansSerif = ["Berkeley Mono Variable Semi-Bold"];
        serif = ["TX-02 Medium Oblique Condensed"];
      };
    };
  };
}
