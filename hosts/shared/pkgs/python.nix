{pkgs, ...}:
with pkgs;
  [
    (python311.withPackages (p:
      with p; [
        gitdb
        GitPython
        pip
        pygobject3
        pynvim
        pylint
        pylint-venv
        venvShellHook
        python-dotenv
        smmap
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
    pipenv
    python312Packages.pynvim
    python311Packages.sortedcontainers
    python311Packages.wheel
  ]
