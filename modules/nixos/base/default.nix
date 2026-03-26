{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base;
in {
  imports = [
    ./fhs.nix
    ./nix.nix
    ./permitted-packages.nix
    ./services.nix
  ];

  options.modules.base = {
    enable = mkEnableOption "Base system configuration";

    timezone = mkOption {
      type = types.str;
      default = "America/New_York";
      description = "System timezone";
    };

    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "System locale";
    };

    consoleFontSize = mkOption {
      type = types.enum ["14" "16" "18" "20"];
      default = "18";
      description = "Console font size";
    };

    hardwareClockInLocalTime = mkOption {
      type = types.bool;
      default = true;
      description = "Use local time for hardware clock (useful for Windows dual boot)";
    };
  };

  config = mkIf cfg.enable {
    console = let
      normal = ["191919" "fc618d" "7bd88f" "fce566" "5ad4e6" "948ae5" "6ab0f3" "555555"];
      bright = ["3c3c3c" "d8557b" "6fbe81" "d9c65b" "53bbcc" "8179c6" "4a9cec" "dcdcdc"];
    in {
      colors = normal ++ bright;
      font = "${pkgs.terminus_font}/share/consolefonts/ter-c${cfg.consoleFontSize}b.psf.gz";
      useXkbConfig = true;
      earlySetup = true;
    };

    i18n = {
      defaultLocale = cfg.locale;
      extraLocaleSettings.LC_TIME = cfg.locale;
      supportedLocales = [
        "${cfg.locale}/UTF-8"
      ];
    };

    time = {
      timeZone = cfg.timezone;
      hardwareClockInLocalTime = cfg.hardwareClockInLocalTime;
    };
    hardware.enableAllFirmware = true;
    environment.systemPackages = [pkgs.dmidecode];
  };
}
