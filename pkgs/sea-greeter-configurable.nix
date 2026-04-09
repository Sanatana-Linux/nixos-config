{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, gtk3, webkitgtk_4_1
, lightdm, glib, libyaml, typescript, makeWrapper, cmake
, theme ? null, themes ? [], backgrounds ? null, selectedTheme ? "gruvbox"
, enableHWAcceleration ? false }:

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

  nativeBuildInputs = [ meson ninja pkg-config typescript makeWrapper ];

  buildInputs = [ gtk3 webkitgtk_4_1 lightdm glib libyaml cmake ] 
    ++ lib.optional (theme != null) theme
    ++ themes;

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
    
    # Configure selected theme
    ${if (theme != null) then ''
      substituteInPlace data/web-greeter.yml \
      --replace 'theme: gruvbox' \
                "theme: ${theme.pname}"
    '' else if (themes != []) then ''
      substituteInPlace data/web-greeter.yml \
      --replace 'theme: gruvbox' \
                "theme: ${selectedTheme}"
    '' else ""}
    
    # Configure background path
    ${lib.optionalString (backgrounds != null) ''
      substituteInPlace data/web-greeter.yml \
      --replace 'background_images_dir: /usr/share/backgrounds' \
                "background_images_dir: $out/usr/share/backgrounds"
    ''}

    runHook postConfigure
  '';

  buildPhase = ''
    meson setup build --prefix=$out -Dwith-webext-dir=$out/usr/lib/sea-greeter
    ninja -C build
  '';

  installPhase = ''
    meson install -C build --destdir=$out

    # Fix double-nested directory issue
    NESTED_DIR=$(ls -d $out/nix/store/* 2>/dev/null || echo "")
    if [ -n "$NESTED_DIR" ]; then
      shopt -s dotglob
      mv $NESTED_DIR/* $out/
      rm -rf $out/nix
    fi

    ${lib.optionalString (enableHWAcceleration == false) ''
      wrapProgram $out/bin/sea-greeter --set WEBKIT_DISABLE_DMABUF_RENDERER 1
    ''}

    substituteInPlace $out/usr/share/xgreeters/sea-greeter.desktop \
      --replace "Exec=sea-greeter" "Exec=$out/bin/sea-greeter"

    # The xserver.lightdm.greeter.package option expects the .desktop file to 
    # be on the root level. 
    ln -s $out/usr/share/xgreeters/sea-greeter.desktop $out/sea-greeter.desktop

    # Install themes
    mkdir -p "$out/usr/share/web-greeter/themes"
    
    ${lib.optionalString (theme != null) ''
      echo "Installing single theme: ${theme.pname}"
      ln -s ${theme} "$out/usr/share/web-greeter/themes/${theme.pname}"
    ''}
    
    ${lib.optionalString (themes != []) ''
      echo "Installing multiple themes"
      ${lib.concatMapStringsSep "\n" (t: ''
        echo "Installing theme: ${t.pname}"
        ln -s ${t} "$out/usr/share/web-greeter/themes/${t.pname}"
      '') themes}
    ''}
    
    # Install backgrounds
    ${lib.optionalString (backgrounds != null) ''
      echo "Installing backgrounds from: ${backgrounds}" 
      mkdir -p "$out/usr/share/backgrounds"
      ln -s "${backgrounds}"/* "$out/usr/share/backgrounds/"
      ls "$out/usr/share/backgrounds"
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
    maintainers = [ ];
  };
}