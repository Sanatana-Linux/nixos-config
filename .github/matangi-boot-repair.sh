#!/run/current-system/sw/bin/bash
# matangi boot repair — run from a NixOS live ISO booted in UEFI mode.
#
# Repoints the ESP to /boot/efi, moves kernels and GRUB modules onto the ext4
# root filesystem, updates the checkout to origin/main, then reinstalls the
# full system and bootloader with nixos-install.
set -Eeuo pipefail

LOG=${MATANGI_LOG:-/tmp/matangi-boot-repair.log}
if : >>"$LOG" 2>/dev/null; then
	exec > >(tee -a "$LOG") 2>&1
else
	LOG="(not writable; logging disabled)"
fi

STEP="startup"
step() {
	STEP="$1"
	printf '\n==> %s\n' "$1"
}
trap 'rc=$?; printf "\nFAILED in step: %s\n  at line: %s\n  command: %s\n  exit code: %s\n  full transcript: %s\n" "$STEP" "$LINENO" "$BASH_COMMAND" "$rc" "$LOG" >&2; exit "$rc"' ERR

ROOT_UUID=66e07834-4319-432a-8b31-cccc99fe1769
ESP_UUID=4854-CD54

step "checking privileges"
if [ "$(id -u)" -ne 0 ]; then
	echo "Run this script with sudo." >&2
	exit 1
fi

step "clearing any mounts left by a previous run"
umount -R /mnt 2>/dev/null || true

step "mounting the root filesystem (UUID=$ROOT_UUID)"
mount "UUID=$ROOT_UUID" /mnt

step "updating /etc/nixos to origin/main"
own=$(stat -c '%u:%g' /mnt/etc/nixos)
nix-shell -p git --run "
  git -C /mnt/etc/nixos -c safe.directory='*' fetch origin &&
  git -C /mnt/etc/nixos -c safe.directory='*' reset --hard origin/main
"

step "moving the ESP to /boot/efi and kernels onto the root filesystem"
lsblk -o NAME,SIZE,FSTYPE,UUID,MOUNTPOINTS
mkdir -p /mnt/esp-stage /mnt/boot /mnt/boot/efi
mount "UUID=$ESP_UUID" /mnt/esp-stage
cp -a /mnt/esp-stage/. /mnt/boot/
rm -rf /mnt/boot/EFI
umount /mnt/esp-stage
mount "UUID=$ESP_UUID" /mnt/boot/efi
rmdir /mnt/esp-stage 2>/dev/null || true

step "checking UEFI boot mode"
if [ ! -d /sys/firmware/efi ]; then
	echo "This live session is not booted in UEFI mode, so firmware boot entries cannot be written." >&2
	echo "Reboot the USB in UEFI mode and run the script again." >&2
	exit 1
fi

step "handing the checkout to root for evaluation"
chown -R root:root /mnt/etc/nixos

step "installing the full system and bootloader (builds the whole closure; longest step, expect 10-40 minutes)"
nixos-install --root /mnt --flake /mnt/etc/nixos#matangi

step "cleaning up mounts"
umount -R /mnt || echo "warning: /mnt did not unmount cleanly; a reboot releases it"

printf '\nDone. Reboot, then run: sudo chown -R %s /etc/nixos\n' "$own"
