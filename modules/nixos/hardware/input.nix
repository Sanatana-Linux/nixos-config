{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.hardware.input;
in {
  options.modules.hardware.input = {
    enable = mkEnableOption "System-wide pointer input settings for mice, trackballs, and touchpads";

    mouse = {
      accelProfile = mkOption {
        type = types.enum [
          "flat"
          "adaptive"
          "custom"
        ];
        default = "adaptive";
        description = ''
          Pointer acceleration profile applied to every mouse and trackball.

          Trackball sensors emit high-resolution relative motion with no
          axis-locked or absolute-coordinate behaviour, so `adaptive` is the
          right default: libinput ramps down the gain at low speeds, which is
          what makes fine positioning possible with a bare ball. `flat` applies
          a constant gain and tends to feel twitchy on trackballs.
        '';
      };

      accelSpeed = mkOption {
        type = types.nullOr types.str;
        default = "-0.3";
        example = "0.0";
        description = ''
          How quickly pointer gain rises from minimum to maximum speed.
          Accepts a string in libinput's -1.0 to 1.0 range.

          A mildly negative value flattens the curve, trading top-end speed for
          fine control — the usual tradeoff for trackball use. Set to `null` to
          leave the libinput default (a neutral 0.0) in place.
        '';
      };

      middleEmulation = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Treat a simultaneous left-plus-right click as a middle click.
          Trackballs commonly ship only three buttons and no scroll wheel or
          thumb buttons, so emulated middle-click is often the only way to open
          links in a new tab.
        '';
      };

      leftHanded = mkOption {
        type = types.bool;
        default = false;
        description = "Swap the left and right pointer buttons for left-handed use.";
      };
    };

    touchpad = {
      naturalScrolling = mkOption {
        type = types.bool;
        default = false;
        description = "Invert touchpad scroll direction for natural (content-follows-finger) scrolling.";
      };

      disableWhileTyping = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Suspend touchpad gestures while the keyboard is being used, so
          accidental palm contact does not move the pointer mid-sentence.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.libinput = {
      enable = true;

      mouse = {
        accelProfile = cfg.mouse.accelProfile;
        accelSpeed = cfg.mouse.accelSpeed;
        middleEmulation = cfg.mouse.middleEmulation;
        leftHanded = cfg.mouse.leftHanded;
      };

      touchpad = {
        naturalScrolling = cfg.touchpad.naturalScrolling;
        disableWhileTyping = cfg.touchpad.disableWhileTyping;
      };
    };
  };
}
