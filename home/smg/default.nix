{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../shared/X
    ./desktop.nix
    ../shared/pkgs
    ../shared/programs/aichat.nix
    # Custom Firefox is disabled for smg - using regular Firefox from XFCE
    # ../shared/programs/firefox.nix
    ../shared/programs/kitty/default.nix
    ../shared/services/default.nix
    # ../shared/services/picom.nix
    ../shared/shell
  ];

  # Enable regular Firefox (not the custom tlh configuration)
  programs.firefox = {
    enable = true;
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
      outputs.overlays.unstable-packages
      outputs.overlays.f2k-packages
      outputs.overlays.chaotic-packages
      inputs.nixpkgs-f2k.overlays.default
      inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      # allowUnsupportedSystem = true;
      allowBroken = true;
    };
  };

  programs.home-manager.enable = true;
  services.picom.enable = true;
  # GTK Configuration

  home = {
    username = "smg";
    homeDirectory = "/home/smg";
    stateVersion = "24.11";
  };
}
