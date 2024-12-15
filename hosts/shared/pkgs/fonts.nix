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
      creep #
      d2coding
      departure-mono
      dina-font
      envypn-font
      f5_6
      font-awesome
      font-awesome_4
      font-awesome_5
      fontpreview
      google-fonts
      hackgen-font
      hackgen-nf-font
      hermit
      hyperscrypt-font
      inter
      jost
      kanit-font
      kreative-square-fonts
      lato
      line-awesome
      manrope
      material-symbols
      monocraft
      mononoki
      mplus-outline-fonts.githubRelease
      nerd-fonts._3270
      nerd-fonts.agave
      nerd-fonts.lilex
      nerd-fonts.mplus
      nerd-fonts.overpass
      nerd-fonts.ubuntu
      nerd-fonts.zed-mono
      norwester-font
      noto-fonts # I really hate these fonts
      noto-fonts-cjk-sans # but its better than scripts not rendering
      noto-fonts-emoji # I guess...
      noto-fonts-extra
      ocr-a
      oldstandard
      paratype-pt-mono
      paratype-pt-sans
      paratype-pt-serif
      pixel-code
      powerline-fonts
      proggyfonts
      scheherazade-new
      scientifica
      serious-sans
      sf-mono-liga-bin
      siji
      spleen
      sudo-font
      tamzen
      terminus_font
      termsyn
      tewi-font
      times-newer-roman
      tt2020
      u001-font
      undefined-medium
      undefined-medium
      uni-vga
      unifont
      unifont_upper
      vistafonts
      xkcd-font
      xlsfonts
      zpix-pixel-font
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
        monospace = ["M+1 Nerd Font Medium"];
        sansSerif = ["Rounded Mplus 1c Medium"];
        serif = ["Rounded Mplus 1c Medium"];
      };
    };
  };
}
