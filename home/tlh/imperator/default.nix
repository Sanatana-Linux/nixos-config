{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Specific configuration
    ./desktop
    ./services
    ./X

    # Shared configuration
    ../shared
    ../shared/configuration/programs/firefox.nix
    ../shared/configuration/programs/yazi.nix
    #   ../shared/configuration/programs/joshuto.nix
    ../shared/configuration/programs/ranger/default.nix
    #    ../shared/configuration/programs/obs-studio.nix
    ../shared/configuration/programs/vscode.nix
    ../shared/configuration/programs/neovim/default.nix
    ../shared/configuration/programs/kitty/default.nix
    ../shared/configuration/programs/zathura/default.nix
  ];
}
