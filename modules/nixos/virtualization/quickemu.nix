{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.virtualization.quickemu;
in {
  options.modules.virtualization.quickemu = {
    enable = mkEnableOption "Quickemu - Simple QEMU wrapper for quick VM management";
    
    installUtils = mkOption {
      type = types.bool;
      default = true;
      description = "Install additional QEMU utilities alongside quickemu";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        quickemu
        quickgui
      ]
      ++ optionals cfg.installUtils [
        qemu-utils
        qemu_kvm
      ];

    # Ensure libvirt is available for quickemu if needed
    virtualisation.libvirtd.enable = mkDefault false;
    
    # Add user to kvm group for direct KVM access
    users.groups.kvm = {};
  };
}