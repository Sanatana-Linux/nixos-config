{pkgs, ...}: {
  services.llama-cpp = {
    enable = true;
    port = 8889;
  };
}
