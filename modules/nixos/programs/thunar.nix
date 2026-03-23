{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.thunar;
in {
  options.modules.programs.thunar = {
    enable = mkEnableOption "Thunar file manager with plugins and dependencies";
  };

  config = mkIf cfg.enable {
    # Enable Thunar with plugins
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };

    environment.systemPackages = with pkgs; [
      # Packages necessary for thunar thumbnails
      tumbler
      libgsf # odf files
      ffmpegthumbnailer
      kdePackages.ark # GUI archiver for thunar archive plugin
      file-roller # GUI archiver for thunar archive plugin
      xarchiver # GUI archiver
    ];

    # Mount, trash, and other functionalities
    services.gvfs.enable = true;

    # Thumbnail support on thunar
    services.tumbler.enable = true;
  };
}
