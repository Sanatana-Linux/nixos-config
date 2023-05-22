{ config, pkgs, ... }:

{



    programs.command-not-found.enable = true;

    programs.thefuck.enable = true;
    programs.thefuck.alias = "oh"; # Let's make it a bit more... yeah




  #firmware updates 
  services.fwupd.enable = true;

  # Android Debug Bridge (because Apple's platforms are garbage tbh)
  programs.adb.enable = true;




}
