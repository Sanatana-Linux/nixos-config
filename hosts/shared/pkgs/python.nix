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
    python310Packages.openai
    python310Packages.pandas
    python311Packages.aenum
    python311Packages.pynvim
    python311Packages.asyncstdlib
    python311Packages.installer
    python311Packages.numpy
    python311Packages.pynvim
    python311Packages.wheel
  ]
