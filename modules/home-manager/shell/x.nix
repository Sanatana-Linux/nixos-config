{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.shell.x;
in {
  options.modules.shell.x = {
    enable = mkEnableOption "X resources configuration";
  };

  config = mkIf cfg.enable {
    xresources.properties = {
      "Xft.dpi" = 96;
      "*background" = "#222222";
      "*foreground" = "#f9f9f9";

      "*color0" = "#181a1c";
      "*color1" = "#fc618d";
      "*color2" = "#7bd88f";
      "*color3" = "#fce566";
      "*color4" = "#fd9353";
      "*color5" = "#948ae3";
      "*color6" = "#5ad4e6";
      "*color7" = "#f9f9f9";

      "*color8" = "#2c2525";
      "*color9" = "#fc618d";
      "*color10" = "#7bd88f";
      "*color11" = "#fce566";
      "*color12" = "#fd9353";
      "*color13" = "#948ae3";
      "*color14" = "#5ad4e6";
      "*color15" = "#f9f9f9";
    };
  };
}
