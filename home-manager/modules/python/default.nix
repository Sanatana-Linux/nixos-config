{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.programs.python;

  my-python-packages = python-packages:
    with python-packages; [
      ipykernel
      jupyter
      ipython
      matplotlib
      numpy
      pandas
      plotly
      requests
      scipy
      #tensorflow-build
      #tensorboard
      jinja2
      pip
      pygobject3
      pynvim
      python-dotenv
      setuptoolsBuildHook
      wheelUnpackHook
      youtube-transcript-api
    ];

  python-with-packages = pkgs.python311.withPackages my-python-packages;
in {
  options.tlh.programs.python.enable = mkEnableOption "install python3 with libs";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [python-with-packages];
  };
}
