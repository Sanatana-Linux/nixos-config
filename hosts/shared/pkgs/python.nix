{pkgs, ...}:
with pkgs;
  [
    (python312.withPackages (p:
      with p; [
        beautifulsoup4
        brotlicffi
        brotlipy
        gitdb
        pyxdg
        GitPython
        googleapis-common-protos
        levenshtein
        mdformat
        numpy
        pip
        pip-tools
        pipx
        protobuf
        pygobject3
        PyICU
        pylev
        pylint
        pylint-venv
        pylsp-mypy
        python-dotenv
        setuptoolsBuildHook
        smmap
        sortedcontainers
        venvShellHook
        websockets
        wheel
        wheelUnpackHook
        youtube-transcript-api
      ]))
  ]
  ++ [
    gobject-introspection
    pipenv
    black
    ruff
    virtualenv
    virtualenv-clone
  ]
