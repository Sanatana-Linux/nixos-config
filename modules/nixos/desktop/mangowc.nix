{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.mangowc = {
    enable = mkEnableOption "MangoWC Wayland compositor";
  };

  config = mkIf config.modules.desktop.mangowc.enable {
    # programs.mangowc.enable = true;
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd mangowc";
        user = "greeter";
      };
    };
  };
}
