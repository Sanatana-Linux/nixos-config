#!/run/current-system/sw/bin/bash
# matangi boot repair — run from a NixOS live ISO booted in UEFI mode.
#
# Mounts the vfat ESP at /boot, reinstalls the system with that layout, makes
# sure /etc/fstab mounts the ESP at /boot and the GRUB core lands at
# /boot/EFI/nixos/grubx64.efi.
set -Eeuo pipefail

export NIX_CONFIG="experimental-features = nix-command flakes"

STEP="startup"
step() {
	STEP="$1"
	printf '\n==> %s\n' "$1"
}
trap 'rc=$?; printf "\nFAILED: step=%s line=%s exit=%s\n  command: %s\n" "$STEP" "$LINENO" "$rc" "$BASH_COMMAND" >&2; exit "$rc"' ERR

ROOT_UUID=66e07834-4319-432a-8b31-cccc99fe1769
ESP_UUID=4854-CD54

step "checking privileges"
if [ "$(id -u)" -ne 0 ]; then
	echo "Run this script with sudo." >&2
	exit 1
fi

step "clearing any mounts left by a previous run"
umount -R /mnt 2>/dev/null || true

step "mounting the root filesystem"
mount "UUID=$ROOT_UUID" /mnt

step "updating /etc/nixos to origin/main"
own=$(stat -c '%u:%g' /mnt/etc/nixos)
printf '%s' "$own" >/mnt/etc/nixos.owner 2>/dev/null || true
nix-shell -p git --run "
  git -C /mnt/etc/nixos -c safe.directory='*' fetch origin &&
  git -C /mnt/etc/nixos -c safe.directory='*' reset --hard origin/main
"

step "mounting the ESP at /mnt/boot"
mkdir -p /mnt/boot
mount "UUID=$ESP_UUID" /mnt/boot

step "checking UEFI boot mode"
if [ ! -d /sys/firmware/efi ]; then
	echo "This live session is not booted in UEFI mode; reboot the USB in UEFI mode." >&2
	exit 1
fi

step "handing the checkout to root for evaluation"
chown -R root:root /mnt/etc/nixos

step "reinstalling the system and bootloader (longest step, 10-40 minutes)"
install_log=$(mktemp /tmp/nixos-install.XXXXXX 2>/dev/null) || install_log=""
if [ -n "$install_log" ]; then
	if ! nixos-install --root /mnt --flake /mnt/etc/nixos#matangi --impure \
		--option extra-experimental-features "nix-command flakes" 2>&1 | tee "$install_log"; then
		printf '\n===== nixos-install FAILED — last 25 lines =====\n' >&2
		tail -n 25 "$install_log" >&2 || true
		printf '===== end installer output =====\n' >&2
		exit 1
	fi
	rm -f "$install_log"
else
	nixos-install --root /mnt --flake /mnt/etc/nixos#matangi --impure \
		--option extra-experimental-features "nix-command flakes"
fi

step "pinning the ESP to /boot in fstab"
fstab=/mnt/etc/fstab
if grep -qE '^[^#].*[[:space:]]/boot/efi[[:space:]]' "$fstab"; then
	sed -i -E 's#([[:space:]])/boot/efi([[:space:]])#\1/boot\2#' "$fstab"
fi
if ! grep -qE '^[^#].*[[:space:]]/boot[[:space:]]' "$fstab"; then
	printf 'UUID=%s /boot vfat fmask=0022,dmask=0022 0 2\n' "$ESP_UUID" >>"$fstab"
fi

step "installing the GRUB core at /boot/EFI/nixos"
if [ ! -e /mnt/boot/EFI/nixos/grubx64.efi ]; then
	nixos-enter --root /mnt -c 'grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=nixos --recheck && grub-mkconfig -o /boot/grub/grub.cfg'
fi

step "restoring checkout ownership"
chown -R "$own" /mnt/etc/nixos

step "cleaning up mounts"
umount -R /mnt || true

printf '\nDone. Reboot.\n'
