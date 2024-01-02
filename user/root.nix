{
  lib,
  pkgs,
  config,
  
  ...
}:
with lib; let
  cfg = config.tlh.user.root;
in {
  options.tlh.user.root = {
    enable = mkEnableOption "activate user root";
    # Option for now present because some obscure reference ist still in the  configuration lel
    mayniklas = mkEnableOption "activate user mayniklas";
  };

  config = mkIf cfg.enable {
    users.users.root = {
      openssh.authorizedKeys = {keyFiles = [];};
    };
    nix.settings.allowed-users = ["root"];
  };
}
