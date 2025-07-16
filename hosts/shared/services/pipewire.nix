{pkgs, ...}: {
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
    alsa-firmware
    alsa-lib
    alsa-oss
    alsa-plugins
    alsa-tools
    mpc-cli
    mpdris2
    pavucontrol
    playerctl
    aaxtomp3
    audiofile
    redoflacs
    distrho-ports
    alsa-utils
    cava
    easyeffects
    rustplayer
    libvorbis
    tap-plugins
    fdk_aac
    flac
    flac2all
    flaca
    libpulseaudio
    deadbeef-with-plugins
    mediainfo
    mpc_cli
    mpd
    mpd-discord-rpc
    mpd-mpris
    mpdevil
    pamixer
    pavucontrol
    playerctl
    pulseaudio-ctl
    pulseaudioFull
    vlc
  ];
}
