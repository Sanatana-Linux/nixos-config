{
  pkgs,
  config,
  ...
}: let
  common = import ./common.nix {pkgs = pkgs;};
  core = import ./core.nix {pkgs = pkgs;};
  cliutils = import ./cliutils.nix {pkgs = pkgs;};
  guiutils = import ./guiutils.nix {pkgs = pkgs;};
  media = import ./media.nix {pkgs = pkgs;};
  pythonpackages = import ./python.nix {pkgs = pkgs;};
  developmentpackages = import ./development.nix {pkgs = pkgs;};
  soundpackages = import ./sound.nix {pkgs = pkgs;};
  virtualizationpackages = import ./virtualization.nix {pkgs = pkgs;};
in {
  imports = [./fonts.nix];
  environment.systemPackages = with pkgs;
    [
      figlet
      toilet
      pfetch
    ]
    ++ common
    ++ core
    ++ cliutils
    ++ guiutils
    ++ media
    ++ pythonpackages
    ++ developmentpackages
    ++ virtualizationpackages
    ++ soundpackages;
}
