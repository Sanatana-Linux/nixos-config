{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.apps.ai.comfyui;
in {
  options.modules.system.apps.ai.comfyui = {
    enable = mkEnableOption "ComfyUI with CUDA support via comfyui-nix";

    enableManager = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the built-in ComfyUI Manager";
    };

    port = mkOption {
      type = types.port;
      default = 8188;
      description = "Port for the ComfyUI web interface";
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Listen address (0.0.0.0 for network access)";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/comfyui";
      description = "Data directory for models, outputs, custom nodes";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the port in the firewall";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional CLI arguments for ComfyUI";
    };
  };

  config = mkIf cfg.enable {
    services.comfyui = {
      enable = true;
      gpuSupport = "cuda";
      enableManager = cfg.enableManager;
      port = cfg.port;
      listenAddress = cfg.listenAddress;
      dataDir = cfg.dataDir;
      openFirewall = cfg.openFirewall;
      extraArgs = cfg.extraArgs;
    };
  };
}
