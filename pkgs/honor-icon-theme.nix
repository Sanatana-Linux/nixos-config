{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  numix-icon-theme,
  numix-icon-theme-circle,
}:
stdenv.mkDerivation rec {
  pname = "honor-icon-theme";
  version = "unstable-2024-01-01";

  src = fetchFromGitHub {
    owner = "yeyushengfan258";
    repo = "Honor-icon-theme-";
    rev = "f86c4e18ec180ddafa8887c65ca9c48ec28dd3b3";
    hash = "sha256-PUK56cNg3T2eiB70JiQrI3haXrxd5bx9mXn0kdV0glQ=";
  };

  nativeBuildInputs = [gtk3];

  propagatedBuildInputs = [
    numix-icon-theme
    numix-icon-theme-circle
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons

    # Install Honor-grey (grey folder variant, light mode)
    mkdir -p $out/share/icons/Honor-grey
    cp -r src/16 $out/share/icons/Honor-grey/
    cp -r src/22 $out/share/icons/Honor-grey/
    cp -r src/24 $out/share/icons/Honor-grey/
    cp -r src/32 $out/share/icons/Honor-grey/
    cp -r src/scalable $out/share/icons/Honor-grey/
    cp -r src/symbolic $out/share/icons/Honor-grey/
    cp src/index.theme $out/share/icons/Honor-grey/

    # Update index.theme
    cd $out/share/icons/Honor-grey
    sed -i "s/^Name=Honor$/Name=Honor-grey/" index.theme
    sed -i "s/^Comment=.*$/Comment=Honor icon theme with grey folders/" index.theme
    sed -i "s/^Inherits=.*$/Inherits=Numix,Numix-Circle,hicolor/" index.theme

    # Replace default folder icons with grey variants in scalable/places
    cd scalable/places
    for icon in default-*.svg folder*.svg user-*.svg; do
      if [ -f "$icon" ]; then
        grey_icon="grey-$icon"
        if [ -f "$grey_icon" ]; then
          rm -f "$icon"
          ln -sf "$grey_icon" "$icon"
        fi
      fi
    done
    cd $out/share/icons/Honor-grey

    # Process links - copy files from links, resolving symlinks
    # 16
    for subdir in actions devices mimetypes panel places; do
      if [ -d "links/16/$subdir" ]; then
        mkdir -p "16/$subdir"
        for icon in links/16/$subdir/*; do
          icon_name=$(basename "$icon")
          if [ -L "$icon" ]; then
            target=$(readlink "$icon")
            if [ ! -e "16/$subdir/$icon_name" ]; then
              # Resolve the symlink target
              if [ -f "16/$subdir/$target" ]; then
                ln -sf "$target" "16/$subdir/$icon_name"
              fi
            fi
          fi
        done
      fi
    done

    # 22
    for subdir in actions emblems mimetypes panel; do
      if [ -d "links/22/$subdir" ]; then
        mkdir -p "22/$subdir"
        for icon in links/22/$subdir/*; do
          icon_name=$(basename "$icon")
          if [ -L "$icon" ]; then
            target=$(readlink "$icon")
            if [ ! -e "22/$subdir/$icon_name" ]; then
              if [ -f "22/$subdir/$target" ]; then
                ln -sf "$target" "22/$subdir/$icon_name"
              fi
            fi
          fi
        done
      fi
    done

    # 24
    for subdir in actions animations panel places; do
      if [ -d "links/24/$subdir" ]; then
        mkdir -p "24/$subdir"
        for icon in links/24/$subdir/*; do
          icon_name=$(basename "$icon")
          if [ -L "$icon" ]; then
            target=$(readlink "$icon")
            if [ ! -e "24/$subdir/$icon_name" ]; then
              if [ -f "24/$subdir/$target" ]; then
                ln -sf "$target" "24/$subdir/$icon_name"
              fi
            fi
          fi
        done
      fi
    done

    # 32
    for subdir in actions devices mimetypes places; do
      if [ -d "links/32/$subdir" ]; then
        mkdir -p "32/$subdir"
        for icon in links/32/$subdir/*; do
          icon_name=$(basename "$icon")
          if [ -L "$icon" ]; then
            target=$(readlink "$icon")
            if [ ! -e "32/$subdir/$icon_name" ]; then
              if [ -f "32/$subdir/$target" ]; then
                ln -sf "$target" "32/$subdir/$icon_name"
              fi
            fi
          fi
        done
      fi
    done

    # scalable
    for subdir in apps devices places; do
      if [ -d "links/scalable/$subdir" ]; then
        mkdir -p "scalable/$subdir"
        for icon in links/scalable/$subdir/*; do
          icon_name=$(basename "$icon")
          if [ -L "$icon" ]; then
            target=$(readlink "$icon")
            if [ ! -e "scalable/$subdir/$icon_name" ]; then
              if [ -f "scalable/$subdir/$target" ]; then
                ln -sf "$target" "scalable/$subdir/$icon_name"
              fi
            fi
          fi
        done
      fi
    done

    # Remove links directory
    rm -rf links

    # Create HiDPI symlinks
    ln -s 16 16@2x
    ln -s 22 22@2x
    ln -s 24 24@2x
    ln -s 32 32@2x
    ln -s scalable scalable@2x

    # Install Honor-grey-dark (grey folder variant, dark mode)
    cd $out/share/icons
    mkdir -p Honor-grey-dark/{16,22,24}

    cp -r Honor-grey/16/{actions,devices,places,mimetypes,panel,status} Honor-grey-dark/16/
    cp -r Honor-grey/22/{actions,emblems,mimetypes,panel} Honor-grey-dark/22/
    cp -r Honor-grey/24/{actions,animations,panel} Honor-grey-dark/24/

    # Symlink shared directories from light variant
    cd Honor-grey-dark
    ln -s ../Honor-grey/scalable scalable
    ln -s ../Honor-grey/symbolic symbolic
    ln -s ../Honor-grey/32 32

    # Change icon colors for dark theme
    find 16/actions 22/actions 24/actions -name "*.svg" -exec sed -i "s/#5d656b/#d3dae3/g" {} \;
    find 16/{places,devices} -name "*.svg" -exec sed -i "s/#808080/#d3dae3/g" {} \;

    # Create index.theme for dark variant
    cp ../Honor-grey/index.theme .
    sed -i "s/Honor-grey/Honor-grey-dark/g" index.theme
    sed -i "s/^Inherits=.*$/Inherits=Numix,Numix-Circle,hicolor/" index.theme

    # Create HiDPI symlinks
    ln -s 16 16@2x
    ln -s 22 22@2x
    ln -s 24 24@2x

    runHook postInstall
  '';

  postFixup = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = with lib; {
    description = "A colorful design icon theme for Linux desktops (grey variant)";
    homepage = "https://github.com/yeyushengfan258/Honor-icon-theme-";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}
