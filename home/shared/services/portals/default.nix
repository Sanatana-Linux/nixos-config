{pkgs, ...}: {
  home.file.".config/xdg-desktop-portal/portals.conf".text = ''
    [preferred]
    default=luajit;gtk;
    org.freedesktop.impl.portal.FileChooser=thunar;
  '';
}
