{pkgs, ...}: {
  imports = [./nix.nix];

  console = let
    normal = ["1c1c1c" "F83D80" "85ff94" "F0ffaa" "00caff" "660ed0" "00eaff" "d1d1d1"];
    bright = ["2c2c2c" "Ff28a9" "4dd564" "Ffff73" "0badff" "85ff95" "8265ff" "919191"];
  in {
    colors = normal ++ bright;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-c14b.psf.gz";
    useXkbConfig = true;
    keyMap = "us";
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
