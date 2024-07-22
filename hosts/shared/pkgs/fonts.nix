{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      agave
      alegreya
      alice
      ankacoder
      ankacoder-condensed
      annapurna-sil
      arkpandora_ttf
      b612
      bront_fonts
      caladea
      cantarell-fonts
      cardo
      carlito
      cascadia-code # microsoft ligatures font
      clearlyU
      cm_unicode
      comic-relief
      corefonts
      courier-prime
      cozette
      d2coding
      dina-font
      efont-unicode
      envypn-font
      eunomia
      f5_6
      fira
      fira-code
      fira-code-symbols
      font-awesome
      font-awesome_4
      font-awesome_5
      fontpreview
      gelasio
      google-fonts
      gyre-fonts
      hackgen-font
      hackgen-nf-font
      hermit
      hubot-sans
      hubot-sans
      hyperscrypt-font
      inter
      jost
      julia-mono
      junicode
      just
      kanit-font
      kreative-square-fonts
      lalezar-fonts
      lato
      liberation_ttf
      line-awesome
      luculent
      manrope
      maple-mono
      maple-mono-NF
      maple-mono-SC-NF
      martian-mono
      material-symbols
      medio
      mona-sans
      monocraft
      mononoki
      montserrat
      montserrat
      mplus-outline-fonts.githubRelease
      mro-unicode
      nerdfonts
      norwester-font
      noto-fonts # I really hate these fonts
      noto-fonts-cjk # but its better than scripts not rendering
      noto-fonts-emoji # I guess...
      noto-fonts-extra
      ocr-a
      oldstandard
      oxygenfonts
      paratype-pt-mono
      paratype-pt-sans
      paratype-pt-serif
      penna
      poly
      powerline-fonts
      pretendard
      profont
      proggyfonts
      psftools
      recursive
      rictydiminished-with-firacode
      roboto-slab
      scheherazade-new
      scientifica
      siji
      spleen
      sudo-font
      tamzen
      tenderness
      terminus-nerdfont
      terminus_font
      termsyn
      tewi-font
      theano
      times-newer-roman
      tt2020
      u001-font
      ucs-fonts
      undefined-medium
      unfonts-core
      uni-vga
      unifont
      unifont_upper
      unscii
      victor-mono
      vistafonts
      xkcd-font
      xlsfonts
      zilla-slab
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
