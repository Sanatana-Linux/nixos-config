{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.packages.shell = {
    enable = mkEnableOption "Shell utilities and CLI tools";

    modernTools = mkEnableOption "Modern replacements for traditional CLI tools" // {default = true;};
    systemUtils = mkEnableOption "System utilities and process management" // {default = true;};
    inputSupport = mkEnableOption "Input device and UI support libraries" // {default = true;};
    fileManagement = mkEnableOption "File management and navigation tools" // {default = true;};
  };

  config = mkIf config.modules.packages.shell.enable {
    environment.systemPackages = with pkgs;
      []
      # Core shell completion
      ++ [
        bash-completion
        curl
      ]
      # Modern CLI replacements
      ++ optionals config.modules.packages.shell.modernTools [
        bat # Cat clone with syntax highlighting
        eza # Modern replacement for ls
        fd # Simple, fast alternative to find
        fzf # Command-line fuzzy finder
        fzy # Fast fuzzy text selector
      ]
      # System utilities
      ++ optionals config.modules.packages.shell.systemUtils [
        killall # Kill processes by name
        trash-cli # Command-line interface to freedesktop.org trash
      ]
      # Input and UI support
      ++ optionals config.modules.packages.shell.inputSupport [
        libdbusmenu # Library for passing menus over DBus
        libdbusmenu-gtk3 # GTK3 implementation of DBus menu specification
        libinput # Library for handling input devices
      ]
      # File management
      ++ optionals config.modules.packages.shell.fileManagement [
        walk # Terminal file manager
      ];
  };
}
