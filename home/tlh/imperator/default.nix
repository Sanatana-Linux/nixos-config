{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.lenovo-legion-16irx9h

    ../shared/desktop/default.nix
    ../shared/services/picom.nix
    ../shared/X/default.nix
    ../shared/default.nix
    ../shared/programs/firefox.nix
    ../shared/programs/yazi.nix
    #   ../shared/programs/joshuto.nix
    ../shared/programs/ranger/default.nix
  ../shared/programs/gpg/default.nix
    ../shared/programs/vscode.nix
    ../shared/programs/neovim/default.nix
    ../shared/programs/kitty/default.nix
    ../shared/programs/zathura/default.nix
  ];
}
