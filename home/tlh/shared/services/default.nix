{
  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentryFlavor = "gnome3";
    };
    keybase.enable = true;
    playerctld.enable = true;
    lorri.enable = true;
  };
}
