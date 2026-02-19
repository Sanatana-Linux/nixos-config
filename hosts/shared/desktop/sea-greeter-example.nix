# Example sea-greeter configuration
# To use: Import this file in your host config and disable the gtk greeter
{pkgs, ...}: {
  services.xserver.displayManager.lightdm = {
    enable = true;

    # Disable the gtk greeter
    greeters.gtk.enable = false;

    # Enable sea-greeter
    greeters.sea = {
      enable = true;

      # Theme configuration
      theme = {
        name = "gruvbox"; # or any other theme you install
        # package = null; # Set this if you package a custom theme
      };

      # Visual configuration
      background = "/etc/nixos/hosts/shared/wallpaper/monokaiprospectrum.png";
      logo = ""; # Path to your logo if desired
      userImage = ""; # Default user image

      # Behavior
      debug = false;
      detectThemeErrors = true;
      screensaverTimeout = 300;
      secureMode = true;
      timeLanguage = ""; # Empty for system default

      # Additional custom configuration
      extraConfig = ''
        # Add any extra sea-greeter.conf options here
        # See: https://github.com/JezerM/sea-greeter
      '';
    };
  };
}
