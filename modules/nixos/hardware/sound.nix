{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.hardware.sound;
in {
  options.modules.hardware.sound = {
    enable = mkEnableOption "Audio hardware support";

    pipewire = mkOption {
      type = types.bool;
      default = true;
      description = "Use PipeWire instead of PulseAudio";
    };

    lowLatency = mkOption {
      type = types.bool;
      default = false;
      description = "Enable low latency audio configuration";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional audio packages to install";
    };
  };

  config = mkIf cfg.enable {
    # sound.enable is deprecated in newer NixOS versions

    security.rtkit.enable = cfg.pipewire;

    services.pipewire = mkIf cfg.pipewire {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
    };

    hardware.pulseaudio = mkIf (!cfg.pipewire) {
      enable = true;
      support32Bit = true;
    };

    environment.systemPackages = with pkgs;
      [
        pavucontrol
        pulsemixer
      ]
      ++ optionals cfg.pipewire [
        qpwgraph
      ]
      ++ cfg.extraPackages;
  };
}
