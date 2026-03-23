{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.programs.editorconfig = {
    enable = mkEnableOption "EditorConfig support with project .editorconfig file";
  };

  config = mkIf config.modules.programs.editorconfig.enable {
    editorconfig.enable = true;
    home.file.".editorconfig".source = ../../../../.editorconfig;
  };
}
