{
  pkgs,
  config,
  ...
}: let
  archives = import ./archives.nix {pkgs = pkgs;};
  android = import ./android.nix {pkgs = pkgs;};
  cliutils = import ./cliutils.nix {pkgs = pkgs;};
  common = import ./common.nix {pkgs = pkgs;};
  core = import ./core.nix {pkgs = pkgs;};
  development = import ./development.nix {pkgs = pkgs;};
  guiutils = import ./guiutils.nix {pkgs = pkgs;};
  media = import ./media.nix {pkgs = pkgs;};
  pentesting = import ./pentesting.nix {pkgs = pkgs;};
  pythonpackages = import ./python.nix {pkgs = pkgs;};
  sound = import ./sound.nix {pkgs = pkgs;};
  virtualization = import ./virtualization.nix {pkgs = pkgs;};
in {
  imports = [./fonts.nix];
  environment.systemPackages = with pkgs;
    [
      figlet
      toilet
      pfetch
    ]
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
