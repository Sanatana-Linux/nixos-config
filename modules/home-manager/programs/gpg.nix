{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.programs.gpg.enable = mkEnableOption "GNU Privacy Guard with agent";

  config = mkIf config.modules.programs.gpg.enable {
    programs.gpg.enable = true;
    programs.gpg.package = pkgs.gnupg;
    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableExtraSocket = true;
        pinentry.package = pkgs.pinentry-tty;
        enableZshIntegration = true;
        enableBashIntegration = true;
        extraConfig = ''
          allow-loopback-pinentry
          allow-preset-passphrase
        '';
      };
    };
  };
}
