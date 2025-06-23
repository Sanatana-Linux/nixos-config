{
  lib,
  pkgs,
  ...
}: {
  services.picom = {
    enable = true;
    package = pkgs.picom-next;
    # fully override default config (with lib.mkOptionDefault options that exist in default config, but not provided here will still remain defined)
    settings = lib.mkForce {
      #################################
      #       General Settings        #
      #################################
      backend = "xrender";
      dithered-present = false;
      vsync = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      corner-radius = 4;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      glx-no-stencil = true;
      use-damage = true;
      transparent-clipping = false;
      log-level = "warn";

      #################################
      #             Shadows           #
      #################################
      shadow = true;
      shadow-radius = 15;
      shadow-opacity = 0.9;
      shadow-offset-x = -15;
      shadow-offset-y = -15;
      crop-shadow-to-monitor = true;

      #################################
      #           Fading              #
      #################################
      fading = true;
      fade-in-step = 0.3;
      fade-out-step = 0.3;
      # no-fading-openclose = true

      #################################
      #     Background-Blurring       #
      #################################
      blur-method = "dual_kawase";
      blur-size = 3;
      blur-strength = 15;
    };
  };
  xdg.configFile."picom/picom.conf".text = let
    inherit (builtins) isAttrs;

    inherit
      (lib)
      boolToString
      concatMapStringsSep
      concatStringsSep
      escape
      mapAttrsToList
      types
      ;

    # Basically a tinkered lib.generators.mkKeyValueDefault
    # It either serializes a top-level definition "key: { values };"
    # or an expression "key = { values };"
    mkAttrsString = top: toList:
      mapAttrsToList (k: v: let
        sep =
          if (top && isAttrs v)
          then ": "
          else " = ";
      in "${escape [sep] k}${sep}${mkValueString toList v};");

    # This serializes a Nix expression to the libconfig format.
    mkValueString = top: v:
      if types.bool.check v
      then boolToString v
      else if types.int.check v
      then toString v
      else if types.float.check v
      then toString v
      else if types.str.check v
      then ''"${escape [''"''] v}"''
      else if (builtins.isList v && top) # new option that can make top level nix list to be converted to libconfig list (not default which is libconfig array)
      then "( ${concatMapStringsSep " ,\n" (mkValueString false) v} )" # it's LIST according to libconfig settings (ARRAY!=LIST)
      else if (builtins.isList v && (!top))
      then "[ ${concatMapStringsSep " , " (mkValueString false) v} ]" # it's ARRAY according to libconfig settings (ARRAY!=LIST)
      else if types.attrs.check v
      then "{ ${concatStringsSep "\n" (mkAttrsString false false v)} }"
      else
        throw ''
          invalid expression used in option services.picom.settings:
          ${v}
        '';

    # conversion that puts attrs into () -> (attrs)
    # every value of attrs must be NIX list (builtins.isList)
    toList = attrs: concatStringsSep "\n" (mkAttrsString true true attrs);
  in
    lib.mkAfter (toList {
      #################################
      #       General Settings        #
      #################################
      backend = "xrender";
      dithered-present = false;
      vsync = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
      corner-radius = 4;
      detect-rounded-corners = true;
      detect-client-opacity = true;
      detect-transient = true;
      glx-no-stencil = true;
      use-damage = true;
      transparent-clipping = false;
      log-level = "warn";

      #################################
      #             Shadows           #
      #################################
      shadow = true;
      shadow-radius = 15;
      shadow-opacity = 0.9;
      shadow-offset-x = -15;
      shadow-offset-y = -15;
      crop-shadow-to-monitor = true;

      #################################
      #           Fading              #
      #################################
      fading = true;
      fade-in-step = 0.3;
      fade-out-step = 0.3;
      # no-fading-openclose = true

      #################################
      #     Background-Blurring       #
      #################################
      blur-method = "dual_kawase";
      blur-size = 3;
      blur-strength = 15;

      blur-background-exclude = [
        "class_g = 'slop'"
      ];
      shadow-exclude = [
        "class_g *?= 'slop'"
      ];

      #################################
      #           Animations          #
      #################################
      animations = [
        {
          triggers = [
            "open"
            "show"
          ];

          preset = "slide-in";
          direction = "down";
          duration = 0.2;
        }
        {
          triggers = [
            "close"
            "hide"
          ];

          preset = "slide-out";
          direction = "up";
          duration = 0.2;
        }
        {
          triggers = [
            "geometry"
          ];
          preset = "geometry-change";
          duration = 0.1;
        }
      ];
      #################################
      #             Rules             #
      #################################
      rules = let
        opFULL = 1;
        opMAX = 0.99;
        opNORM = 0.99;
        opLOW = 0.9;
      in [
        {
          match = "_GTK_FRAME_EXTENTS@";
          shadow = true;
          blur = true;
        }
        {
          match = "class_g = 'Gnome-terminal' || class_g = 'XTerm' || class_g = 'Konsole'";
          shadow = true;
          blur = true;
        }
        {
          match = "window_type = 'dock'";
          corner-radius = 0;
          dim = 0;
          shadow = false;
        }
        {
          match = "window_type = 'desktop' || class_g *?= 'slop' || class_i *?=  'slop' || name *?= 'slop'";
          corner-radius = 0;
          opacity = opFULL;
          shadow = false;
          blur = false;
          dim = 0;
        }
        {
          match = "window_type = 'popup_menu' || window_type = 'tooltip'";
          transparent-clipping = true;
          shadow = true;
          blur = true;
          corner-radius = 4;
        }
        {
          match = "fullscreen";
          opacity = opFULL;
          corner-radius = 0;
        }
        {
          match = "(focused || group_focused) && (!fullscreen)"; #active
          opacity = opNORM;
        }
        {
          match = "!(focused || group_focused) && (!fullscreen)"; #inactive
          opacity = opLOW;
          dim = 0.2;
        }
        {
          match = "class_g = 'Darktable'";
          opacity = opFULL;
        }
        {
          match = "class_g = 'Eww' || name = 'Eww - bar' || class_g = 'Rofi'";
          opacity = opNORM;
          shadow = false;
          dim = 0;
        }

        {
          match = "class_g='flameshot'";
          fade = false;
          blur = false;
          animations = let
            d = 0.2;
          in {
            appear = {
              triggers = ["open" "show"];
              preset = "appear";
              duration = d;
            };
            disappear = {
              triggers = ["close" "hide"];
              preset = "disappear";
              duration = d;
            };
          };
        }
        {
          match = "class_g = 'kitty' || class_g = 'dropdown'";
          transparent-clipping = true;
          opacity = 0.9;
          blur = true;
          animations = let
            d = 0.2;
          in {
            appear = {
              triggers = ["open" "show"];
              preset = "slide-in";
              direction = "down";
              duration = d;
            };
            disappear = {
              triggers = ["close" "hide"];
              preset = "slide-out";
              direction = "up";
              duration = d;
            };
          };
        }
      ];
    });
}
