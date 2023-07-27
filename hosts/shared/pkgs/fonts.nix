{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      agave
      alegreya
      alice
      ankacoder
      ankacoder-condensed
      arkpandora_ttf
      cantarell-fonts
      cascadia-code # microsoft ligatures font
      cm_unicode
      comic-relief
      corefonts
      courier-prime
      cozette
      d2coding
      dina-font
      dosemu_fonts
      envypn-font
      eunomia
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
      hubot-sans
      hyperscrypt-font
      inter
      jost
      kanit-font
      kreative-square-fonts
      lalezar-fonts
      lato
      liberation_ttf
      line-awesome
      maple-mono
      maple-mono-NF
      maple-mono-SC-NF
      martian-mono
      material-symbols
      monocraft
      monoid
      mononoki
      montserrat
      mplus-outline-fonts.githubRelease
      nerdfonts
      norwester-font
      noto-fonts # I really hate these fonts
      noto-fonts-cjk # but its better than scripts not rendering
      noto-fonts-emoji # I guess...
      noto-fonts-extra
      ocr-a
      oldstandard
      powerline-fonts
      profont
      proggyfonts
      psftools
      recursive
      recursive
      roboto-slab
      scheherazade-new
      scientifica
      spleen
      sudo-font
      tamzen
      terminus-nerdfont
      terminus_font
      tewi-font
      theano
      times-newer-roman
      tt2020
      u001-font
      ucs-fonts
      undefined-medium
      unfonts-core
      victor-mono
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
        monospace = ["Agave Nerd Font Mono Bold"];
        sansSerif = ["Oxanium Semi-Bold"];
        serif = ["Oxaniun Semi-Bold"];
      };
    };
  };
}
