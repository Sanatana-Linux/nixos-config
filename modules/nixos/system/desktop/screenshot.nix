{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.desktop.screenshot;
  toolPkg = pkgs.${cfg.tool};
  screenshotCmd =
    if cfg.tool == "xfce4-screenshooter"
    then "${toolPkg}/bin/xfce4-screenshooter"
    else "${toolPkg}/bin/${cfg.tool}";
in {
  options.modules.system.desktop.screenshot = {
    enable = mkEnableOption "Screenshot utility with PrintScreen keybinding";

    tool = mkOption {
      type = types.enum ["xfce4-screenshooter" "flameshot"];
      default = "xfce4-screenshooter";
      description = "Screenshot tool to install and bind to PrintScreen";
    };

    keybindings = mkOption {
      type = types.attrsOf types.str;
      default = {
        Print = "${screenshotCmd} -f";
        "<Primary>Print" = "${screenshotCmd} -r";
        "<Alt>Print" = "${screenshotCmd} -w";
      };
      defaultText = literalExpression ''
        {
          Print = "''${screenshotCmd} -f";
          "<Primary>Print" = "''${screenshotCmd} -r";
          "<Alt>Print" = "''${screenshotCmd} -w";
        }
      '';
      description = "Keybinding entries for the XFCE keyboard shortcuts custom commands";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [toolPkg];

    # XFCE-specific: bind PrintScreen keys via xfconf
    services.xserver.displayManager.sessionCommands = mkIf config.modules.system.desktop.xfce.enable (
      concatStringsSep "\n" (
        mapAttrsToList (keybinding: cmd: ''
          ${pkgs.xfce.xfconf}/bin/xfconf-query \
            -c xfce4-keyboard-shortcuts \
            -p /commands/custom/${keybinding} \
            -s "${cmd}" \
            --create -t string 2>/dev/null || true
        '')
        cfg.keybindings
      )
    );
  };
}
