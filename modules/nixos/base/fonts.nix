{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.fonts;
in {
  options.modules.base.fonts = {
    enable = mkEnableOption "Font packages and fontconfig settings";

    nerdFonts = mkOption {
      type = types.bool;
      default = true;
      description = "Nerd Font variants";
    };

    iconFonts = mkOption {
      type = types.bool;
      default = true;
      description = "Icon fonts for UI";
    };

    systemFonts = mkOption {
      type = types.bool;
      default = true;
      description = "System and display fonts";
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs;
      # Nerd Fonts - patched with icons
        optionals cfg.nerdFonts [
          nerd-fonts.agave # Agave Nerd Font
          nerd-fonts.d2coding # D2Coding Nerd Font
          nerd-fonts.envy-code-r # Envy Code R Nerd Font
          nerd-fonts.proggy-clean-tt # Proggy Clean Nerd Font
          nerd-fonts.ubuntu # Ubuntu Nerd Font
          nerd-fonts.ubuntu-mono # Ubuntu Mono Nerd Font
          nerd-fonts.ubuntu-sans # Ubuntu Sans Nerd Font
          nerd-fonts.noto # Noto Nerd Font
          nerd-fonts.fira-code # Fira Code Nerd Font
          nerd-fonts.fira-mono # Fira Mono Nerd Font
          nerd-fonts."m+" # M+ Nerd Font
        ]
        # Icon Fonts
        ++ optionals cfg.iconFonts [
          nerd-fonts.symbols-only # Nerd Font symbols
          icomoon-feather # Feather icons font
          emacs-all-the-icons-fonts # Emacs icon fonts
          font-awesome_4 # Font Awesome 4
          font-awesome_5 # Font Awesome 5
          font-awesome_6 # Font Awesome 6
          font-awesome_7 # Font Awesome 7
          material-design-icons # Google Material Icons
          material-symbols # Material Symbols
          siji # Minimal icon font
        ]
        # System Fonts
        ++ optionals cfg.systemFonts [
          corefonts # Microsoft core fonts
          vista-fonts # Windows Vista fonts
          get-google-fonts # Google Fonts installer
          jost # Jost font family
          norwester-font # Norwester display font
          pixel-code # Pixel Code font
          terminus_font # Terminus bitmap font
          nerd-font-patcher # Font patching tool
        ];

      # Font configuration - CRITICAL for fonts to work
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
        subpixel = {
          lcdfilter = "default";
        };
      };
    };
  };
}
