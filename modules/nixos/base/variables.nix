{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.shell.variables;
in {
  options.modules.base.shell.variables = {
    enable = mkEnableOption "System environment variables";

    browser = mkOption {
      type = types.str;
      default = "firefox";
      description = "Default browser";
    };

    enableJavaOptimizations = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Java AWT and Swing optimizations";
    };

    enableZshAsync = mkOption {
      type = types.bool;
      default = true;
      description = "Enable asynchronous zsh autosuggestions";
    };

    enableOpenGLOptimizations = mkOption {
      type = types.bool;
      default = true;
      description = "Enable OpenGL optimizations";
    };

    extraVariables = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Additional environment variables";
    };
  };

  config = mkIf cfg.enable {
    environment.variables =
      {
        BROWSER = cfg.browser;
      }
      // optionalAttrs cfg.enableOpenGLOptimizations {
        LIBGL_DRI3_DISABLE = "1";
        GSK_RENDERER = "gl";
        ADW_DEBUG_COLOR_SCHEME = "prefer-dark";
      }
      // optionalAttrs cfg.enableJavaOptimizations {
        _JAVA_AWT_WM_NONREPARENTING = "1";
        JDK_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Djdk.gtk.version=2.2 -Dsun.java2d.opengl=true";
      }
      // optionalAttrs cfg.enableZshAsync {
        ZSH_AUTOSUGGEST_USE_ASYNC = "true";
      }
      // cfg.extraVariables;

    # GSettings/GLib needs gsettings-schemas in XDG_DATA_DIRS for GTK apps
    # to find schemas like org.gtk.Settings.FileChooser. Desktop environments
    # (GNOME, Cinnamon, etc.) handle this automatically; on AwesomeWM we need
    # to add it explicitly.
    environment.sessionVariables = {
      XDG_DATA_DIRS = [
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      ];
    };
  };
}
