{pkgs, ...}:
with pkgs;
  [
    (python312.withPackages (p:
      with p; [
        GitPython
        PyICU
        pydantic
        pydantic-core
        beautifulsoup4
        brotlicffi
        python-lsp-server
        flake8
        brotlipy
        gitdb
        googleapis-common-protos
        levenshtein
        mdformat
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
