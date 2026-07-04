{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.packages.core;
in {
  options.modules.base.packages.core = {
    enable = mkEnableOption "Core system utilities";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # System & Performance
      coreutils-full # GNU core utilities (full)
      uutils-coreutils # Rust coreutils reimplementation
      OVMFFull # Full UEFI firmware for VMs
      service-wrapper # systemd service wrapper
      sssd # System Security Services Daemon

      # Secrets & Encryption
      age # Modern encryption tool
      agenix-cli # Age-encrypted secrets CLI
      sops # Secrets management
      ssh-to-age # Convert SSH keys to age
      ente-auth # 2FA Secrets

      # Network Utilities
      networkmanager # Network connection manager
      dnsutils # DNS diagnostic tools (dig, nslookup)
      nmap # Network security scanner
      ngrok # Tunnel localhost to public URL

      # Font & Text Infrastructure
      fontconfig # Font configuration library
      font-util # X11 font utilities
      font-alias # X11 font alias files
      fcft # Font loading library
      fontforge-gtk # Font editor (GTK version)
      fontforge-fonttools # Python font manipulation
      python314Packages.fonttools # Font manipulation library
      python314Packages.compreffor # Font compression
      webfontkitgenerator # Web font kit generator

      # Multimedia & Sound
      poppler_gi # PDF rendering library (GObject)
      sox # Sound eXchange audio tool
      espeak-ng # Text-to-speech synthesizer
      pulseaudio # Sound server

      # Appearance & Themes
      gnome-themes-extra # Additional GNOME themes
      papirus-folders # Papirus icon folder colors

      # Misc Utilities
      opencode
      tealdeer # tldr pages in Rust
      dmg2img # Convert DMG to IMG
      cbfmt # Clipboard formatter
      ccls # C/C++ language server
      commons-compress # Apache compression library
      libapparmor # AppArmor security library
      libglibutil # GLib utilities
      sillytavern
    ];
  };
}
