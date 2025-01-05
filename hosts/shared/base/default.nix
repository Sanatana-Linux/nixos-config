{pkgs, ...}: {
  imports = [./nix.nix];

  console = let
    normal = ["191919" "fc618d" "7bd88f" "fce566" "5ad4e6" "948ae5" "6ab0f3" "69676c"];
    bright = ["2c2c2c" "d8557b" "6fbe81" "d9c65b" "53bbcc" "8179c6" "4a9cec" "dcd8e1"];
  in {
    colors = normal ++ bright;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-c14b.psf.gz";
    useXkbConfig = true;
    earlySetup = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings.LC_TIME = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
    ];
  };

  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };
}
