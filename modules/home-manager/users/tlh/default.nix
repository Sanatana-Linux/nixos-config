{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
  ];

  # Restored modules configuration for feature parity - ONLY originally enabled modules
  modules = {
    stylix.enable = true;
    packages = {
      essential.enable = true;
      permitted-insecure-packages.enable = true;
    };
    shell = {
      zsh.enable = true;
      starship.enable = true;
      cli-tools.enable = true;
      scripts.enable = true;
    };
    core = {
      environment.enable = true;
      home.enable = true;
      nix.enable = true;
      xdg.enable = true;
    };
    desktop = {
      enable = true;
      awesome.enable = true;
    };
    programs = {
      fastfetch.enable = true;
      firefox = {
        enable = true;
        withAutoconfig = true;
        searxngUrl = "http://localhost:8080";
        defaultSearchEngine = "SearXNG";
      };
      kitty.enable = true;
      gpg.enable = true;
      yazi.enable = true;
      vesktop.enable = true;
      neovim.enable = true;
    };
    services = {
      gnome-keyring = {
        enable = true;
        components = ["secrets" "ssh" "pkcs11"];
      };
      picom.enable = true;
      xscreensaver.enable = true;
    };
  };

  systemd.user.startServices = "sd-switch";

  # we have tealdeer & internet for this. Rendered in more readable formats
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowBroken = true;
    };
  };

  programs.home-manager.enable = true;

  home = {
    username = "tlh";
    homeDirectory = "/home/tlh";
    stateVersion = "24.11";
  };
}
