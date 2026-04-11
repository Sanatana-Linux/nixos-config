{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, gtk3, webkitgtk_4_1
, lightdm, glib, libyaml, typescript, makeWrapper, cmake
, themes ? [], backgrounds ? null, selectedTheme ? "gruvbox"
, enableHWAcceleration ? false, defaultWallpaper ? null }:

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
    ++ lib.optionals (themes != []) themes;

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
    ${if (themes != [] && selectedTheme != "gruvbox") then ''
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
    
    # Configure default wallpaper if specified
    ${lib.optionalString (defaultWallpaper != null) ''
      echo "Configuring default wallpaper: ${defaultWallpaper}"
      # Add custom configuration for default wallpaper
      # This creates a configuration override that themes can read
      mkdir -p build/config
      cat > build/config/default-wallpaper.conf << EOF
# Default wallpaper configuration for sea-greeter
default_wallpaper=${defaultWallpaper}
EOF
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
    
    ${lib.optionalString (themes != []) ''
      echo "Installing themes"
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
    
    # Install default wallpaper configuration
    ${lib.optionalString (defaultWallpaper != null) ''
      echo "Installing default wallpaper configuration: ${defaultWallpaper}"
      mkdir -p "$out/etc/lightdm"
      cat > "$out/etc/lightdm/default-wallpaper.conf" << EOF
# Default wallpaper configuration for sea-greeter themes
default_wallpaper=${defaultWallpaper}
EOF
      
      # Create a JavaScript override for web-greeter themes to use default wallpaper
      mkdir -p "$out/usr/share/web-greeter"
      cat > "$out/usr/share/web-greeter/default-wallpaper.js" << 'EOF'
// Default wallpaper override for web-greeter themes
(function() {
    // Read the default wallpaper configuration
    const defaultWallpaper = '${defaultWallpaper}';
    
    // Override the wallpaper selection when page loads
    if (window.lightdm && typeof window.lightdm === 'object') {
        // Store the original wallpaper method if it exists
        const originalSetWallpaper = window.lightdm.set_wallpaper || function() {};
        
        // Override or set the wallpaper
        window.addEventListener('load', function() {
            setTimeout(function() {
                // Try different common methods themes use to set wallpapers
                if (typeof setWallpaper === 'function') {
                    setWallpaper('/usr/share/backgrounds/' + defaultWallpaper);
                } else if (typeof changeWallpaper === 'function') {
                    changeWallpaper('/usr/share/backgrounds/' + defaultWallpaper);
                } else {
                    // Direct DOM manipulation fallback
                    const body = document.body || document.documentElement;
                    if (body) {
                        body.style.backgroundImage = 'url(/usr/share/backgrounds/' + defaultWallpaper + ')';
                        body.style.backgroundSize = 'cover';
                        body.style.backgroundPosition = 'center';
                        body.style.backgroundRepeat = 'no-repeat';
                    }
                }
            }, 100);
        });
    }
})();
EOF
      
      # Create a theme configuration override for litarvan theme if it exists
      if [ -d "$out/usr/share/web-greeter/themes/litarvan" ] || [ -L "$out/usr/share/web-greeter/themes/litarvan" ]; then
        echo "Configuring litarvan theme with default wallpaper"
        mkdir -p "$out/usr/share/web-greeter/themes/litarvan/config"
        cat > "$out/usr/share/web-greeter/themes/litarvan/config/default.conf" << EOF
default_wallpaper=${defaultWallpaper}
EOF
      fi
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