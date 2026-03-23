{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.hardware.iphone = {
    enable = mkEnableOption "iPhone/iOS device access via USB";
  };

  config = mkIf config.modules.hardware.iphone.enable {
    # Install iOS device management tools
    environment.systemPackages = with pkgs; [
      libimobiledevice # Library for communicating with iOS devices
      ifuse # FUSE filesystem for mounting iOS devices
      ideviceinstaller # Manage apps on iOS devices
      usbmuxd # USB multiplexing daemon for iOS devices
    ];

    # Enable usbmuxd service for iOS device communication
    services.usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd;
    };

    # Add user to plugdev group for device access
    users.groups.plugdev = {};
  };
}
