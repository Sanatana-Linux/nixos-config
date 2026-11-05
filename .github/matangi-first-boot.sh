#!/run/current-system/sw/bin/bash
# matangi first boot after the boot-repair script.
#
# Restores ownership of the checkout and verifies the boot layout. The vfat ESP
# is mounted at /boot; there is no separate /boot/efi. Safe to run more than
# once.
set -Eeuo pipefail

STEP="startup"
step() {
	STEP="$1"
	printf '\n==> %s\n' "$1"
}
trap 'rc=$?; printf "\nFAILED: step=%s line=%s exit=%s\n  command: %s\n" "$STEP" "$LINENO" "$rc" "$BASH_COMMAND" >&2; exit "$rc"' ERR

# Numeric uid:gid only — no passwd lookup. Order: explicit argument, value
# saved by the repair script, owner of the user's home directory, root.
resolve_owner() {
	if [ -n "${1:-}" ]; then
		printf '%s' "$1"
		return
	fi
	if [ -r /etc/nixos.owner ]; then
		cat /etc/nixos.owner
		return
	fi
	if [ -d /home/smg ]; then
		stat -c '%u:%g' /home/smg
		return
	fi
	printf '0:0'
}
OWNER=$(resolve_owner "${1:-}")
failures=0

step "checking privileges"
if [ "$(id -u)" -ne 0 ]; then
	echo "Run this script with sudo." >&2
	exit 1
fi

step "resolving the checkout owner"
printf 'using owner %s\n' "$OWNER"
printf '%s' "$OWNER" >/etc/nixos.owner 2>/dev/null || true

step "restoring ownership of /etc/nixos to $OWNER"
chown -R "$OWNER" /etc/nixos
printf 'ok: /etc/nixos now owned by %s\n' "$(stat -c '%u:%g' /etc/nixos)"

step "verifying /boot is the vfat ESP"
if [ "$(findmnt -no FSTYPE /boot 2>/dev/null)" = "vfat" ]; then
	printf 'ok: /boot is vfat (%s)\n' "$(findmnt -no SOURCE /boot)"
else
	echo "FAIL: /boot is not a vfat mount" >&2
	failures=$((failures + 1))
fi

step "verifying the GRUB core the firmware loads"
if [ -e /boot/EFI/nixos/grubx64.efi ]; then
	echo "ok: /boot/EFI/nixos/grubx64.efi present"
else
	echo "FAIL: /boot/EFI/nixos/grubx64.efi missing" >&2
	failures=$((failures + 1))
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
df -h /boot || true
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
