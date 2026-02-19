{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = [pkg.brlaser];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  users.users.smg.extraGroups = ["lp" "scanner"];
}
