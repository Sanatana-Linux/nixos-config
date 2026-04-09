{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.desktop.sddm = {
    enable = mkEnableOption "SDDM Display Manager";

    theme = mkOption {
      type = types.str;
      default = "elegant-sddm";
      description = "SDDM theme to use";
    };

    autoNumlock = mkOption {
      type = types.bool;
      default = true;
      description = "Enable numlock by default on the login screen";
    };

    wayland = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Wayland support for SDDM";
    };
  };

  config = mkIf config.modules.desktop.sddm.enable {
    # Enable SDDM display manager
    services.displayManager.sddm = {
      enable = true;
      theme = config.modules.desktop.sddm.theme;
      autoNumlock = config.modules.desktop.sddm.autoNumlock;
      wayland.enable = config.modules.desktop.sddm.wayland;
    };

    # Install additional SDDM themes
    environment.systemPackages = with pkgs; [
      elegant-sddm  # Custom elegant SDDM theme
    ];

    # SDDM configuration
    environment.etc."sddm.conf.d/10-nixos.conf".text = ''
      [General]
      HaltCommand=/run/current-system/systemd/bin/systemctl poweroff
      RebootCommand=/run/current-system/systemd/bin/systemctl reboot
      
      [Theme]
      Current=${config.modules.desktop.sddm.theme}
      ThemeDir=/run/current-system/sw/share/sddm/themes
      
      [Users]
      MaximumUid=60000
      MinimumUid=1000
    '';

    # Systemd tmpfiles for SDDM directories
    systemd.tmpfiles.rules = [
      "d /var/lib/sddm 0755 sddm sddm -"
    ];
  };
}