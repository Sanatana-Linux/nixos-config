{pkgs, ...}:
with pkgs;
  [
    (python3.withPackages (p:
      with p; [
        pygobject3
        huggingface-hub
        ipykernel
        ipython
        jupyter
        notebook
        numpy
        pip
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
