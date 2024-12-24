{pkgs ? import <nixpkgs> {}}: {
  phocus = pkgs.callPackage ./phocus {};
  material-symbols = pkgs.callPackage ./material-symbols {};
  lutgen = pkgs.callPackage ./lutgen {};
  android-messages = pkgs.callPackage ./android-messages {};
  dbus-proxy = pkgs.callPackage ./luajit/dbus-proxy {};
  async-lua = pkgs.callPackage ./luajit/async-lua {};
  lgi-async-extra = pkgs.callPackage ./luajit/lgi-async-extra {};
  magnetic-gtk-theme = pkgs.callPackage ./magnetic-gtk-theme {};
  llm-ollama = pkgs.callPackage ./llm-ollama {};
}
