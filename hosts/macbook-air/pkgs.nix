{
  pkgs,
  config,
  ...
}: let
  archives = import ../shared/pkgs/archives.nix {inherit pkgs;};
  cliutils = import ../shared/cliutils.nix {inherit pkgs;};
  common = import ../shared/common.nix {inherit pkgs;};
  core = import ../shared/core.nix {inherit pkgs;};
  guiutils = import ../shared/guiutils.nix {inherit pkgs;};
  media = import ../shared/media.nix {inherit pkgs;};
  pythonpackages = import ../shared/python.nix {inherit pkgs;};
  sound = import ../shared/sound.nix {inherit pkgs;};
in {
  imports = [./fonts.nix];
  environment.systemPackages = with pkgs;
    [
      figlet
      toilet
      pfetch
    ]
    ++ archives
    ++ cliutils
    ++ common
    ++ core
    ++ guiutils
    ++ media
    ++ pythonpackages
    ++ sound;
}
