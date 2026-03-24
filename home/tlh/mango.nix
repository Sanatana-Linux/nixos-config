{
  modules,
  lib,
  pkgs,
  ...
}: {

  home.packages = with pkgs; [grim slurp wl-clipboard];

  modules.programs.mangowc = let
  windowrule=isnamedscratchpad:1,width:1000,height:700,title:kitty-scratch
    horizontalLayouts = [
      "tile"
      "scroller"
      "monocle"
      "grid"
      "dwindle"
      "spiral"
      "deck"
      "center_tile"
      "right_tile"
    ];
    verticalLayouts = [
      "vertical_tile"
      "vertical_scroller"
      "vertical_grid"
      "vertical_dwindle"
      "vertical_spiral"
      "vertical_deck"
    ];
    directions = [
      "Up"
      "Down"
      "Left"
      "Right"
    ];
    moveResizeParams = {
      Up = "+0,-50";
      Down = "+0,+50";
      Left = "-50,+0";
      Right = "+50,+0";
    };
    mkDirectionalBinds = mods: command: transform:
      map (key: {
        inherit mods key command;
        params = transform key;
      })
      directions;
    mkNumberBinds = mods: command: suffix:
      builtins.genList (i: {
        inherit mods command;
        key = toString (i + 1);
        params = "${toString (i + 1)}${suffix}";
      })
      9;
    mkMoveResizeBinds = mods: command:
      lib.mapAttrsToList (key: params: {
        inherit
          mods
          key
          command
          params
          ;
      })
      moveResizeParams;
  in {
    enable = true;
    appearance = {
      borderpx = 0;
    };
    layout = {
      scroller = {
        preferCenter = true;
        edgeScrollerPointerFocus = false;
        defaultProportion = 0.8;
      };
    };

    misc = {
      enableFloatingSnap = true;
      focusCrossMonitor = true;
      focusCrossTag = false;
    };

    overview = {
      enableHotArea = false;
      tabMode = false;
      hotAreaSize = 0;
    };

    effects = {
      borderRadius = 7;
    };

    animations = {
      openType = "zoom";
      closeType = "zoom";
      tagDirection = "horizontal";
      duration = {
        move = 100;
        open = 400;
        close = 400;
        tag = 250;
      };
    };

    tagRules = [
      {
        id = 1;
        layout_name = "scroller";
      }
      {
        id = 2;
        layout_name = "scroller";
      }
      {
        id = 3;
        layout_name = "scroller";
      }
      {
        id = 4;
        layout_name = "scroller";
      }
      {
        id = 5;
        layout_name = "scroller";
      }
      {
        id = 6;
        layout_name = "scroller";
      }
      {
        id = 7;
        layout_name = "scroller";
      }
      {
        id = 8;
        layout_name = "scroller";
      }
      {
        id = 9;
        layout_name = "scroller";
      }
    ];
    bindings =
      [
        {
          mods = ["SUPER" "ALT"];
          key = "Return";
          command = "spawn";
          params = "kitty";
        }
        
        {
          mods = ["SUPER" ];
          key = "Return";
          command = "toggle_named_scratchpad";
          params = "kitty -T kitty-scratch";
        }
        
        {
          mods = ["SUPER"];
          key = "x";
          command = "killclient";
        }
        {
          mods = [
            "SUPER"
            "SHIFT"
          ];
          key = "q";
          command = "quit";
        }
        {
          mods = ["SUPER"];
          key = "Tab";
          command = "toggleoverview";
        }
        {
          mods = ["SUPER"];
          key = "v";
          command = "togglemaximizescreen";
        }
        {
          mods = ["SUPER"];
          key = "p";
          command = "togglefloating";
        }
        {
          mods = ["SUPER"];
          key = "z";
          command = "toggle_scratchpad";
        }
        {
          mods = ["CTRL"];
          key = "m";
          command = "minimized";
        }
        {
          mods = ["ALT"];
          key = "m";
          command = "restore_minimized";
        }
        {
          mods = ["NONE"];
          key = "F11";
          command = "togglefullscreen";
        }
        {
          mods = [
            "SUPER"
            "CTRL"
          ];
          key = "Left";
          command = "focusstack";
          params = "prev";
        }
        {
          mods = [
            "ALT"
          ];
          key = "P";
          command = "spawn_shell";
          params = "grim -g \"$(slurp -d)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
        }
        {
          mods = [
            "SUPER"
            "CTRL"
          ];
          key = "Right";
          command = "focusstack";
          params = "next";
        }
        {
          mods = [
            "SUPER"
            "ALT"
          ];
          key = "Left";
          command = "exchange_stack_client";
          params = "prev";
        }
        {
          mods = [
            "SUPER"
            "ALT"
          ];
          key = "Right";
          command = "exchange_stack_client";
          params = "next";
        }scra
      ]
      ++ (lib.imap0 (i: layout: {
          mods = [
            "SUPER"
            "CTRL"
          ];
          key = toString (i + 1);
          command = "setlayout";
          params = layout;
        })
        horizontalLayouts)
      ++ (lib.imap0 (i: layout: {
          mods = [
            "SUPER"
            "ALT"
          ];
          key = toString (i + 1);
          command = "setlayout";
          params = layout;
        })
        verticalLayouts)
      ++ (mkNumberBinds ["SUPER"] "view" "")
      ++ (mkNumberBinds ["SUPER" "SHIFT"] "tag" "")
      ++ (mkMoveResizeBinds ["CTRL" "SHIFT"] "movewin")
      ++ (mkMoveResizeBinds ["CTRL" "ALT"] "resizewin")
      ++ (mkDirectionalBinds ["SUPER"] "focusdir" lib.toLower)
      ++ (mkDirectionalBinds ["SUPER" "SHIFT"] "exchange_client" lib.toLower);
  };
}
