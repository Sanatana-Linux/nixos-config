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

        On many modern keyboards (including Lenovo Legion laptops), the
        Copilot key sends a chord of Left Meta + Left Shift + F23. This
        option remaps the F23 scancode to Right Ctrl at the kernel level
        via udev hwdb, so the Copilot key becomes a clean Right Ctrl.

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
    services.udev.extraHwdb = mkIf cfg.copilotKeyAsRightCtrl ''
      # Remap Copilot key (F23 scancode) to Right Ctrl
      evdev:input:b*v*p*
        KEYBOARD_KEY_${if cfg.copilotKeyScancode != null then cfg.copilotKeyScancode else "70072"}=rightctrl
    '';

    # Trigger hwdb rebuild so the remap takes effect without reboot
    systemd.additionalUpstreamSystemUnits = mkIf cfg.copilotKeyAsRightCtrl [
      "systemd-hwdb-update.service"
    ];
  };
}
