{ config, pkgs, ... }:

{

    environment.shellAliases = { # Loads of aliases
      ls = "exa";
      la = "exa -a";
      ll = "exa -alh";
      lt = "exa -lT";
      lat = "exa -laT";

      cat = "bat";

      # DO NOT DO THIS 
      # IT WILL FORCE RM FOLDERS
      rm = "rm -rvf";

      vim = "nvim";
      vi = "nvim";

      purge = "doas sync; echo 3 | doas tee /proc/sys/vm/drop_caches";

      nps="nps -C=description --separator=true"

    };

    programs.command-not-found.enable = true;

    programs.thefuck.enable = true;
    programs.thefuck.alias = "oh"; # Let's make it a bit more... yeah




  #firmware updates 
  services.fwupd.enable = true;

  # Android Debug Bridge (because Apple's platforms are garbage tbh)
  programs.adb.enable = true;




}
