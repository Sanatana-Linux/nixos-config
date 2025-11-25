{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.agave
      nerd-fonts.d2coding
      nerd-fonts.proggy-clean-tt
      icomoon-feather

      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.ubuntu-sans
      siji
      nerd-fonts.noto
      emacs-all-the-icons-fonts
      font-awesome
      font-awesome_4
      font-awesome_5
      annapurna-sil
      corefonts
      jost
      kanit-font
      material-design-icons
      material-symbols
      mplus-outline-fonts.githubRelease
      norwester-font
      pixel-code
      terminus_font
      vista-fonts
    ];

    fontconfig = {
      enable = true;
      cache32Bit = true;
      antialias = true;
      useEmbeddedBitmaps = true;

      hinting = {
        enable = true;
        autohint = true;
        style = "slight";
      };
      defaultFonts = {
        serif = ["Agave Nerd Font Propo Regular" "FreeSerif"];
        sansSerif = ["Agave Nerd Font Propo Regular" "Ubuntu Nerd Font Medium"];
        monospace = ["Agave Nerd Font Mono" "Ubuntu Nerd Font Mono"];
      };
      subpixel.lcdfilter = "default";
    };
  };
}
