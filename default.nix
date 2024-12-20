{
  i3lock-fancy-rapid,
  corrupter,
  scrot,
  writeShellScriptBin,
}:
writeShellScriptBin "lockscreen" ''
    bg_image="''${XDG_RUNTIME_DIR:-/tmp}/lock-image.png"

    # Capture screen
    ${scrot}/bin/scrot -o $bg_image


  ${corrupter}/bin/corrupter $bg_image $bg_image
    # Pixelate
    ${imagemagick}/bin/convert -scale 10% -scale 1000% $bg_image $bg_image

    # Lock
    ${i3lock-fancy-rapid-unstable}/bin/i3lock -ni $bg_image


    # Remove image on exit
    rm -f $bg_image
''
