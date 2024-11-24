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
      dina-font
      envypn-font
      f5_6
      font-awesome
      font-awesome_4
      font-awesome_5
      fontpreview
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
      nerdfonts
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
      powerline-fonts
      proggyfonts
      scheherazade-new
      scientifica
      siji
      sf-mono-liga-bin
      spleen
      sudo-font
      tamzen
      terminus-nerdfont
      terminus_font
      termsyn
      tewi-font
      times-newer-roman
      tt2020
      u001-font
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
        monospace = ["M+1 Nerd Font Black"];
        sansSerif = ["Rounded Mplus 1c ExtraBold"];
        serif = ["Rounded Mplus 1c ExtraBold"];
      };
    };
  };
}
