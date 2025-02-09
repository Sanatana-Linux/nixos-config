{pkgs, ...}:
with pkgs;
  [
    (python313.withPackages (p:
      with p; [
        GitPython
        PyICU
        beautifulsoup4
        brotlicffi
        brotlipy
        gitdb
        googleapis-common-protos
        levenshtein
        mdformat
        numpy
        pip
        pip-tools
        pipx
        protobuf
        pydantic
        pygobject3
        pylev
        pylint
        pylint-venv
        pylsp-mypy
        python-dotenv
        pyxdg
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
