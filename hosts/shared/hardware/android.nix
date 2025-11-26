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
    # Android Translation Layer
    android-translation-layer
  ];

  # https://nixos.wiki/wiki/Android
  programs.adb.enable = true;

  # Android udev rules are now built into systemd uaccess rules
}
