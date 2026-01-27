{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  afuse # Automount filesystem using FUSE
  aichat # AI-powered chat CLI
  appstream # Software component metadata
  appstream-glib # Library for reading and writing AppStream metadata
  as-tree # Print directory structure as a tree
  automake # GNU automatic makefile generator
  avfs # Virtual filesystem for transparent archive access
  beep # Make the PC speaker beep
  bintools # Collection of binary utilities
  brightnessctl # Control device brightness
  cdrtools # CD/DVD/BluRay command-line recording software
  comma # Run programs without installing them
  csv2latex # Convert CSV files to LaTeX tables
  curtail # Image compression application
  dbus-broker # D-Bus message broker
  dconf # GNOME configuration system
  ddcui # Graphical UI for ddcutil
  ddcutil # Query and change monitor settings
  deer # File navigator for zsh
  didyoumean # Command-line spell checker
  dosfstools # Utilities for FAT filesystems
  edk2 # UEFI firmware development kit
  edk2-uefi-shell # UEFI Shell for EDK2
  efibootmgr # Modify UEFI boot entries
  eggdbus # D-Bus bindings for GObject (deprecated)
  exfatprogs # exFAT filesystem utilities
  fd # Simple, fast alternative to find
  gh # GitHub CLI
  ghostscript # PostScript and PDF interpreter
  glib # Core application building blocks library
  glibc # GNU C Library
  gnome-keyring # GNOME password and secrets manager
  htop # Interactive process viewer
  intel-graphics-compiler # Intel graphics shader compiler
  jdupes # Duplicate file finder
  jq # Command-line JSON processor
  kconfig-frontends # Configuration interfaces for Linux kernel
  keyutils # Linux key management utilities
  kmsxx # C++ library for kernel mode setting
  lame # MP3 encoder
  latex2html # Convert LaTeX documents to HTML
  latexrun # Wrapper for LaTeX compilers
  lazyjournal # Simple journaling application
  libgnome-keyring # Library for GNOME Keyring integration
  libisoburn # ISO image manipulation library
  lm_sensors # Hardware health monitoring
  lshw # Hardware lister
  massren # Easily rename multiple files
  mdds # Multi-dimensional data structure library
  meli # Terminal email client
  meson # Fast build system
  microcode-intel # Intel CPU microcode updates
  moor # File organization tool
  moreutils # Additional Unix utilities
  mtools # Access MS-DOS disks without mounting
  neofetch # System information tool
  nmon # Performance monitoring tool
  ntfs3g # NTFS filesystem driver with read-write support
  ntfsprogs # NTFS filesystem utilities
  openssl # Cryptography and SSL/TLS toolkit
  out-of-tree # Kernel module development tool
  parallel # Execute jobs in parallel
  patchelf # Modify existing ELF executables and libraries
  pcre # Perl Compatible Regular Expressions library
  pcre-cpp # PCRE C++ bindings
  pcre2 # Perl Compatible Regular Expressions library (version 2)
  pfetch # Minimal system information tool
  pinentry-tty # PIN entry dialog for TTY
  pmutils # Power management utilities
  polkit_gnome # GNOME authentication agent for PolicyKit
  portaudio # Cross-platform audio I/O library
  premake # Build configuration tool
  procps # Process monitoring utilities
  ps_mem # Memory usage per-program analyzer
  python312Packages.py-dmidecode # Python DMI/SMBIOS decoder
  rcshist # RCS history file manager
  ripgrep-all # Search tool combining ripgrep with various file parsers
  rnr # Bulk file renamer
  sdbus-cpp # C++ bindings for systemd D-Bus
  shared-mime-info # Shared MIME database
  shellify # Convert shell history to shell scripts
  silver-searcher # Code searching tool similar to ack
  simpleTpmPk11 # Simple TPM PKCS#11 module
  slop # Select screen region and print to stdout
  smartmontools # Control and monitor SMART enabled hard drives
  snappy # Fast compression/decompression library
  sysctl # Configure kernel parameters at runtime
  sysfsutils # Utilities for querying sysfs
  sysprof # System-wide profiler
  sysstat # System performance tools
  systeroid # Sysctl explorer
  sysvtools # System V init tools
  sysz # Fuzzy systemctl wrapper
  template-glib # Library for template expansion with GLib
  testdisk # Data recovery software
  trash-cli # Command-line interface to freedesktop.org trash
  tumbler # D-Bus thumbnail service
  ucl # Portable lossless data compression library
  unscd # Micro Name Service Caching Daemon
  usbmuxd # USB multiplexing daemon for iOS devices
  util-linux # System utilities for Linux
  vgrep # User-friendly pager for grep
  vimv # Batch-rename files using Vim
  wget # Network downloader
  wineWow64Packages.full # Windows compatibility layer (64-bit with 32-bit support)
  wmctrl # Command-line tool to interact with X window managers
  wmic-bin # Windows Management Instrumentation CLI
  wmutils-core # Core window manipulation utilities
  wmutils-libwm # Window manager utilities library
  wmutils-opt # Optional window manipulation utilities
  xclip # Command-line interface to X selections
  xdg-dbus-proxy # Filtering proxy for D-Bus connections
  xdg-desktop-portal-gtk # GTK backend for xdg-desktop-portal
  xdg-user-dirs # Tool to manage user directories
  xdg-utils # Desktop integration utilities
  xfontsel # X11 font selector
  xgeometry-select # Select screen geometry
  xorg.fontalias # X11 font alias definitions
  xorg.fonttosfnt # X11 font converter
  xorg.fontutil # X11 font utilities
  xorg.libxcb # X protocol C-language binding
  xorg.mkfontdir # Create fonts.dir files
  xorg.xbacklight # Adjust backlight brightness using RandR
  xorg.xcbutil # XCB utility functions library
  xorg.xcbutilerrors # XCB errors library
  xorg.xcbutilimage # XCB image convenience library
  xorg.xcbutilrenderutil # XCB render utilities
  xorg.xcbutilwm # XCB window manager utilities
  xorg.xconsole # X11 console display
  xorg.xev # X11 event tester
  xorg.xhost # Server access control program for X
  xorg.xinit # X Window System initializer
  xorg.xkill # Kill X11 clients by clicking on windows
  xorg.xorgproto # X11 protocol headers
  xorg.xprop # X11 property displayer
  xorg.xwininfo # X11 window information utility
  xorriso # ISO 9660 and Rock Ridge filesystem manipulator
  xsecurelock # X11 screen locker
  xsettingsd # Daemon for X settings
  xss-lock # Use external locker as X screen saver
  xsuspender # Suspend inactive X11 applications
]
