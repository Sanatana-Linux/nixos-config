# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{self, ...}: {
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # top level option name
  # by using tlh.* for all our modules, we won't have any conflicts with other modules
  tlh = {
    # enables the docker module
    docker.enable = true;
    # enable home-manager profile
    home-manager.enable = true;
    # enable kde & xserver
    awesome.enable = true;
    # set up general nix stuff
    nix-common.enable = true;
    # DNS server on localhost
    unbound.enable = true;
    # Need Bluetooth
    bluetooth.enable = true;
    # Sound maybe
    sound.enable = true;
    # Logitech Mouse Options
    logitech.enable = true;
    # set up language and timezone
    locales.enable = true;
    # enables users which got moved into a seperate file
    user = {
      tlh.enable = true;
      root.enable = true;
    };
    # zsh as default shell for all users
    zsh.enable = true;
  };

  # install packages system wide
  environment.systemPackages = with pkgs; [
    bash-completion
    wget
    git
  ];
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "mail@alexanderwallau.de";
  networking = {
    # dhcpcd.IPv6rs = true;
    interfaces."ens3" = {
      ipv6.addresses = [
        {
          address = "2a0a:4cc0:1:73::1";
          prefixLength = 64;
        }
      ];
    };
    firewall = {allowedTCPPorts = [443 80 9100 9115];};
  };
  networking = {
    enableIPv6 = true;
    hostName = "mayer";
  };
}
