{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.programs.zathura.enable = mkEnableOption "Zathura PDF viewer";

  config = mkIf config.modules.programs.zathura.enable {
    programs.zathura = {
      enable = true;
      options = {
        # Non-color options remain
        render-loading = true;
        scroll-step = 50;
        zoom-min = 10;
        guioptions = "";
      };
    };
  };
}
