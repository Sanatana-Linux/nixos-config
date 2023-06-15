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
    ../shared/optional/programs/firefox.nix
    ../shared/optional/programs/mpd.nix
    ../shared/optional/programs/mpv.nix
    ../shared/optional/programs/obs-studio.nix
    ../shared/optional/programs/vscode.nix
    ../shared/optional/programs/neovim/default.nix
    ../shared/optional/programs/kitty/default.nix
    ../shared/optional/programs/zathura/default.nix
  ];
}
