{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.virtualization.waydroid;
in {
  options.modules.system.virtualization.waydroid = {
    enable = mkEnableOption "Android apps with Waydroid";

    users = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Users to add to the waydroid group";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      # Enable the upstream NixOS waydroid module
      waydroid = {
        enable = true;
      };
      # Waydroid requires LXC for the Android container
      lxc.enable = true;
    };

    # Required kernel modules for Waydroid networking
    boot.kernelModules = [
      "nf_tables"
      "nf_conntrack"
      "nf_nat"
      "xt_MASQUERADE"
      "xt_conntrack"
      "bridge"
      "br_netfilter"
    ];

    # Enable iptables-nft compatibility
    networking.nftables.enable = true;

    environment.systemPackages = with pkgs; [
      weston # Fallback Wayland compositor for nested sessions
      cage # Minimal Wayland compositor for nested sessions
      waydroid-helper # Extra Waydroid utilities
      iptables # iptables-nft compatibility layer
      wireplumber # Session manager for Waydroid audio

      # Launch waydroid in a nested Cage compositor (Intel iGPU for wlroots)
      (pkgs.writeScriptBin "waydroid-session" ''
        #!${pkgs.bash}/bin/bash
        # Launch waydroid in a nested Wayland compositor.
        # Uses cage with the Intel iGPU for best wlroots compatibility
        # on NVIDIA PRIME hybrid systems. Falls back to weston if cage fails.

        set -euo pipefail

        # XDG_RUNTIME_DIR must be set for Wayland socket creation
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"

        echo "============================================"
        echo "  Waydroid Launcher"
        echo "============================================"
        echo ""

        # Verify waydroid is initialized
        if [ ! -f /var/lib/waydroid/waydroid.cfg ]; then
          echo ""
          echo "Waydroid not initialized. Please run:"
          echo "  sudo waydroid init"
          echo "  or for Google Apps support:"
          echo "  sudo waydroid init -s GAPPS"
          exit 1
        fi

        # Ensure waydroid container is running
        if ! systemctl is-active --quiet waydroid-container.service; then
          echo "Starting waydroid container service..."
          sudo systemctl start waydroid-container.service
          sleep 3
        fi

        echo ""
        echo "Starting Waydroid in nested compositor..."
        echo "Press Super+Shift+E to exit or close the window."
        echo ""

        # On NVIDIA PRIME, weston's X11 backend is reliable (renders via X server,
        # not wlroots GLES2). Try weston first, fall back to cage with pixman.
        if ${pkgs.weston}/bin/weston --backend=x11-backend.so -- \
          ${pkgs.waydroid}/bin/waydroid show-full-ui; then
          exit 0
        fi

        echo "Weston failed, trying cage with pixman (software) renderer..."
        export WLR_NO_HARDWARE_CURSORS=1
        export WLR_RENDERER=pixman
        exec ${pkgs.cage}/bin/cage -- ${pkgs.waydroid}/bin/waydroid show-full-ui
      '')

      # Launch waydroid with container networking disabled
      (pkgs.writeScriptBin "waydroid-session-nonet" ''
        #!${pkgs.bash}/bin/bash
        # Launch waydroid in a nested Wayland compositor with disabled networking.
        # Use this when iptables modules are missing or container network setup fails.

        set -euo pipefail

        # XDG_RUNTIME_DIR must be set for Wayland socket creation
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"

        echo "============================================"
        echo "  Waydroid Launcher (No Network Mode)"
        echo "============================================"
        echo ""

        # Verify waydroid is initialized
        if [ ! -f /var/lib/waydroid/waydroid.cfg ]; then
          echo ""
          echo "Waydroid not initialized. Please run:"
          echo "  sudo waydroid init"
          echo "  or for Google Apps support:"
          echo "  sudo waydroid init -s GAPPS"
          exit 1
        fi

        # Stop container if running, then restart with networking disabled
        if systemctl is-active --quiet waydroid-container.service; then
          echo "Stopping waydroid container..."
          sudo systemctl stop waydroid-container.service
          sleep 2
        fi

        echo "Starting Waydroid container in no-network mode..."

        WAYDROID_NET_DISABLE=1 sudo systemctl start waydroid-container.service || {
          echo "Service start failed, trying manual start..."
          sudo waydroid container start --disable-network 2>/dev/null || {
            echo "Manual start also failed. Container may need re-initialization."
            exit 1
          }
        }

        sleep 3

        echo ""
        echo "Starting Waydroid in nested compositor (no network)..."
        echo ""

        # Try weston first (reliable on NVIDIA X11)
        if ${pkgs.weston}/bin/weston --backend=x11-backend.so -- \
          ${pkgs.waydroid}/bin/waydroid show-full-ui; then
          exit 0
        fi

        echo "Weston failed, trying cage with pixman renderer..."
        export WLR_NO_HARDWARE_CURSORS=1
        export WLR_RENDERER=pixman
        exec ${pkgs.cage}/bin/cage -- ${pkgs.waydroid}/bin/waydroid show-full-ui
      '')

      # Launch a specific waydroid Android app
      (pkgs.writeScriptBin "waydroid-app" ''
        #!${pkgs.bash}/bin/bash
        # Launch a specific waydroid app in a nested compositor.

        # XDG_RUNTIME_DIR must be set for Wayland socket creation
        export XDG_RUNTIME_DIR="/run/user/$(id -u)"

        if [ -z "$1" ]; then
          echo "Usage: waydroid-app <package-name>"
          echo "Example: waydroid-app com.android.settings"
          echo ""
          echo "To list installed apps: waydroid app list"
          exit 1
        fi

        if ! systemctl is-active --quiet waydroid-container.service; then
          echo "Starting waydroid container..."
          sudo systemctl start waydroid-container.service
          sleep 3
        fi

        # Try weston first (reliable on NVIDIA X11)
        if ${pkgs.weston}/bin/weston --backend=x11-backend.so -- \
          ${pkgs.waydroid}/bin/waydroid app launch "$1"; then
          exit 0
        fi

        echo "Weston failed, trying cage with pixman renderer..."
        export WLR_NO_HARDWARE_CURSORS=1
        export WLR_RENDERER=pixman
        exec ${pkgs.cage}/bin/cage -- ${pkgs.waydroid}/bin/waydroid app launch "$1"
      '')
    ];

    # User groups for waydroid access
    users.groups.waydroid = {};

    # Add specified users to the waydroid group
    users.users = listToAttrs (map (
        userName:
          nameValuePair userName {
            extraGroups = ["waydroid"];
          }
      )
      cfg.users);
  };
}
