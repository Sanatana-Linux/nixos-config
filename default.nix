{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
  gnome-themes-extra,
  gtk-engine-murrine,
  jdupes,
  sassc,
  themeVariants ? [], # default: blue
  colorVariants ? [], # default: all
  sizeVariants ? [], # default: standard
  tweaks ? [],
}: let
  pname = "magnetic-gtk-theme";
in
  lib.checkListOfEnum "${pname}: theme variants" ["default" "purple" "pink" "red" "orange" "yellow" "green" "teal" "grey" "all"] themeVariants
  lib.checkListOfEnum "${pname}: color variants" ["standard" "light" "dark"]
  colorVariants
  lib.checkListOfEnum "${pname}: size variants" ["standard" "compact"]
  sizeVariants
  lib.checkListOfEnum "${pname}: tweaks" ["nord" "black" "dracula" "gruvbox" "float" "outline" "normal"]
  tweaks
  stdenvNoCC.mkDerivation rec {
    inherit pname;
    version = "2024.12.18";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = pname;
      rev = version;
      hash = "sha256-a2f707e890770343789746d6e8d8bc7539e0f2ec";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    buildInputs = [
      gnome-themes-extra
    ];

    propagatedUserEnvPkgs = [
      gtk-engine-murrine
    ];

    postPatch = ''
      patchShebangs install.sh
    '';

    installPhase = ''
      runHook preInstall

      name= HOME="$TMPDIR" ./install.sh \
        ${lib.optionalString (themeVariants != []) "--theme " + builtins.toString themeVariants} \
        ${lib.optionalString (colorVariants != []) "--color " + builtins.toString colorVariants} \
        ${lib.optionalString (sizeVariants != []) "--size " + builtins.toString sizeVariants} \
        ${lib.optionalString (tweaks != []) "--tweaks " + builtins.toString tweaks} \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    passthru.updateScript = gitUpdater {};

    meta = with lib; {
      description = "A modern, rounded Gtk theme.";
      homepage = "https://github.com/vinceliuice/Magnetic-gtk-theme";
      license = licenses.gpl3Only;
      platforms = platforms.unix;
      maintainers = ["Thomas Leon Highbaugh"];
    };
  }
