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
    enable = mkEnableOption "PipeWire audio stack with full hardware support";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      audio.enable = true;
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
      aaxtomp3
      alsa-firmware
      alsa-lib
      alsa-oss
      alsa-plugins
      alsa-tools
      alsa-utils
      audiofile
      cava
      distrho-ports
      fdk_aac
      flac
      flac2all
      flaca
      libpulseaudio
      libvorbis
      mediainfo
      pamixer
      pavucontrol
      playerctl
      pulseaudio-ctl
      pulseaudioFull
      pulsemixer
      qpwgraph
      redoflacs
      rustplayer
      tap-plugins
      vlc
    ];
  };
}
