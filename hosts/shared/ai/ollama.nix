{pkgs, ...}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;

    user = "ollama";
    group = "ollama";

    home = "/var/lib/ollama";
    models = "/var/lib/ollama/models";

    #  loadModels = [
    #    "llama3.2:3b"
    #    "granite3-dense:8b"
    #  ];
    #  acceleration = "cuda";  # since I am having issues and it is ollama-cuda already let's see
  };

  services.nextjs-ollama-llm-ui.enable = true;

  fileSystems."/var/lib/ollama/models" = {
    device = "/var/lib/ollama/models";
    options = [
      "bind"
      "persist"
    ];
  };
}
