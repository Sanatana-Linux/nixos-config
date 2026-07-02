{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.hardware.devices.android = {
    enable = mkEnableOption "Android development tools";

    devTools = mkOption {
      type = types.bool;
      default = true;
      description = "Additional Android reverse-engineering and image manipulation tools";
    };
  };

  config = mkIf config.modules.hardware.devices.android.enable {
    # Create plugdev group for Android device access
    users.groups.plugdev = {};

    # Enable ADB users group for Android debugging
    users.groups.adbusers = {};

    environment.systemPackages = with pkgs;
      [
        abootimg

        # rootless access to adb fs
        adbfs-rootless
        # backup extraction
        android-backup-extractor
        # mount android with fuse
        go-mtpfs
        # download apks from terminal
        apkeep
        # identify .apk files
        apkid
        #  Copy/extract/patch android apk signatures & compare APKs
        apksigcopier
        # sign and verify apk files
        apksigner
        # reverse engineering apks
        apktool
        # manipulate app bundles
        bundletool
        # tools for .dex files
        dex2jar
        # patch android images
        imgpatchtools
        # Android SDK platform tools (adb, fastboot, etc...)
        android-tools
        payload-dumper-go # Tool for extracting all .img files from an Android OTA payload.bin file
      ]
      # Sparse image conversion for Android firmware images
      ++ optionals config.modules.hardware.devices.android.devTools (with pkgs; [simg2img]);
  };
}
