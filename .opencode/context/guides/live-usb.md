# Live USB / ISO Build

Core concept: The chhinamasta host config produces a bootable live ISO for installation or recovery.

Key Points:
- Build: `nix build /etc/nixos#nixosConfigurations.chhinamasta.config.system.build.isoImage`
- Write: `sudo dd bs=4M if=result/iso/nixos-*.iso of=/dev/sdX status=progress oflag=sync`
- Uses `modulesPath + "/installer/cd-dvd/iso-image.nix"` and `all-hardware.nix`
- Includes basic packages, awesomeWM, and essential hardware support
- Minimal package sets to keep ISO size manageable

Reference: [.documentation/live-usb.md](../../.documentation/live-usb.md), [.documentation/iso.md](../../.documentation/iso.md)