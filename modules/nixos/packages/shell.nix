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
    fileManagement = mkEnableOption "File management and navigation tools" // {default = true;};
    downloadTools = mkEnableOption "Download and network utilities" // {default = true;};
    zshPlugins = mkEnableOption "ZSH shell plugins and enhancements" // {default = true;};
    inputSupport = mkEnableOption "Input device and UI support libraries" // {default = true;};
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
        btop # Resource monitor with beautiful interface
        eza # Modern replacement for ls
        fd # Simple, fast alternative to find
        fzf # Command-line fuzzy finder
        fzy # Fast fuzzy text selector
        silver-searcher # Code searching tool (ag)
      ]
      # System utilities
      ++ optionals config.modules.packages.shell.systemUtils [
        beep # System beep command
        clipster # Clipboard manager
        jdupes # Duplicate file finder
        killall # Kill processes by name
        trash-cli # Command-line interface to freedesktop.org trash
      ]
      # File management and navigation
      ++ optionals config.modules.packages.shell.fileManagement [
        deer # File navigator for zsh
        ranger # Console file manager
        tree # Directory tree viewer
        walk # Terminal file manager
      ]
      # Download and network utilities
      ++ optionals config.modules.packages.shell.downloadTools [
        aria2 # Multi-protocol download utility
        rclone # Rsync for cloud storage
        speedtest-cli # Command-line speedtest.net client
      ]
      # ZSH plugins and enhancements
      ++ optionals config.modules.packages.shell.zshPlugins [
        pure-prompt # Pretty, minimal ZSH prompt
        zsh-autocomplete # Real-time type-ahead completion
        zsh-edit # Edit command line in editor
        zsh-navigation-tools # Curses-based tools for ZSH
        zsh-you-should-use # Remind you of aliases
      ]
      # Input and UI support
      ++ optionals config.modules.packages.shell.inputSupport [
        libdbusmenu # Library for passing menus over DBus
        libdbusmenu-gtk3 # GTK3 implementation of DBus menu specification
        libinput # Library for handling input devices
      ];
  };
}
