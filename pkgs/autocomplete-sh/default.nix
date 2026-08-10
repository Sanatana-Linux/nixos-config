{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  zsh,
}:
stdenvNoCC.mkDerivation rec {
  pname = "autocomplete-sh";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "closedLoop-technologies";
    repo = "autocomplete-sh";
    rev = "v${version}";
    hash = "sha256-aUPuTNGAblqxRHAZSuwaYNHVOXrGpop16fzkz5ov0lw=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 autocomplete.zsh $out/bin/autocomplete
    # NixOS has no /bin/zsh — point the shebang at the store zsh
    sed -i "1s|#!/bin/zsh|#!${zsh}/bin/zsh|" $out/bin/autocomplete
    runHook postInstall
  '';

  meta = with lib; {
    description = "LLM-powered command-line autocomplete for zsh";
    homepage = "https://github.com/closedLoop-technologies/autocomplete-sh";
    license = licenses.mit;
    maintainers = with maintainers; [];
    platforms = platforms.all;
  };
}
