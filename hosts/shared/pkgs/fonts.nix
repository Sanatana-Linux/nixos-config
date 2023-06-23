{pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [
      arkpandora_ttf
      cantarell-fonts
      cascadia-code # microsoft ligatures font
      comic-relief
      courier-prime
      cozette
      corefonts
      d2coding
      ankacoder-condensed
      ankacoder
      dina-font
      eunomia
      envypn-font
      fira
      fira-code
      fira-code-symbols
      font-awesome
      font-awesome_4
      font-awesome_5
      gelasio
      google-fonts
      inter
      kreative-square-fonts
      lato
      liberation_ttf
      jost
      kanit-font
      ocr-a
      sudo-font
      recursive
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
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      ocr-a
      powerline-fonts
      profont
      proggyfonts
      psftools
      recursive
      roboto-slab
      scientifica
      spleen
      tamzen
      terminus_font
      terminus-nerdfont
      tewi-font
      theano
      times-newer-roman
      tt2020
      victor-mono
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
        monospace = ["Agave Nerd Font Mono Bold"];
        sansSerif = ["Asap Condensed, Semi-Bold Condensed"];
        serif = ["Asap VF Beta Bold Italic"];
      };
    };
  };
}
