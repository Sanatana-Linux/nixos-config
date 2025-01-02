{ inputs, config, pkgs, ... }:

let
  monokaiprospectrum = {
    type = "dark";
    name = "monokaiprospectrum";
    ok = "#7bd88f"; # green
    warn = "#fd9353"; # orange
    err = "#fc618d"; # red
    dis = "#948ae3"; # purple
    pri = "#5ad4e6"; # blue
    bg = "#19191a"; # base0
    mbg = "#232325"; # base1
    bg3 = "#28282a"; # base2
    bg4 = "#353538"; # base3
    fg = "#f7f1ff"; # base8
    fg3 = "#bab6c0"; # base7
    fg2 = "#69676c"; # base5
    fg4 = "#525053"; # base4
  };
in
{
  programs.ghostty = {
    enable = true;
    settings = {
      background = monokaiprospectrum.bg;
      palette = [
        "0=${monokaiprospectrum.fg4}"
          "1=${monokaiprospectrum.err}"
          "2=${monokaiprospectrum.ok}"
          "3=${monokaiprospectrum.warn}"
          "4=${monokaiprospectrum.pri}"
          "5=${monokaiprospectrum.dis}"
          "6=${monokaiprospectrum.pri}"
          "7=${monokaiprospectrum.fg3}"
          "8=${monokaiprospectrum.fg2}"
          "9=${monokaiprospectrum.err}"
          "10=${monokaiprospectrum.ok}"
          "11=${monokaiprospectrum.warn}"
          "12=${monokaiprospectrum.pri}"
          "13=${monokaiprospectrum.dis}"
          "14=${monokaiprospectrum.pri}"
          "15=${monokaiprospectrum.fg}"
        "16=${monokaiprospectrum.warn}"
        "17=${monokaiprospectrum.err}"
      ];
      selection-foreground = monokaiprospectrum.bg;
      selection-background = monokaiprospectrum.dis;
      window-vsync = true;
    };
  };
}
