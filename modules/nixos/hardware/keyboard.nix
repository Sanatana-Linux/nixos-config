{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.keyboard;
in {
  options.modules.hardware.keyboard = {
    enable = mkEnableOption "Keyboard configuration";

    copilotKeyAsRightCtrl = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Remap the Copilot key to act as Right Ctrl.

        On Lenovo Legion laptops, the Copilot key sends a chord of
        Left Meta + Left Shift + F23 as separate key events. This option
        uses keyd to intercept the full chord and output a clean Right Ctrl,
        suppressing the Meta and Shift that accompany it.

        If your Copilot key sends a different scancode (e.g. some keyboards
        send just KEY_RIGHTMETA), set copilotKeyScancode to override.
      '';
    };

    copilotKeyScancode = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "70072";
      description = ''
        Override the scancode to remap. If null (default), uses "70072"
        which is the F23 scancode sent by the Copilot key on Lenovo Legion
        and many other modern laptops.

        To find the actual scancode on your system, run:
          sudo evtest
        Select the keyboard device, press the Copilot key, and look for
        the MSC_SCAN value. The unique Copilot-specific scancode is the
        one that maps to KEY_F23 (code 193) or KEY_UNKNOWN (code 240).

        Common values:
        - 70072 — F23 scancode (Lenovo Legion, many others)
        - e03f — AT keyboard scancode for F23
      '';
    };
  };

  config = mkIf cfg.enable {
    # Use keyd to handle the Copilot key chord properly.
    # The Copilot key on Lenovo Legion sends LeftMeta+LeftShift+F23 as
    # separate key events. keyd can match the full chord and output a
    # clean RightCtrl, suppressing the Meta and Shift modifiers.
    services.keyd = mkIf cfg.copilotKeyAsRightCtrl {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = {
            main = {
              # The Copilot key on Lenovo Legion sends LeftMeta+LeftShift+F23
              # as a chord of separate key events. keyd matches the full chord
              # and outputs a clean RightCtrl, suppressing the Meta and Shift
              # modifiers that accompany it.
              #
              # Some models send just F23 without modifiers — the standalone
              # f23 map catches that case. The chord is tried first; if the
              # full chord isn't detected within chord_timeout, f23 maps alone.
              "leftmeta+leftshift+f23" = "rightcontrol";
              "f23" = "rightcontrol";
            };
            global = {
              # USB keyboard macro fires events faster than default 50ms
              # chord timeout — increase to 100ms so keyd reliably captures
              # the full LeftMeta+LeftShift+F23 chord.
              chord_timeout = 100;
            };
          };
        };
      };
    };
  };
}
