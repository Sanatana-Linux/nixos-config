{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.desktop.materiaStylix;

  scheme = config.stylix.base16Scheme;
  slug = lib.strings.toLower (lib.strings.sanitizeDerivationName scheme.scheme);

  stripHash = str: lib.strings.removePrefix "#" str;

  materiaTheme = {
    name = "Materia-${slug}";
    variant = "dark";
    background = stripHash scheme.base00;
    foreground = stripHash scheme.base05;
    menuBackground = stripHash scheme.base01;
    menuForeground = stripHash scheme.base05;
    surface = stripHash scheme.base02;
    view = stripHash scheme.base01;
    accent =
      if (scheme ? accent)
      then stripHash scheme.accent
      else stripHash scheme.base0D;
    visited = stripHash scheme.base0E;
    error = stripHash scheme.base08;
    success = stripHash scheme.base0B;
    warning = stripHash scheme.base09;
  };

  rendersvg = pkgs.runCommand "rendersvg" {} ''
    mkdir -p $out/bin
    ln -s ${pkgs.resvg}/bin/resvg $out/bin/rendersvg
  '';

  materiaThemePackage = pkgs.stdenv.mkDerivation {
    name = "materia-${slug}";
    src = pkgs.fetchFromGitHub {
      owner = "nana-4";
      repo = "materia-theme";
      rev = "d7f59a37ef51f893c28b55dc344146e04b2cd52c";
      sha256 = "sha256-PnpFAmKEpfg3wBwShLYviZybWQQltcw7fpsQkTUZtww=";
    };
    buildInputs = with pkgs; [
      bc
      dart-sass
      git
      gtk4.dev
      meson
      ninja
      optipng
      rendersvg
      sassc
      which
    ];
    phases = ["unpackPhase" "installPhase"];
    installPhase = ''
      HOME=/build
      chmod 777 -R .
      patchShebangs .
      mkdir -p $out/share/themes
      mkdir bin
      sed -e 's/handle-horz-.*//' -e 's/handle-vert-.*//' -i ./src/gtk-2.0/assets.txt
      cat > /build/gtk-colors << EOF
      MATERIA_STYLE_COMPACT=true
      MATERIA_COLOR_VARIANT=${materiaTheme.variant}
      MATERIA_SURFACE=${materiaTheme.surface}
      MATERIA_VIEW=${materiaTheme.view}
      BG=${materiaTheme.background}
      FG=${materiaTheme.foreground}
      HDR_BG=${materiaTheme.menuBackground}
      HDR_FG=${materiaTheme.menuForeground}
      SEL_BG=${materiaTheme.accent}
      TERMINAL_COLOR5=${materiaTheme.visited}
      TERMINAL_COLOR9=${materiaTheme.error}
      TERMINAL_COLOR10=${materiaTheme.success}
      TERMINAL_COLOR11=${materiaTheme.warning}
      EOF
      echo "Changing colours:"
      ./change_color.sh --inkscape false --target "$out/share/themes" --output ${materiaTheme.name} /build/gtk-colors
      chmod 555 -R .
    '';
  };
in {
  options.modules.desktop.materiaStylix = {
    enable = mkEnableOption "Materia GTK theme generated from Stylix colors";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = lib.mkForce "${materiaTheme.name}";
        package = lib.mkForce materiaThemePackage;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    home.sessionVariables = {
      GTK_THEME = "${materiaTheme.name}";
    };
  };
}
