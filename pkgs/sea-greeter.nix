{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  typescript,
  gcc,
  gtk3,
  webkitgtk_4_1,
  libyaml,
  glib,
  lightdm,
  wrapGAppsHook3,
  gobject-introspection,
}:
stdenv.mkDerivation rec {
  pname = "sea-greeter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "JezerM";
    repo = "sea-greeter";
    rev = "ffd2f3c52601127a46d478cd2cd4a9e03719c73f";
    sha256 = "1q58nzksa1hbradb2z01kgljbb3fa1pv535b5xk4b84l1nw5qgp4";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    typescript
    gcc
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    libyaml
    glib
    lightdm
  ];

  mesonFlags = [
    "-Dwith-webext-dir=${placeholder "out"}/lib/sea-greeter"
  ];

  postPatch = ''
    # Fix paths in source if needed
    substituteInPlace data/meson.build \
      --replace-fail "/usr" "$out" || true
  '';

  meta = with lib; {
    description = "LightDM greeter made with WebKit2GTK - customizable with web technologies";
    homepage = "https://web-greeter-page.vercel.app";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [];
  };
}
