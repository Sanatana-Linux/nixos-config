{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.security.sudo;
in {
  options.modules.security.sudo = {
    enable = mkEnableOption "sudo with kernel network hardening";
  };

  config = mkIf cfg.enable {
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
      extraConfig = ''
        # clear warning in sudo lectures after each reboot.
        Defaults lecture = never
         # password input feedback - makes typed password visible as asterisks.
        Defaults pwfeedback # WARNING: where the buffer overload vulnerability comes from
        # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
        Defaults env_keep+=SSH_AUTH_SOCK
      '';
    };
  };
}
