{pkgs, ...}:
with pkgs;
  [
    (python312.withPackages (p:
      with p; [
        GitPython
        PyICU
        pylatexenc
        pylatex
        pydantic
        meson
        meson-python
        typecode-libmagic
        pydantic-core
        beautifulsoup4
        brotlicffi
        python-lsp-server
        flake8
        brotlipy
        gitdb
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
        pycairo
        pygobject3
        cairocffi
      ]))
  ]
  ++ [
    gobject-introspection
    pylint
    pipenv
    black
    ruff
    streamlit
    virtualenv
    virtualenv-clone
  ]
