{ pkgs }:

with pkgs; [
  ascii-image-converter
  figlet
  gimp-with-plugins
  gimpPlugins.exposureBlend
  gimpPlugins.fourier
  gimpPlugins.gap
  gimpPlugins.gimplensfun
  gimpPlugins.lightning
  gimpPlugins.lqrPlugin
  gimpPlugins.resynthesizer
  gimpPlugins.texturize
  gimpPlugins.waveletSharpen
  giph
  graphicsmagick
  image_optim
  imagemagick
  imgpatchtools
  imv
  inkscape-with-extensions
  jp2a
  jpegoptim
  krita
  nodePackages_latest.svgo
  optipng
  pinsel
  pngcrush
  python311Packages.pyfiglet
  svgcleaner
  toilet
  xcftools
]

