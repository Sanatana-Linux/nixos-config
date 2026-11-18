{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.system.security.polkit;
in {
  options.modules.system.security.polkit = {
    enable = mkEnableOption "polkit rules that let the wheel group mount filesystems without authentication";
  };

  config = mkIf cfg.enable {
    # udisks2 asks polkit before it mounts anything and the default policy prompts
    # for the caller's password. Every member of wheel can already become root
    # through doas/sudo, so the prompt adds no isolation — it just turns mounting
    # a removable disk into an interruption. Allow it outright: the group is the
    # boundary, not the password.
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount" ||
             action.id == "org.freedesktop.udisks2.filesystem-mount-system") &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
