{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.shell.variables;
in {
  options.modules.shell.variables = {
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
        QT_QPA_PLATFORMTHEME = "qt6ct";
      }
      // optionalAttrs cfg.enableOpenGLOptimizations {
        LIBGL_DRI3_DISABLE = "1";
      }
      // optionalAttrs cfg.enableJavaOptimizations {
        _JAVA_AWT_WM_NONREPARENTING = "1";
        JDK_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Djdk.gtk.version=2.2 -Dsun.java2d.opengl=true";
      }
      // optionalAttrs cfg.enableZshAsync {
        ZSH_AUTOSUGGEST_USE_ASYNC = "true";
      }
      // {
        # Virtualization paths
        G2TP_OVMF_IMAGE = "/run/libvirt/nix-ovmf/OVMF_CODE.fd";
        G2TP_GRUB_LIB = "/nix/store/77r7pkdhylp119m32lhh349yqc5dyig6-grub-2.12/lib/grub";

        # AI API endpoints
        OLLAMA_API_BASE = "http://127.0.0.1:11434";
        OPENAI_API_BASE = "http://localhost:11434";
      }
      // cfg.extraVariables;
  };
}
