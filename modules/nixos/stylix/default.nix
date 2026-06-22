{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.stylix;
in {
  options.modules.stylix = {
    enable = mkEnableOption "Stylix theming at NixOS level";

    packages = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Font packages (Nerd Fonts, icon fonts, system fonts)";
      };
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
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;

      base16Scheme = "${./../../../external/base16_monokai_pro/base16-sanatana-linux.yml}";

      polarity = "dark";

      fonts = {
        sizes = {
          terminal = 14;
          desktop = 14;
        };
        serif = {
          package = pkgs.emptyDirectory;
          name = "Operator SSm";
        };
        sansSerif = {
          package = pkgs.emptyDirectory;
          name = "OperatorUltraNerdFontComplete Nerd Font Propo";
        };
        monospace = {
          package = pkgs.emptyDirectory;
          name = "OperatorMono Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };
      icons = {
        enable = true;
        package = pkgs.colloid-icon-theme;
        light = "Colloid";
        dark = "Colloid-dark";
      };

      # System-level targets
      targets.grub.enable = mkForce false;
      targets.plymouth.enable = true;
      targets.console.enable = true;

      # Desktop environment targets - just enable GTK, theme will be overridden by home-manager
      targets.gtk.enable = true;

      targets.qt.enable = true;
      targets.qt.platform = "qtct";
      targets.fontconfig.enable = true;

      # Icon theme
      targets.nixos-icons.enable = true;

      # Disable GNOME target - we use AwesomeWM, not GNOME
      targets.gnome.enable = false;
    };

    # Ensure materia-theme is available system-wide
    environment.systemPackages = with pkgs; [
      materia-theme
      colloid-icon-theme
    ];

    # Font packages — Nerd Fonts, icon fonts, system fonts + fontconfig
    fonts = mkIf cfg.packages.enable {
      packages = with pkgs;
        optionals cfg.packages.nerdFonts [
          nerd-fonts.agave nerd-fonts.d2coding nerd-fonts.envy-code-r
          nerd-fonts.proggy-clean-tt nerd-fonts.ubuntu nerd-fonts.ubuntu-mono
          nerd-fonts.ubuntu-sans nerd-fonts.noto
        ]
        ++ optionals cfg.packages.iconFonts [
          nerd-fonts.symbols-only icomoon-feather emacs-all-the-icons-fonts
          font-awesome_4 font-awesome_5 font-awesome_6 font-awesome_7
          material-design-icons material-symbols siji
        ]
        ++ optionals cfg.packages.systemFonts [
          corefonts vista-fonts get-google-fonts jost norwester-font
          pixel-code terminus_font nerd-font-patcher
        ];
      fontconfig = {
        enable = true;
        cache32Bit = true;
        antialias = true;
        useEmbeddedBitmaps = true;
        hinting = { enable = true; autohint = true; style = "slight"; };
        subpixel = { lcdfilter = "default"; };
      };
    };
  };
}
