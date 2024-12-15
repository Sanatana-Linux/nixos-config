{pkgs, ...}:
with pkgs;
  [
    (python312.withPackages (p:
      with p; [
        GitPython
        beautifulsoup4
        gitdb
        levenshtein
        pip
        pygobject3
        pylev
        pylint
        pylint-venv
        python-dotenv
        setuptoolsBuildHook
        smmap
        venvShellHook
        wheelUnpackHook
        youtube-transcript-api
      ]))
  ]
  ++ [
    gobject-introspection
    pipenv
    python311Packages.sortedcontainers
    python311Packages.wheel
    python312Packages.pynvim
    ruff
    virtualenv
    virtualenv-clone
  ]
