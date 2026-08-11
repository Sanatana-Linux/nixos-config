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

  # The upstream script uses bash-only case-modifier expansion (VAR^^ / VAR,,)
  # that fails under zsh with 'bad substitution'. Convert them to zsh's
  # (U)VAR / (L)VAR equivalents so completion actually works.
  patches = [
    ./zsh-bashisms.patch
  ];

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
