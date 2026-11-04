#!/run/current-system/sw/bin/bash
# matangi boot repair — run from a NixOS live ISO booted in UEFI mode.
#
# Repoints the ESP to /boot/efi, moves kernels and GRUB modules onto the ext4
# root filesystem, brings the checkout to origin/main, and re-installs the
# system + bootloader with nixos-install.
set -euo pipefail

ROOT_UUID=66e07834-4319-432a-8b31-cccc99fe1769
ESP_UUID=4854-CD54

mount "UUID=$ROOT_UUID" /mnt

own=$(stat -c '%u:%g' /mnt/etc/nixos)
nix-shell -p git --run "
  git -C /mnt/etc/nixos -c safe.directory='*' fetch origin &&
  git -C /mnt/etc/nixos -c safe.directory='*' reset --hard origin/main
"

mkdir -p /mnt/esp-stage /mnt/boot /mnt/boot/efi
mount "UUID=$ESP_UUID" /mnt/esp-stage
cp -a /mnt/esp-stage/. /mnt/boot/
rm -rf /mnt/boot/EFI
mount "UUID=$ESP_UUID" /mnt/boot/efi
cp -a /mnt/esp-stage/EFI /mnt/boot/efi/
umount /mnt/esp-stage
rmdir /mnt/esp-stage

[ -d /sys/firmware/efi ] || {
	echo "This machine is not booted in UEFI mode; reboot the USB in UEFI mode."
	exit 1
}

chown -R root:root /mnt/etc/nixos

nixos-install --root /mnt --flake /mnt/etc/nixos#matangi \
	--impure --no-root-passwd --no-channel-copy

umount -R /mnt
echo "Done. Reboot, then run: sudo chown -R $own /etc/nixos"
