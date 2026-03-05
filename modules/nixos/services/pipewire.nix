{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.services.pipewire;
in {
  options.modules.services.pipewire = {
    enable = mkEnableOption "PipeWire audio server with full audio stack";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse = {
        path = [pkgs.pulseaudio];
        wantedBy = ["default.target"];
      };
    };

    environment.systemPackages = with pkgs; [
      # Audio processing tools
      aaxtomp3
      flac2all
      flaca
      redoflacs
      rustplayer

      # ALSA utilities
      alsa-firmware
      alsa-lib
      alsa-oss
      alsa-plugins
      alsa-tools
      alsa-utils

      # Audio libraries and tools
      audiofile
      cava
      distrho-ports
      fdk_aac
      flac
      libpulseaudio
      libvorbis
      mediainfo
      pamixer
      pavucontrol
      playerctl
      pulseaudio-ctl
      pulseaudioFull
      tap-plugins
      vlc
    ];
  };
}
