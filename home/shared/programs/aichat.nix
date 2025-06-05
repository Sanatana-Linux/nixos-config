{pkgs, ...}: {
  home.packages = with pkgs; [
    aichat
    ollama-cuda
  ];

  imports = [
    ./aichat/config.nix
    ./aichat/roles.nix
  ];
}
