{
  config,
  lib,
  pkgs,
  ...
}: {
    environment.systemPackages = with pkgs; [
        abootimg

# rootless access to adb fs 
  adbfs-rootless
  # Tool and Python library to interact with Android Files
  androguard
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
      edl # Qualcomm EDL tool
      payload-dumper-go # Tool for extracting all .img files from an Android OTA payload.bin file
      # Non-decompiling Android vulnerability scanner
      trueseeing
    ];

    # https://nixos.wiki/wiki/Android
    programs.adb.enable = true;

    services.udev.packages = with pkgs; [
      # To run apps on an Android device, the computer needs to have installed
      # the udev rules that cover that Android device
      android-udev-rules
    ];

  };
