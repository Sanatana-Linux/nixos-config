{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./desktop.nix
    ../../modules/home-manager/default.nix
  ];

  modules = {
    shell = {
      home.enable = true;
    };
    programs.firefox = {
      enable = true;
      higgs-boson = false; # strictly disabled for smg
    };
    services = {
      gnome-keyring = {
        enable = true;
        enableSSH = false; # Disable SSH agent for smg
      };
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.f2k-packages
      outputs.overlays.chaotic-packages
      inputs.nixpkgs-f2k.overlays.default
      inputs.nur.overlays.default
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowBroken = true;
    };
  };

  # Required by home-manager
  home.stateVersion = "24.11";
}
