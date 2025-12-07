# Waydroid Setup and Usage Guide

## Overview

Waydroid is now configured to work on this X11-based system (AwesomeWM) by using a nested Wayland compositor (Cage). This allows you to run Android applications on your NixOS system.

## Current Status

✅ **Waydroid is installed and configured**
✅ **Container service is running**
✅ **System is initialized with GAPPS (Google Apps)**
✅ **Helper scripts are available**

## Quick Start

### Launch Waydroid

To start Waydroid with the full Android UI:

```bash
waydroid-session
```

This will:
1. Check if the waydroid container is running (start it if needed)
2. Open a new window with Cage compositor
3. Launch the full Android interface

### Launch Specific Apps

To launch a specific Android app:

```bash
waydroid-app com.android.settings
```

To see all installed apps:

```bash
waydroid app list
```

## Key Controls

- **Exit Waydroid**: Press `Super+Shift+E` or close the Cage window
- **Rotate Screen**: Use Waydroid settings or: `waydroid prop set persist.waydroid.fake_wifi`
- **Go Back**: Alt+Esc or use on-screen navigation

## Common Tasks

### Install Android Apps

1. **From APK file**:
   ```bash
   waydroid app install /path/to/app.apk
   ```

2. **From Google Play Store** (if initialized with GAPPS):
   - Launch `waydroid-session`
   - Open Play Store from the launcher
   - Sign in with your Google account
   - Install apps normally

### Manage Apps

```bash
# List all installed apps
waydroid app list

# Launch an app
waydroid-app <package-name>

# Remove an app
waydroid app remove <package-name>
```

### Access Android Shell

```bash
# Start a shell session
sudo waydroid shell

# Or use adb
adb connect 127.0.0.1:5555
adb shell
```

### File Transfer

**From Linux to Android**:
```bash
# Android's data partition is mounted at:
/var/lib/waydroid/data/media/0/

# You can also use adb:
adb push /path/to/file /sdcard/
```

**From Android to Linux**:
```bash
adb pull /sdcard/file /path/to/destination
```

## Configuration

### Current Configuration

- **Architecture**: x86_64
- **Vendor**: MAINLINE
- **System**: LineageOS with GAPPS
- **Binder**: Native Android binder support (built into kernel)

### Configuration File

The main configuration is located at:
```
/var/lib/waydroid/waydroid.cfg
```

### Useful Properties

Set properties with: `waydroid prop set <property> <value>`

```bash
# Enable WiFi spoofing (some apps require WiFi)
waydroid prop set persist.waydroid.fake_wifi true

# Set DPI (if apps look too large/small)
waydroid prop set ro.sf.lcd_density 240

# Enable multi-window mode
waydroid prop set persist.waydroid.multi_windows true
```

## Troubleshooting

### Container Not Starting

```bash
# Check container status
systemctl status waydroid-container.service

# Restart container
sudo systemctl restart waydroid-container.service

# View logs
journalctl -u waydroid-container.service -f
```

### Session Won't Start

```bash
# Check if running on Wayland
echo $WAYLAND_DISPLAY

# If empty, you're on X11 (expected) - use waydroid-session script
waydroid-session

# View detailed logs
waydroid log
```

### Performance Issues

1. **Enable GPU acceleration** (already configured with NVIDIA):
   ```bash
   waydroid prop set persist.waydroid.gpu_mode host
   ```

2. **Increase allocated RAM**:
   Edit `/var/lib/waydroid/waydroid.cfg` and add:
   ```ini
   [properties]
   ro.boot.waydroid.mem=2048
   ```

3. **Check system resources**:
   ```bash
   sudo waydroid container stats
   ```

### Apps Won't Install/Run

1. **Check if Play Services are working**:
   ```bash
   waydroid app list | grep gms
   ```

2. **Clear app data**:
   ```bash
   waydroid session stop
   sudo rm -rf /var/lib/waydroid/data/data/<app-package>
   waydroid-session
   ```

3. **Reinstall system images**:
   ```bash
   sudo waydroid session stop
   sudo systemctl stop waydroid-container.service
   sudo rm -rf /var/lib/waydroid/images
   sudo waydroid init -s GAPPS -f
   sudo systemctl start waydroid-container.service
   ```

## Technical Details

### Architecture

The Waydroid setup uses:
- **Cage**: A kiosk-style Wayland compositor that runs nested on X11
- **Binder IPC**: Built into the xanmod kernel (CONFIG_ANDROID_BINDER_IPC=y)
- **LXC Container**: Runs the Android system in a containerized environment
- **GPU Passthrough**: Direct NVIDIA GPU access for hardware acceleration

### File Locations

- **System images**: `/var/lib/waydroid/images/`
- **User data**: `/var/lib/waydroid/data/`
- **Configuration**: `/var/lib/waydroid/waydroid.cfg`
- **LXC config**: `/var/lib/waydroid/lxc/waydroid/config`
- **Logs**: `/var/lib/waydroid/waydroid.log`

### Services

```bash
# Container service (should always be running)
systemctl status waydroid-container.service

# Start/stop container
sudo systemctl start waydroid-container.service
sudo systemctl stop waydroid-container.service
```

## Advanced Usage

### Using with OBS/Streaming

Since Waydroid runs in a Cage window, you can easily capture it with OBS:
1. Add a Window Capture source in OBS
2. Select the Cage window
3. The Android screen will be captured

### Multiple Android Instances

Waydroid currently supports only one instance per system, but you can:
1. Stop the current session
2. Backup `/var/lib/waydroid/data`
3. Reset and create a new profile
4. Restore the backup when needed

### Network Configuration

Waydroid creates a virtual network interface `waydroid0`:
```bash
# Check Waydroid network
ip addr show waydroid0

# The Android container typically gets IP: 192.168.250.112
# The host bridge is at: 192.168.250.1
```

## Performance Tips

1. **Use hardware acceleration**: Already enabled with NVIDIA GPU
2. **Close unused Android apps**: Just like a real device
3. **Allocate more RAM**: Edit the config file (see Troubleshooting)
4. **Use native apps when possible**: Waydroid is great but native Linux apps are faster

## Resources

- [Waydroid Documentation](https://docs.waydro.id/)
- [Waydroid GitHub](https://github.com/waydroid/waydroid)
- [NixOS Waydroid Wiki](https://nixos.wiki/wiki/WayDroid)

## Getting Help

If you encounter issues:
1. Check this documentation first
2. Review the logs: `waydroid log` or `journalctl -u waydroid-container.service`
3. Check the Waydroid GitHub issues
4. Ask in NixOS community channels

---

**Note**: This setup is specifically configured for X11 environments (like AwesomeWM). If you switch to a native Wayland compositor (like Sway, Hyprland, etc.), you can use `waydroid show-full-ui` directly without the `waydroid-session` wrapper.
