{
  pkgs,
  inputs,
  config,
  ...
}: let
  core = import ../shared/pkgs/core.nix {inherit pkgs inputs;};
  devtools = import ../shared/pkgs/devtools.nix {inherit pkgs;};
  gui = import ../shared/pkgs/gui.nix {inherit pkgs;};
  guilibs = import ../shared/pkgs/guilibs.nix {inherit pkgs;};
  image = import ../shared/pkgs/image.nix {inherit pkgs;};
  network = import ../shared/pkgs/network.nix {inherit pkgs;};
  pythonpackages = import ../shared/pkgs/python.nix {inherit pkgs;};
  shellutils = import ../shared/pkgs/shellutils.nix {inherit pkgs;};
  system = import ../shared/pkgs/system.nix {inherit pkgs;};
  video = import ../shared/pkgs/video.nix {inherit pkgs;};
in {
  imports = [../shared/pkgs/fonts.nix];
  environment.systemPackages = with pkgs;
    [
      pfetch
    ]
    ++ core
    ++ gui
    ++ guilibs
    ++ image
    ++ network
    ++ pythonpackages
    ++ system
    ++ video;
}
