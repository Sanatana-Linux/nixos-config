{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.networking.dhcpcd;
in {
  options.modules.system.networking.dhcpcd = {
    enable = mkEnableOption "dhcpcd DHCP client daemon";

    persistent = mkOption {
      type = types.bool;
      default = true;
      description = "Keep DHCP lease across reboots (DHCP server may not re-offer the same address)";
    };

    wait = mkOption {
      type = types.enum ["background" "any" "ipv4" "ipv6" "both" "if-carrier-up"];
      default = "any";
      description = "When dhcpcd forks to background. 'any' waits for any IP, 'background' forks immediately.";
    };
  };

  config = mkIf cfg.enable {
    networking.dhcpcd = {
      enable = true;
      persistent = cfg.persistent;
      wait = cfg.wait;
    };

    # dhcpcd conflicts with NetworkManager — both manage interfaces
    assertions = [
      {
        assertion = !config.modules.system.networking.networkmanager.enable;
        message = "dhcpcd cannot be enabled alongside NetworkManager. Set modules.system.networking.networkmanager.enable = false to use dhcpcd.";
      }
    ];
  };
}
