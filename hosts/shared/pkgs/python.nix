{ pkgs, ... }:
with pkgs;
[
  (python3.withPackages (p:
    with p; [
      pip
      pygobject3
      pynvim
      pylint
      pylint-venv
      venvShellHook
      python-dotenv
      setuptoolsBuildHook
      beautifulsoup4
      wheelUnpackHook
      youtube-transcript-api
    ]))
]
++ [
  gobject-introspection
  virtualenv
  pew
  ruff
  virtualenv-clone
  pipx
  pipenv
  python311Packages.pynvim
  python311Packages.sortedcontainers
  python311Packages.wheel
]
