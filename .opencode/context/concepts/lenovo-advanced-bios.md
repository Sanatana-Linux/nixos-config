# Lenovo Advanced BIOS

Core concept: Lenovo Legion laptops ship with thermal issues due to missing CPU voltage limits. The Advanced BIOS (unlocked via SREP EFI executables on USB) allows undervolting. The same SREP files are included as a GRUB menu entry in the NixOS config.

Key Points:
- SREP = set of EFI executables + config file on FAT32 USB to unlock Advanced BIOS
- Without undervolting, CPU overheats during `nixos-install` on Legion
- Runtime undervolting handled by `modules.performance.undervolt`
- GRUB boot entry for Advanced BIOS built into bagalamukhi config
- ISO with SREP files available at github.com/Thomashighbaugh/Lenovo-Legion-Advanced-Bios

Reference: [.documentation/lenovo-advanced-bios.md](../../.documentation/lenovo-advanced-bios.md)