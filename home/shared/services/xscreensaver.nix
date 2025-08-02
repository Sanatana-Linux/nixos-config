{pkgs, ...}: {
  services.xscreensaver = {
    enable = true;
    settings = {
      timeout = 1;
      mode = "blank";
    };
  }; # ends xscreensaver
}
