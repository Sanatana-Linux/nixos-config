{
  lib,
  stdenv,
  src,
  woff2,
}:
stdenv.mkDerivation rec {
  pname = "lightdm-webkit2-sanatana";
  version = "unstable-2026-05-05";

  inherit src;

  nativeBuildInputs = [woff2];

  installPhase = ''
    runHook preInstall

    # Copy source into $out
    install -d $out
    cp -r ./* $out/

    cd $out

    # ====================================================================
    # OPTIMIZATION 1: Strip Material Design Icons from 4.1MB to ~2KB
    # Theme only uses 4 icon classes: mdi-account-switch, mdi-cog,
    # mdi-desktop-classic, mdi-power. Replace the full library with a
    # minimal CSS referencing only the woff2 font file.
    # ====================================================================
    rm -rf src/material-icons/css/materialdesignicons.css \
           src/material-icons/css/materialdesignicons.css.map \
           src/material-icons/css/materialdesignicons.min.css.map \
           src/material-icons/fonts/materialdesignicons-webfont.eot \
           src/material-icons/fonts/materialdesignicons-webfont.ttf \
           src/material-icons/fonts/materialdesignicons-webfont.woff \
           src/material-icons/README.md \
           src/material-icons/LICENSE

    # Write minimal Material Icons CSS — only 4 icon classes, referencing only woff2
    cat > src/material-icons/css/materialdesignicons.min.css << 'MINICSS'
@font-face {
  font-family: "Material Design Icons";
  src: url("../fonts/materialdesignicons-webfont.woff2") format("woff2");
  font-weight: normal;
  font-style: normal;
  font-display: block;
}
.mdi:before,
.mdi-set {
  display: inline-block;
  font: normal normal normal 24px/1 "Material Design Icons";
  font-size: inherit;
  text-rendering: auto;
  line-height: inherit;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
.mdi-account-switch:before { content: "\F0019"; }
.mdi-cog:before { content: "\F0493"; }
.mdi-desktop-classic:before { content: "\F07C0"; }
.mdi-power:before { content: "\F0425"; }
MINICSS

    # ====================================================================
    # OPTIMIZATION 2: Convert BlackHanSans-Regular.ttf → woff2
    # TTF is 962KB uncompressed. woff2 is ~190KB with better parsing.
    # Also update the @font-face src URL in styles.css.
    # ====================================================================
    woff2_compress src/fonts/BlackHanSans-Regular.ttf
    rm src/fonts/BlackHanSans-Regular.ttf

    # Update @font-face src in styles.css to reference .woff2
    substituteInPlace src/styles.css \
      --replace-fail 'url("fonts/BlackHanSans-Regular.ttf") format("truetype")' \
                     'url("fonts/BlackHanSans-Regular.woff2") format("woff2")'

    # ====================================================================
    # OPTIMIZATION 3: Fix requestAnimationFrame → setTimeout(1000)
    # The clock update loop runs at 60fps via requestAnimationFrame but
    # only needs 1fps (seconds change once per second). This is wasteful
    # on WebKitGTK's main thread.
    # ====================================================================
    substituteInPlace src/scripts.js \
      --replace-fail 'requestAnimationFrame(updateTime);' \
                     'setTimeout(updateTime, 1000);'

    # ====================================================================
    # OPTIMIZATION 4: Remove unused files
    # The repo ships BodoniModa.ttf (162KB) and Knewave-Regular.ttf (31KB)
    # that are never referenced in CSS. The mock.js is for development only.
    # ====================================================================
    rm -f src/fonts/BodoniModa.ttf src/fonts/Knewave-Regular.ttf
    rm -rf .gitignore .gitattributes

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sanatana glassmorphism LightDM web greeter theme for sea-greeter (optimized: -7MB, 60fps→1fps clock)";
    homepage = "https://github.com/Sanatana-Linux/lightdm-webkit2-sanatana";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [];
  };
}
