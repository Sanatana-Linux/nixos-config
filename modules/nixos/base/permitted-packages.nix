{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.permittedPackages;
in {
  options.modules.base.permittedPackages = {
    enable = mkEnableOption "Configure permitted insecure packages";

    packages = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of additional insecure packages to permit";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
      # Required for the Android platform-tools / SDK used by waydroid and the
      # android device support (hardware.devices.android). Without this the
      # system build aborts asking for android-sdk-license acceptance.
      android_sdk.accept_license = true;
      permittedInsecurePackages =
        [
          "pnpm-10.29.2"
          # Both ventoy releases are permitted: the pinned nixpkgs in flake.nix
          # ships 1.1.17 while the channel it is held behind ships 1.1.18.
          # Listing both keeps the pin reversible without editing this list.
          "ventoy-1.1.17"
          "ventoy-1.1.18"
          "electron-39.8.10"
        ]
        ++ cfg.packages;
    };
  };
}
