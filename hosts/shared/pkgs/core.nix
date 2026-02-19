{
  inputs,
  pkgs,
  ...
}:
with pkgs; [
  OVMFFull # UEFI firmware for virtual machines
  age # Modern encryption tool with small explicit keys
  agenix-cli # CLI tool for agenix secrets management
  cbfmt # Code block formatter
  ccls # C/C++ language server
  commons-compress # Apache Commons Compress library
  coreutils-full # GNU core utilities (full version)
  dmg2img # Convert macOS DMG files to IMG format
  dnsutils # DNS utilities (dig, nslookup, etc.)
  espeak-ng # Text-to-speech synthesizer
  fcft # Font loading and glyph rasterization library
  ffmpeg-full # Complete multimedia framework
  font-alias # X11 font alias configuration
  font-util # X11 font utilities
  fontconfig # Font configuration and customization library
  fontforge-fonttools # Font editing tools
  fontforge-gtk # Font editor with GTK interface
  komika-fonts # Komika font collection
  libglibutil # GLib utility library
  minizip-ng # Minizip next generation library
  networkmanager # Network connection manager
  ngrok # Secure tunneling to localhost
  nmap # Network exploration and security scanning
  papirus-folders # Folder color customization for Papirus icon theme
  poppler_gi # GObject introspection bindings for Poppler (PDF rendering)
  pulseaudio # Sound server
  python312Packages.compreffor # Python CFF table subroutinizer
  python312Packages.fonttools # Library for manipulating fonts
  service-wrapper # Wrapper for running services
  sops # Editor of encrypted files
  sox # Sound processing tool
  ssh-to-age # Convert SSH keys to age keys
  sssd # System Security Services Daemon
  tealdeer # Fast tldr client in Rust
  uutils-coreutils # Cross-platform Rust rewrite of GNU coreutils
  webfontkitgenerator # Web font kit generator
]
