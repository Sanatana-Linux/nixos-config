{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    user = "ollama";
    group = "ollama";
  };
}
