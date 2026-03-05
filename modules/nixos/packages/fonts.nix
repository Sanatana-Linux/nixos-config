{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.packages.fonts = {
    enable = mkEnableOption "Font packages and configuration";

    nerdFonts = mkEnableOption "Nerd Fonts collection" // {default = true;};
    iconFonts = mkEnableOption "Icon fonts (Font Awesome, Material Design)" // {default = true;};
    systemFonts = mkEnableOption "System and UI fonts" // {default = true;};
  };

  config = mkIf config.modules.packages.fonts.enable {
    fonts = {
      packages = with pkgs;
        []
        ++ optionals config.modules.packages.fonts.nerdFonts [
          nerd-fonts.agave
          nerd-fonts.d2coding
          nerd-fonts.proggy-clean-tt
          nerd-fonts.ubuntu
          nerd-fonts.ubuntu-mono
          nerd-fonts.ubuntu-sans
          nerd-fonts.noto
        ]
        ++ optionals config.modules.packages.fonts.iconFonts [
          icomoon-feather
          emacs-all-the-icons-fonts
          font-awesome
          font-awesome_4
          font-awesome_5
          material-design-icons
          material-symbols
          siji
        ]
        ++ optionals config.modules.packages.fonts.systemFonts [
          annapurna-sil
          corefonts
          jost
          kanit-font
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
  };
}
