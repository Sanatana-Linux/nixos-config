{ config, pkgs, ... }:

{
  # Sound
  sound.enable = true; 

  systemd.user.services = {
    pulseaudio.wantedBy = [ "default.target" ];
  };

    # Enable sound.
  
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;

}

