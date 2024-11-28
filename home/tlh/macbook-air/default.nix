{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.apple-macbook-air-6
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    ../shared/desktop
    ../shared/services
    ../shared/X
    ../shared
    ../shared/programs/firefox.nix
    ../shared/programs/yazi.nix
    #   ../shared/programs/joshuto.nix
    ../shared/programs/ranger/default.nix
    #    ../shared/programs/obs-studio.nix
    ../shared/programs/vscode.nix
    ../shared/programs/neovim/default.nix
    ../shared/programs/kitty/default.nix
    ../shared/programs/zathura/default.nix
  ];
}
