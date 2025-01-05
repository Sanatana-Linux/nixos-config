{
  lib,
  isDarwin,
  isLinux,
  ...
}: {
  environment.systemPackages = with pkgs; [
    podman-tui
    pods
    podman
    podman-compose
    fetchit
  ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    enableNvidia = true;
  };
}
