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
brotlipy
brotlicffi
PyICU
googleapis-common-protos
mdformat
pip-tools
pipx
protobuf
pylsp-mypy
websockets
wheel
sortedcontainers
pynvim


      ]))
  ]
  ++ [
    gobject-introspection
    pipenv
    ruff
    virtualenv
    virtualenv-clone
  ]
