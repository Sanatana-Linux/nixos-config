{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.virtualization.core;
in {
  options.modules.virtualization.core = {
    enable = mkEnableOption "Core virtualization (Docker, containerd, libvirt)";

    nvidia = mkEnableOption "NVIDIA container runtime support";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
        rootless = {
          enable = true;
          daemon.settings.features.cdi = true; # see: https://nixos.wiki/wiki/Nvidia#NVIDIA_Docker_not_Working
        };
        extraOptions = mkIf cfg.nvidia "--add-runtime nvidia=/run/current-system/sw/bin/nvidia-container-runtime ";
      };
      containers.enable = true;
      libvirtd.enable = true;
      containerd.enable = true;
      oci-containers.backend = "docker";
    };

    hardware.nvidia-container-toolkit.enable = mkIf cfg.nvidia true;
    hardware.graphics.enable32Bit = mkIf cfg.nvidia true;

    systemd.suppressedSystemUnits = ["virt-secret-init-encryption.service"];

    environment.systemPackages = with pkgs; [
      conmon
      containerd
      fuse-overlayfs
      docker
      docker-buildx
      docker-client
      docker-compose
      docker-credential-helpers
      distribution
      docker-gc
      docker-slim
      libvirt
      libvirt-glib
      libgovirt
    ];
  };
}
