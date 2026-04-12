{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.hardware.android.enable = mkEnableOption "Android development tools";

  config = mkIf config.modules.hardware.android.enable {
    # Create plugdev group for Android device access
    users.groups.plugdev = {};

    # Enable ADB users group for Android debugging
    users.groups.adbusers = {};

    environment.systemPackages = with pkgs; [
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
    ];
  };
}
