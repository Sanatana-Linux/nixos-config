{pkgs, ...}: {
  # the thunar file manager
  # we enable thunar here and add plugins instead of in systemPackages
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      # packages necessery for thunar thumbnails
      tumbler
      libgsf # odf files
      ffmpegthumbnailer
      kdePackages.ark # GUI archiver for thunar archive plugin
      file-roller # GUI archiver for thunar archive plugin
      xarchiver # GUI archiver
    ];
  };

  # Mount, trash, and other functionalities
  services.gvfs.enable = true;

  # thumbnail support on thunar
  services.tumbler.enable = true;
}
