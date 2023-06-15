{pkgs, ...}:
with pkgs;
  [
    (python3.withPackages (p:
      with p; [
        huggingface-hub
        ipykernel
        ipython
        jupyter
        notebook
        numpy
        pip
        pygobject3
        pynvim
        python
        python-dotenv
        setuptoolsBuildHook
        wheelUnpackHook
        youtube-transcript-api
      ]))
  ]
  ++ [
    gobject-introspection
    python311
    pipx
    pipenv
  ]
