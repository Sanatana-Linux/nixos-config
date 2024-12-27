{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      agave
      ankacoder
      ankacoder-condensed
      annapurna-sil
      arkpandora_ttf
      b612
      cascadia-code # microsoft ligatures font
      cm_unicode
      corefonts
      d2coding
      departure-mono
      dina-font
      envypn-font
      font-awesome
      font-awesome_4
      font-awesome_5
      fontpreview
      hackgen-font
      hackgen-nf-font
      hermit
      icomoon-feather
      inter
      jost
      kanit-font
      line-awesome
      material-symbols
      mplus-outline-fonts.githubRelease
      nerd-fonts._3270
      nerd-fonts.agave
      nerd-fonts.mplus
      nerd-fonts.ubuntu
      norwester-font
      noto-fonts # I really hate these fonts
      noto-fonts-cjk-sans # but its better than scripts not rendering
      noto-fonts-emoji # I guess...
      noto-fonts-extra
      ocr-a
      pixel-code
      powerline-fonts
      proggyfonts
      rounded-mgenplus
      scientifica
      serious-sans
      sf-mono-liga-bin
      siji
      sudo-font
      terminus_font
      undefined-medium
      uni-vga
      unifont
      unifont_upper
      vistafonts
      xkcd-font
      xlsfonts
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = true;
        style = "slight";
      };

      subpixel.lcdfilter = "default";

      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["Liga SFMono Nerd Font Medium"];
        sansSerif = ["Liga SFMono Nerd Font Semibold"];
        serif = ["Liga SFMono Nerd Font Semibold"];
      };
    };
  };
}
