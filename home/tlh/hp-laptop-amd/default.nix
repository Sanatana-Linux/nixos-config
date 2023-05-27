{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Shared configuration
    ../shared
    ../shared/optional/programs/alacritty.nix
    ../shared/optional/programs/firefox.nix
    ../shared/optional/programs/mpd.nix
    ../shared/optional/programs/mpv.nix
    ../shared/optional/programs/obs-studio.nix
    ../shared/optional/programs/vscode.nix
    ../shared/optional/programs/neovim.nix

    # Specific configuration
    ./desktop
    ./services
    ./X
  ];
}
