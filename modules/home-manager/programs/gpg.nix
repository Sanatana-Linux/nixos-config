{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.gpg;
in {
  options.modules.programs.gpg = {
    enable = mkEnableOption "GNU Privacy Guard with agent";

    enableSshSupport = mkOption {
      type = types.bool;
      default = false;
      description = "Enable SSH agent support via gpg-agent (disabled by default to avoid systemd ordering cycle with set-SSH_AUTH_SOCK.service)";
    };
  };

  config = mkIf cfg.enable {
    programs.gpg.enable = true;
    programs.gpg.package = pkgs.gnupg;
    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = cfg.enableSshSupport;
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
