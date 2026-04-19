{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.xresources;
in {
  options.modules.xresources = {
    enable = mkEnableOption "X resources configuration with Monokai Pro theme";
  };

  config = mkIf cfg.enable {
    xresources.extraConfig = ''
      Xft.dpi: 96
      ! Now featuring Monokai Pro Spectrum
      *background: #222222
      *foreground: #f9f9f9
      ! black
      *color0: #363537
      *color8: #525053
      ! red
      *color1: #fc618d
      *color9: #f92672
      ! green
      *color2: #7bd88f
      *color10: #a6e22e
      ! yellow
      *color3: #fce566
      *color11: #e6db74
      ! blue
      *color4: #6b9ce8
      *color12: #6b9ce8
      ! magenta
      *color5: #948ae3
      *color13: #ae81ff
      ! cyan
      *color6: #5ad4e6
      *color14: #78dce8
      ! white
      *color7: #f9f9f9
      *color15: #f9f9f9
    '';
  };
}
