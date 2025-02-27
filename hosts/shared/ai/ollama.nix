{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    user = "ollama";
    group = "ollama";

    acceleration = "cuda"; # since I am having issues and it is ollama-cuda already let's see
  };
}
