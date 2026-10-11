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
      # xscreensaver disabled — it competed with the in-process AwesomeWM
      # lockscreen. Both grab the keyboard when idle (xscreensaver after 9 min
      # via X resources, xautolock after 10 min via core/autostart), and
      # whichever grabs second wins while the other's password prompt goes
      # deaf to keypresses. Manual locking (Mod4+Ctrl+L) remains available.
      xscreensaver.enable = false;
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

  # SSH client host aliases so `ssh kamala` reaches the AMD desktop from any
  # tlh machine (bagalamukhi included). Matches the server's 2222 port and
  # resolves via mDNS (avahi runs on both ends), so no DNS or /etc/hosts
  # entry is needed.
  programs.ssh = {
    enable = true;
    # Don't install home-manager's opinionated default Host * block; only the
    # alias below is managed.
    enableDefaultConfig = false;
    settings = {
      kamala = {
        HostName = "kamala.local";
        User = "tlh";
        Port = 2222;
        StrictHostKeyChecking = "accept-new";
      };
    };
  };

  home = {
    username = "tlh";
    homeDirectory = "/home/tlh";
    stateVersion = "24.11";
  };
}
