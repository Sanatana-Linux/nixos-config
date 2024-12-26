{
  pkgs,
  config,
  ...
}: let
  ai = import ../shared/pkgs/ai.nix {inherit pkgs;};
  archives = import ../shared/pkgs/archives.nix {inherit pkgs;};
  android = import ../shared/pkgs/android.nix {inherit pkgs;};
  cliutils = import ../shared/pkgs/cliutils.nix {inherit pkgs;};
  common = import ../shared/pkgs/common.nix {inherit pkgs;};
  core = import ../shared/pkgs/core.nix {inherit pkgs;};
  development = import ../shared/pkgs/development.nix {inherit pkgs;};
  guiutils = import ../shared/pkgs/guiutils.nix {inherit pkgs;};
  media = import ../shared/pkgs/media.nix {inherit pkgs;};
  pentesting = import ../shared/pkgs/pentesting.nix {inherit pkgs;};
  pythonpackages = import ../shared/pkgs/python.nix {inherit pkgs;};
  sound = import ../shared/pkgs/sound.nix {inherit pkgs;};
  virtualization = import ../shared/pkgs/virtualization.nix {inherit pkgs;};
in {
  imports = [../shared/pkgs/fonts.nix];
  environment.systemPackages = with pkgs;
    [
      figlet
      toilet
    ]
    #    ++ ai
    ++ android
    ++ archives
    ++ cliutils
    ++ common
    ++ core
    ++ development
    ++ guiutils
    ++ media
    ++ pentesting
    ++ pythonpackages
    ++ sound
    ++ virtualization;
}
