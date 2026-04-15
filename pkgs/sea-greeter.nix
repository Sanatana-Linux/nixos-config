{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  webkitgtk_4_1,
  lightdm,
  glib,
  libyaml,
  typescript,
  makeWrapper,
  cmake,
  theme ? null,
  backgrounds ? null,
  enableHWAcceleration ? false,
}:
stdenv.mkDerivation rec {
  pname = "sea-greeter";
  version = "unstable-2024-02-03";

  src = fetchFromGitHub {
    owner = "JezerM";
    repo = "sea-greeter";
    rev = "ffd2f3c52601127a46d478cd2cd4a9e03719c73f";
    hash = "sha256-jAk1DTftPtG9mj0NmDX0zhzRZkHAFpdAklRgBE3Orrc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [meson ninja pkg-config typescript makeWrapper];

  buildInputs = [gtk3 webkitgtk_4_1 lightdm glib libyaml theme cmake];

  configurePhase = ''
    runHook preConfigure

    substituteInPlace src/theme.c \
    --replace '/usr/share/web-greeter/themes/' \
              "$out/usr/share/web-greeter/themes/"
    substituteInPlace src/settings.c \
    --replace '/etc/lightdm/web-greeter.yml' \
              "$out/etc/lightdm/web-greeter.yml"
    substituteInPlace src/settings.c \
    --replace '/usr/share/web-greeter/themes/' \
              "$out/usr/share/web-greeter/themes/"
    substituteInPlace data/web-greeter.yml \
    --replace '/usr/share/' \
              "$out/usr/share/"
    ${lib.optionalString (theme != null) ''
      substituteInPlace data/web-greeter.yml \
      --replace 'theme: gruvbox' \
                "theme: ${theme.pname}"
    ''}

    runHook postConfigure
  '';

  buildPhase = ''
    meson setup build --prefix=$out -Dwith-webext-dir=$out/usr/lib/sea-greeter
    ninja -C build
  '';

  installPhase = ''
    meson install -C build --destdir=$out

    # So, for some reason, if I either don't do destdir=$out or prefix=$out for
    # the build, what happens is that either the bin/ or the config files copied
    # over from the setup don't appear in the final nix pkg. This means the only
    # way I've found to guarantee that every file is there to do both. This has
    # the problem that part of the files is double-"indented", meaning that the
    # nix store path is repeated with /nix/store/.../nix/store/.../bin. But
    # these files you can just move.
    NESTED_DIR=$(ls -d $out/nix/store/*)
    shopt -s dotglob
    mv $NESTED_DIR/* $out/
    rm -rf $out/nix

    ${lib.optionalString (enableHWAcceleration == false) ''
      wrapProgram $out/bin/sea-greeter --set WEBKIT_DISABLE_DMABUF_RENDERER 1
    ''}

    substituteInPlace $out/usr/share/xgreeters/sea-greeter.desktop \
      --replace "Exec=sea-greeter" "Exec=$out/bin/sea-greeter"

    # the xserver.lightdm.greeter.package options expects the .desktop file to
    # be on the root level.
    ln -s $out/usr/share/xgreeters/sea-greeter.desktop $out/sea-greeter.desktop

    ${lib.optionalString (theme != null) ''
      echo "Installing theme: ${theme.pname}"
      mkdir -p "$out/usr/share/web-greeter/themes"
      ln -s ${theme} "$out/usr/share/web-greeter/themes/${theme.pname}"
    ''}
    ${lib.optionalString (backgrounds != null) ''
      echo "Installing backgrounds from: ${backgrounds}"
      local backgrounds_dir="$out/usr/share/backgrounds"
      mkdir -p "$backgrounds_dir"
      ln -s "${backgrounds}"/* "$backgrounds_dir/"
      ls "$backgrounds_dir"
    ''}
  '';

  postPatch = ''
    substituteInPlace src/meson.build \
      --replace "webkit2gtk-4.0" "webkit2gtk-4.1"
    substituteInPlace src/meson.build \
      --replace "webkit2gtk-web-extension-4.0" "webkit2gtk-web-extension-4.1"

    sed -i 's/libsoup-2.4/libsoup-3.0/g' src/meson.build
  '';

  meta = with lib; {
    description = "Another LightDM greeter made with WebKitGTK2";
    homepage = "https://github.com/JezerM/sea-greeter";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}
