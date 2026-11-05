#!/run/current-system/sw/bin/bash
# matangi boot repair — run from a NixOS live ISO booted in UEFI mode.
#
# The vfat ESP is mounted at /boot on this host; there is no separate /boot/efi.
# The original boot failure was grub-install writing its core image to
# /boot/efi — a plain directory inside the ESP — while the firmware entry kept
# loading the stale core from the ESP root. modules/nixos/system/boot.nix now
# honours boot.efiMountPoint, so installing with the ESP mounted at /boot
# rewrites the core exactly where the firmware looks.
set -Eeuo pipefail

# The live ISO's nix may not enable flakes/commands by default.
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

step "mounting the root filesystem (UUID=$ROOT_UUID)"
mount "UUID=$ROOT_UUID" /mnt

step "updating /etc/nixos to origin/main"
own=$(stat -c '%u:%g' /mnt/etc/nixos)
printf '%s' "$own" >/mnt/etc/nixos.owner 2>/dev/null || true
nix-shell -p git --run "
  git -C /mnt/etc/nixos -c safe.directory='*' fetch origin &&
  git -C /mnt/etc/nixos -c safe.directory='*' reset --hard origin/main
"

step "mounting the ESP at /mnt/boot"
lsblk -o NAME,SIZE,FSTYPE,UUID,MOUNTPOINTS
mkdir -p /mnt/boot
mount "UUID=$ESP_UUID" /mnt/boot

step "checking UEFI boot mode"
if [ ! -d /sys/firmware/efi ]; then
	echo "This live session is not booted in UEFI mode, so firmware boot entries cannot be written." >&2
	echo "Reboot the USB in UEFI mode and run the script again." >&2
	exit 1
fi

step "handing the checkout to root for evaluation"
chown -R root:root /mnt/etc/nixos

step "installing the full system and bootloader (builds the whole closure; longest step, expect 10-40 minutes)"
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

step "normalising /mnt/etc/fstab for the /boot layout"
fstab=/mnt/etc/fstab
if grep -qE '^[^#].*[[:space:]]/boot/efi[[:space:]]' "$fstab"; then
  sed -i -E 's#([[:space:]])/boot/efi([[:space:]])#\1/boot\2#' "$fstab"
  echo "rewrote /boot/efi -> /boot in fstab"
fi
if ! grep -qE '^[^#].*[[:space:]]/boot[[:space:]]' "$fstab"; then
  printf 'UUID=%s /boot vfat fmask=0022,dmask=0022 0 2\n' "$ESP_UUID" >> "$fstab"
  echo "appended /boot entry to fstab"
fi
grep -nE '^[^#].*[[:space:]]/boot[[:space:]]' "$fstab"

step "ensuring the GRUB core is installed"
if [ ! -e /mnt/boot/EFI/nixos/grubx64.efi ]; then
  echo "core missing; running grub-install inside the target"
  nixos-enter --root /mnt -c 'grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=nixos --recheck && grub-mkconfig -o /boot/grub/grub.cfg'
fi

step "restoring checkout ownership to $own"
chown -R "$own" /mnt/etc/nixos
printf 'ok: /mnt/etc/nixos now owned by %s\n' "$(stat -c '%u:%g' /mnt/etc/nixos)"

step "verifying the installed layout"
failures=0
if [ "$(findmnt -no FSTYPE /mnt/boot 2>/dev/null)" = "vfat" ]; then
	printf 'ok: /boot is the vfat ESP (%s)\n' "$(findmnt -no SOURCE /mnt/boot)"
else
	echo "FAIL: /boot is not a vfat mount" >&2
	failures=$((failures + 1))
fi
if [ -e /mnt/boot/EFI/nixos/grubx64.efi ]; then
	echo "ok: /boot/EFI/nixos/grubx64.efi present"
else
	echo "FAIL: /boot/EFI/nixos/grubx64.efi missing — firmware entry has no core to load" >&2
	failures=$((failures + 1))
fi
if [ -s /mnt/boot/grub/grub.cfg ]; then
	echo "ok: /boot/grub/grub.cfg present"
else
	echo "FAIL: /boot/grub/grub.cfg missing" >&2
	failures=$((failures + 1))
fi
df -h /mnt/boot || true
if [ "$failures" -ne 0 ]; then
	printf '%s verification check(s) failed — see above\n' "$failures" >&2
	exit 1
fi

step "cleaning up mounts"
umount -R /mnt || echo "warning: /mnt did not unmount cleanly; a reboot releases it"

printf '\nDone. Reboot.\n'
