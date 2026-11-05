#!/run/current-system/sw/bin/bash
# matangi first boot after the boot-repair script.
#
# Restores ownership of the checkout, clears the stale kernels and GRUB modules
# the old layout left on the ESP, and verifies the new layout actually took.
# Owner for /etc/nixos is the numeric uid:gid the repair script saved.
# Optional argument overrides it; no username lookup is performed.
set -Eeuo pipefail

LOG=${MATANGI_LOG:-/tmp/matangi-first-boot.log}
if : >> "$LOG" 2>/dev/null; then
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

OWNER="${1:-$(cat /etc/nixos.owner 2>/dev/null || echo 0:0)}"
failures=0

step "checking privileges"
if [ "$(id -u)" -ne 0 ]; then
	echo "Run this script with sudo." >&2
	exit 1
fi

step "removing stale kernels and GRUB modules from the ESP"
shopt -s nullglob
stale=(/boot/efi/vmlinuz-* /boot/efi/initrd-* /boot/efi/grub)
shopt -u nullglob
if [ "${#stale[@]}" -gt 0 ]; then
	rm -rf -- "${stale[@]}"
	printf 'removed: %s\n' "${stale[*]}"
else
	echo "nothing stale on the ESP"
fi

step "restoring ownership of /etc/nixos to $OWNER"
chown -R "$OWNER" /etc/nixos
printf 'ok: /etc/nixos now owned by %s\n' "$(stat -c '%U:%G' /etc/nixos)"

step "verifying /boot/efi is the vfat ESP"
if [ "$(findmnt -no FSTYPE /boot/efi 2>/dev/null)" = "vfat" ]; then
	printf 'ok: /boot/efi is vfat (%s)\n' "$(findmnt -no SOURCE /boot/efi)"
else
	echo "FAIL: /boot/efi is not a vfat mount" >&2
	failures=$((failures + 1))
fi

step "verifying /boot lives on the root filesystem"
if findmnt -n /boot >/dev/null 2>&1; then
	echo "FAIL: /boot is a separate mount; kernels should sit on the root filesystem" >&2
	failures=$((failures + 1))
else
	echo "ok: /boot is a plain directory on /"
fi

step "verifying kernels are present in /boot"
shopt -s nullglob
kernels=(/boot/vmlinuz*)
initrds=(/boot/initrd*)
shopt -u nullglob
if [ "${#kernels[@]}" -gt 0 ] && [ "${#initrds[@]}" -gt 0 ]; then
	printf 'ok: %s kernel(s), %s initrd(s)\n' "${#kernels[@]}" "${#initrds[@]}"
else
	echo "FAIL: no kernel or initrd found in /boot" >&2
	failures=$((failures + 1))
fi

step "verifying the running kernel"
case "$(uname -r)" in
*xanmod*)
	printf 'ok: running %s\n' "$(uname -r)"
	;;
*)
	printf 'FAIL: running %s, expected an xanmod kernel\n' "$(uname -r)" >&2
	failures=$((failures + 1))
	;;
esac

step "reporting state"
df -h /boot/efi || true
printf 'checkout: %s\n' "$(git -C /etc/nixos log -1 --oneline 2>/dev/null || echo 'not readable by git')"
failed_units=$(systemctl --failed --no-legend 2>/dev/null | wc -l)
if [ "$failed_units" -eq 0 ]; then
	echo "ok: no failed systemd units"
else
	printf 'warning: %s failed systemd unit(s); inspect with systemctl --failed\n' "$failed_units"
fi

step "result"
if [ "$failures" -ne 0 ]; then
	printf '%s check(s) failed — see above\n' "$failures" >&2
	exit 1
fi
echo "All checks passed."
