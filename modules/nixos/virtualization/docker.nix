{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.virtualization.docker;
in {
  options.modules.virtualization.docker = {
    enable = mkEnableOption "Docker container runtime";

    enableOnBoot = mkOption {
      type = types.bool;
      default = true;
      description = "Start Docker daemon on boot";
    };

    rootless = mkOption {
      type = types.bool;
      default = true;
      description = "Enable rootless Docker for current user";
    };

    nvidia = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA container runtime support";
    };

    extraOptions = mkOption {
      type = types.str;
      default = "";
      description = "Extra options for Docker daemon";
    };

    composeSupport = mkOption {
      type = types.bool;
      default = true;
      description = "Install Docker Compose";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = cfg.enableOnBoot;
        rootless = mkIf cfg.rootless {
          enable = true;
          daemon.settings.features.cdi = cfg.nvidia;
        };
        extraOptions =
          cfg.extraOptions
          + optionalString cfg.nvidia
          " --add-runtime nvidia=/run/current-system/sw/bin/nvidia-container-runtime";
      };
      containers.enable = true;
      containerd.enable = true;
      oci-containers.backend = "docker";
    };

    hardware = mkIf cfg.nvidia {
      nvidia-container-toolkit.enable = true;
      graphics.enable32Bit = true;
    };

    environment.systemPackages = with pkgs;
      [
        docker
        docker-client
        docker-buildx
        conmon
        containerd
        fuse-overlayfs
        docker-credential-helpers
        distribution
        docker-gc
        docker-slim
      ]
      ++ optionals cfg.composeSupport [
        docker-compose
      ];
  };
}
