{pkgs, ...}: {
  services.xscreensaver = {
    enable = true;
    settings = {
      timeout = "9";
      mode = "blank";
    };
  }; # ends xscreensaver
}
