{pkgs, ...}: {
  virtualisation = {
    waydroid = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    weston
    cage # Minimal Wayland compositor for nested sessions
    waydroid-helper

    # Script to easily launch waydroid in a nested wayland session
    (pkgs.writeScriptBin "waydroid-session" ''
      #!${pkgs.bash}/bin/bash
      # Launch waydroid in a nested Wayland compositor (cage)
      # This allows waydroid to work on X11 systems

      echo "============================================"
      echo "  Waydroid Launcher for X11 Systems"
      echo "============================================"
      echo ""
      echo "This script launches Waydroid in a nested Wayland session"
      echo "using Cage compositor, allowing it to work on X11."
      echo ""

      # Check if waydroid container is running
      if ! systemctl is-active --quiet waydroid-container.service; then
        echo "⚠ Waydroid container is not running."
        echo "Starting waydroid container service..."
        sudo systemctl start waydroid-container.service
        echo "Waiting for container to initialize..."
        sleep 3
      else
        echo "✓ Waydroid container is already running."
      fi

      # Check if waydroid is initialized
      if [ ! -f /var/lib/waydroid/waydroid.cfg ]; then
        echo ""
        echo "⚠ Waydroid not initialized. Please run:"
        echo "   sudo waydroid init"
        echo "   or for Google Apps support:"
        echo "   sudo waydroid init -s GAPPS"
        exit 1
      fi

      echo ""
      echo "Starting Waydroid in Cage compositor..."
      echo "Press Super+Shift+E to exit, or close the window."
      echo ""

      # Start cage with waydroid
      ${pkgs.cage}/bin/cage -- ${pkgs.waydroid}/bin/waydroid show-full-ui
    '')

    # Wrapper for waydroid app launch in nested session
    (pkgs.writeScriptBin "waydroid-app" ''
      #!${pkgs.bash}/bin/bash
      # Launch a specific waydroid app in cage

      if [ -z "$1" ]; then
        echo "Usage: waydroid-app <package-name>"
        echo "Example: waydroid-app com.android.settings"
        echo ""
        echo "To list installed apps, run: waydroid app list"
        exit 1
      fi

      if ! systemctl is-active --quiet waydroid-container.service; then
        echo "Starting waydroid container..."
        sudo systemctl start waydroid-container.service
        sleep 3
      fi

      ${pkgs.cage}/bin/cage -- ${pkgs.waydroid}/bin/waydroid app launch "$1"
    '')
  ];

  # User groups for waydroid access
  users.groups.waydroid = {};
}
