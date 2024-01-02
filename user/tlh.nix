{
  lib,
  pkgs,
  config,
  
  ...
}:
with lib; let
  cfg = config.tlh.user.tlh;
in {
  options.tlh.user.tlh = {enable = mkEnableOption "activate user tlh";};

  config = mkIf cfg.enable {
    users.users.tlh = {
      isNormalUser = true;
      home = "/home/tlh";
      extraGroups = ["wheel" "libvirtd"];
      shell = pkgs.zsh;
      #   openssh.authorizedKeys.keyFiles = [];
    };
    users.extraUsers.tlh.extraGroups = mkIf config.virtualisation.docker.enable ["docker"];
    nix.settings.allowed-users = ["tlh"];
  };
}
