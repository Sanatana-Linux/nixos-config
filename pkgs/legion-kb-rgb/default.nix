{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook3,
  gtk4,
  libadwaita,
  hicolor-icon-theme,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "legion-kb-rgb";
  version = "1.0.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "andershfranzen";
    repo = "legion-kb-rgb";
    rev = "v${version}";
    hash = "sha256-hWj1bIe0+M2y+zzwMZfTiFAk1lwJ2rGXb9bbZv5949E=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    hicolor-icon-theme
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    sitePackages=$out/lib/python${python3.pythonVersion}/site-packages
    mkdir -p $sitePackages/legion_kb_rgb
    cp legion_kb_rgb/__init__.py $sitePackages/legion_kb_rgb/
    cp legion_kb_rgb/gui.py $sitePackages/legion_kb_rgb/

    mkdir -p $out/libexec
    install -m755 legion-kb-rgb $out/libexec/legion-kb-rgb
    install -m755 legion-kb-rgb-gui $out/libexec/legion-kb-rgb-gui
    sed -i "1s|#!.*|#!${python3}/bin/python3|" $out/libexec/legion-kb-rgb
    sed -i "1s|#!.*|#!${python3}/bin/python3|" $out/libexec/legion-kb-rgb-gui

    mkdir -p $out/bin
    for bin in legion-kb-rgb legion-kb-rgb-gui; do
      cat > $out/bin/$bin << EOF
    #!/bin/sh
    export PYTHONPATH="$sitePackages\''${PYTHONPATH:+:}\$PYTHONPATH"
    exec $out/libexec/$bin "\$@"
    EOF
      chmod +x $out/bin/$bin
    done

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp legion-kb-rgb.svg $out/share/icons/hicolor/scalable/apps/legion-kb-rgb.svg

    mkdir -p $out/share/applications
    cat > $out/share/applications/legion-kb-rgb.desktop << 'DESKTOP'
    [Desktop Entry]
    Type=Application
    Name=Legion Keyboard RGB
    Comment=Control Lenovo Legion Spectrum keyboard RGB lighting
    Exec=legion-kb-rgb-gui
    Icon=legion-kb-rgb
    Terminal=false
    StartupWMClass=legion-kb-rgb
    Categories=Settings;HardwareSettings;Utility;
    Keywords=keyboard;rgb;led;backlight;legion;lenovo;
    StartupNotify=true
    DESKTOP

    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Control Lenovo Legion Spectrum keyboard RGB lighting (CLI + GUI)";
    homepage = "https://github.com/andershfranzen/legion-kb-rgb";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "legion-kb-rgb";
  };
}