{ lib
, pkgs
, config
, inputs
, outputs
, ...
}: {
  imports =
    [
      ./pkgs
      ./services
      ./shell
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  systemd.user.startServices = "sd-switch";

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };{pkgs, ...}: {
  # the thunar file manager
  # we enable thunar here and add plugins instead of in systemPackages
  # it is enabled unconditionally as a relatively lightweight fallback
  # option for my system file manager. I still use dolphin most of the time
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      # packages necessery for thunar thumbnails
      xfce.tumbler
      libgsf # odf files
      ffmpegthumbnailer
      kdePackages.ark # GUI archiver for thunar archive plugin
    ];
  };

  # thumbnail support on thunar
  services.tumbler.enable = true;
}

  nix = {
    package = lib.mkForce pkgs.nixVersions.latest;
    settings = {
      experimental-features = [ "recursive-nix" "auto-allocate-uids" "nix-command" "flakes" "configurable-impure-env" ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    overlays = [
      outputs.overlays.default
      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nur.overlay
    ];

    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      allowUnsupportedSystem = true;
      allowBroken = true;
    };
  };

  programs.home-manager.enable = true;

  home = {
    username = "tlh";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "23.05";
  };
}
