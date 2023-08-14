{pkgs, ...}:
with pkgs;
  [
    (python3.withPackages (p:
      with p; [
        pip
        pygobject3
        pynvim
        python-dotenv
        setuptoolsBuildHook
        wheelUnpackHook
        youtube-transcript-api
      ]))
  ]
  ++ [
    gobject-introspection
    pipx
    pipenv
    python311Packages.pynvim
    python311Packages.wheel
  ]
