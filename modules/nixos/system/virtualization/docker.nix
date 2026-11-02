{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.virtualization.docker;
in {
  options.modules.system.virtualization.docker = {
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

    dns = mkOption {
      type = types.listOf types.str;
      default = ["172.17.0.1" "1.1.1.1"];
      description = "DNS servers for Docker containers, tried in order. Defaults to the host-side dnsmasq reachable over the docker bridge (see the dnsmasq block below), so containers resolve through the host's upstreams instead of reaching them directly.";
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
        autoPrune = {
          enable = true;
          allVolumes.enable = true;
          dates = "weekly";
        };
        rootless = mkIf cfg.rootless {
          enable = true;
          daemon.settings.features.cdi = mkForce cfg.nvidia;
          extraPackages = with pkgs; [
            docker
            docker-client
            docker-buildx
            conmon
            containerd
            fuse-overlayfs
            docker-credential-helpers
            distribution
            docker-gc
          ];
        };
        daemon.settings = {
          features.cdi = mkIf cfg.nvidia true;
          dns = cfg.dns;
        };
        extraOptions = cfg.extraOptions;
      };
      containers.enable = true;
      containerd.enable = true;
      oci-containers.backend = "docker";
    };

    # Local forwarder for container DNS. Bridge containers cannot reach the
    # LAN's resolvers directly here (IPv4 port 53 is filtered on this network),
    # and a dead resolver in the list makes glibc block for its full timeout on
    # every lookup — which is what made every SearXNG engine time out. dnsmasq
    # answers on the docker bridge gateway and forwards to upstreams that
    # actually respond. resolveLocalQueries stays off so the host's own
    # /etc/resolv.conf is unaffected.
    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;
      settings = {
        port = 53;
        listen-address = ["127.0.0.1" "172.17.0.1"];
        bind-dynamic = true;
        no-resolv = true;
        cache-size = 1000;
        server = ["2620:fe::11" "2620:fe::fe:11" "9.9.9.11" "149.112.112.11" "1.1.1.1"];
      };
    };

    networking.firewall.extraInputRules = ''
      ip saddr 172.17.0.0/16 udp dport 53 accept
      ip saddr 172.17.0.0/16 tcp dport 53 accept
    '';

    hardware = mkIf cfg.nvidia {
      # nvidia-container-toolkit.enable = true;
      graphics.enable32Bit = true;
    };

    environment.systemPackages = with pkgs;
      [
        docker # the main application in the module, container runtime
        docker-client # client for container runtime
        docker-buildx # extended building capabilities
        conmon #
        containerd
        fuse-overlayfs
        docker-credential-helpers
        distribution
        docker-gc
        docker-slim # minify containers
        x11docker # run graphical applications (x11) via docker
      ]
      ++ optionals cfg.composeSupport [
        docker-compose
      ];
  };
}
