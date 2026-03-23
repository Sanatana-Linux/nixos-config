#!/usr/bin/env bash
set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables as an error and exit immediately

# --- Output Formatting ---
RED="\033[1;31m"
GREEN="\033[1;32m"
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
error() { echo -e " ${RED}*${NORMAL}  $@"; }
success() { echo -e " ${GREEN}*${NORMAL}  $@"; }

# --- Root Privilege Check ---
if [[ $EUID -ne 0 ]]; then
	error "This script must be run as root. Use sudo."
	exit 1
fi

# --- Ensure we have needed dependencies ---
if ! command -v git >/dev/null || ! command -v parted >/dev/null || ! command -v sgdisk >/dev/null || ! command -v systemd-cryptenroll >/dev/null; then
	echo "Missing dependencies. Re-executing inside nix-shell..."
	exec nix-shell -p git neovim parted gptfdisk cryptsetup lvm2 util-linux systemd --run "bash $0 $@"
fi

# --- Prompt user for Yes/No confirmation ---
yesno_prompt() {
	while true; do
		read -p "$1 [Yes/No] " confirm </dev/tty
		case $confirm in
		[yY][eE][sS]*) return 0 ;;
		[nN][oO]*) return 1 ;;
		*) echo "Please answer Yes or No." ;;
		esac
	done
}

# --- Print installer banner and warning ---
print_banner() {
	clear
	echo
	echo " N)    nn  I)iiii  "
	echo " N)n   nn    I)    "
	echo " N)nn  nn    I)           Welcome to"
	echo " N) nn nn    I)             NixOS"
	echo " N)  nnnn    I)           Installer"
	echo " N)   nnn    I)"
	echo " N)    nn  I)iiii"
	echo
	echo " We are going to install NixOS on this computer."
	echo "         !!! ALL PREVIOUS DATA WILL BE LOST !!! "
	echo
	while true; do
		if ! yesno_prompt "[?] Do you understand?"; then
			echo "Terminating the installer. Bye!"
			exit
		else
			break
		fi
	done
	echo
}

# --- 1. Ask for Password First ---
ask_password() {
	echo "=== 1. Setup Password ==="
	echo "This password will be used for Disk Encryption AND the User/Root accounts."
	while true; do
		read -s -p "[?] Enter password: " INST_PASSWD </dev/tty
		echo
		read -s -p "[?] Confirm password: " INST_PASSWD2 </dev/tty
		echo
		if [[ "$INST_PASSWD" == "$INST_PASSWD2" ]] && [[ -n "$INST_PASSWD" ]]; then
			export INST_PASSWD
			success "Password accepted."
			break
		else
			error "Passwords do not match or are empty. Please try again."
		fi
	done
	echo
}

# Helper to find block devices
choose_device() {
	local prompt_text="$1"
	local exclude_dev="$2"
	local devices=()
	local device
	local i=1

	while read -r device; do
		if [[ -n "$exclude_dev" ]] && [[ "/dev/$device" == "$exclude_dev" ]]; then
			continue
		fi
		devices+=("$device")
		echo "  $i) /dev/$device" >&2
		((i++))
	done < <(lsblk -d -n -o NAME | grep -v '^loop')

	if [[ ${#devices[@]} -eq 0 ]]; then
		error "No suitable block devices found." >&2
		exit 1
	fi

	while true; do
		read -p "$prompt_text" choice </dev/tty >&2
		if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#devices[@]} ]]; then
			echo "/dev/${devices[$((choice - 1))]}"
			break
		else
			echo "Invalid choice. Please select a number from the list." >&2
		fi
	done
}

# --- 2. Ask which disk to encrypt for root ---
ask_root_disk() {
	echo "=== 2. Select Root Disk ==="
	INST_DEVICE=$(choose_device "[?] Choose the ROOT device number to encrypt: " "")
	export INST_DEVICE
	success "Selected root device: $INST_DEVICE"
	echo
}

# --- 3. Ask about an additional encrypted disk ---
ask_additional_disk() {
	echo "=== 3. Additional Disk Configuration ==="
	if yesno_prompt "[?] Would you like to encrypt another disk?"; then
		export ENCRYPT_ADDITIONAL="true"
		echo "Available disks for additional storage:"
		ADDITIONAL_DEVICE=$(choose_device "[?] Choose the ADDITIONAL device number: " "$INST_DEVICE")
		export ADDITIONAL_DEVICE
		success "Selected additional device: $ADDITIONAL_DEVICE"
		
		read -p "[?] What should the mount path on the final system be (e.g., /data)? " ADDITIONAL_MOUNT </dev/tty
		if [[ ! "$ADDITIONAL_MOUNT" =~ ^/ ]]; then
			ADDITIONAL_MOUNT="/$ADDITIONAL_MOUNT"
		fi
		export ADDITIONAL_MOUNT
		success "Additional device will be mounted at: $ADDITIONAL_MOUNT"
	else
		export ENCRYPT_ADDITIONAL="false"
		export ADDITIONAL_MOUNT=""
		echo "Skipping additional disk configuration."
	fi
	echo
}

# Helper for resolving partition paths depending on NVMe/MMC vs SATA
get_part() {
	local dev=$1
	local partnum=$2
	if [[ "$dev" =~ [0-9]$ ]]; then
		echo "${dev}p${partnum}"
	else
		echo "${dev}${partnum}"
	fi
}

# Robust device wait loop to ensure the kernel has loaded the block device
wait_for_dev() {
	local dev=$1
	local timeout=15
	local count=0
	echo -n "Waiting for $dev..."
	while [[ ! -b "$dev" ]]; do
		sleep 1
		count=$((count + 1))
		echo -n "."
		if [[ $count -ge $timeout ]]; then
			echo
			error "Timeout waiting for block device: $dev. The kernel failed to register it in time."
			exit 1
		fi
	done
	echo " OK."
}

# Nuclear Cleanup helper to ensure partitions aren't locked "in use"
cleanup_and_zap() {
	local disk=$1
	echo "[-] Safely unmounting and tearing down old structures on $disk..."

	# Escape the /mnt directory just in case the shell is holding it open
	cd / || true

	# Aggressively unmount anything tied to previous attempts
	if mountpoint -q /mnt/boot; then umount -l /mnt/boot 2>/dev/null || true; fi
	if mountpoint -q /mnt; then umount -l /mnt 2>/dev/null || true; fi
	if [[ -n "$ADDITIONAL_MOUNT" ]] && mountpoint -q "/mnt$ADDITIONAL_MOUNT"; then 
		umount -l "/mnt$ADDITIONAL_MOUNT" 2>/dev/null || true
	fi

	# Disable swap completely
	swapoff -a 2>/dev/null || true

	# Deactivate any old LVM volume groups
	vgchange -an 2>/dev/null || true

	# Close LUKS containers
	for crypt in enc-root enc-swap enc-additional; do
		if [[ -e "/dev/mapper/$crypt" ]]; then
			if ! cryptsetup close "$crypt" 2>/dev/null; then
				error "CRITICAL: The device /dev/mapper/$crypt is locked and cannot be closed."
				error "Make sure no other terminal is open in /mnt."
				exit 1
			fi
		fi
	done

	# Wipe signatures of all existing partitions
	for part in ${disk}p* ${disk}[0-9]*; do
		if [[ -b "$part" ]]; then
			wipefs -af "$part" >/dev/null 2>&1 || true
		fi
	done

	# Zap the whole disk
	wipefs -af "$disk" >/dev/null 2>&1 || true
	sgdisk --zap-all "$disk" >/dev/null 2>&1 || true
	
	partprobe "$disk" 2>/dev/null || true
	udevadm settle
	sleep 2
}

# --- 4. Partition, Encrypt, and Mount the Root Drive ---
setup_root_disk() {
	echo "=== 4. Setting up Root Disk ==="
	cleanup_and_zap "$INST_DEVICE"

	echo "[-] Partitioning $INST_DEVICE..."
	parted -s "$INST_DEVICE" -- mklabel gpt
	parted -s "$INST_DEVICE" -- mkpart ESP fat32 1MiB 2049MiB
	parted -s "$INST_DEVICE" -- set 1 boot on
	parted -s "$INST_DEVICE" -- mkpart primary 2049MiB 34817MiB
	parted -s "$INST_DEVICE" -- mkpart primary 34817MiB 100%
	
	partprobe "$INST_DEVICE" 2>/dev/null || true
	udevadm settle

	BOOT_PART=$(get_part "$INST_DEVICE" 1)
	SWAP_PART=$(get_part "$INST_DEVICE" 2)
	ROOT_PART=$(get_part "$INST_DEVICE" 3)

	wait_for_dev "$BOOT_PART"
	wait_for_dev "$SWAP_PART"
	wait_for_dev "$ROOT_PART"

	echo "[-] Encrypting SWAP partition ($SWAP_PART)..."
	echo -n "$INST_PASSWD" | cryptsetup -q --type luks2 luksFormat "$SWAP_PART" - 
	echo -n "$INST_PASSWD" | cryptsetup luksOpen "$SWAP_PART" enc-swap -d - 
	wait_for_dev "/dev/mapper/enc-swap"

	echo "[-] Encrypting ROOT partition ($ROOT_PART)..."
	echo -n "$INST_PASSWD" | cryptsetup -q --type luks2 luksFormat "$ROOT_PART" - 
	echo -n "$INST_PASSWD" | cryptsetup luksOpen "$ROOT_PART" enc-root -d - 
	wait_for_dev "/dev/mapper/enc-root"

	echo "[-] Formatting filesystems..."
	mkfs.fat -F 32 -n boot "$BOOT_PART"
	mkswap -L swap /dev/mapper/enc-swap
	mkfs.ext4 -L root /dev/mapper/enc-root

	echo "[-] Mounting filesystems..."
	mount /dev/mapper/enc-root /mnt
	mkdir -p /mnt/boot
	mount "$BOOT_PART" /mnt/boot
	swapon /dev/mapper/enc-swap

	echo "[-] Enrolling TPM for Swap & Root..."
	systemd-cryptenroll --wipe-slot=tpm2 "$SWAP_PART" --tpm2-device=auto --tpm2-pcrs=0+2+7 || error "TPM enrollment failed on Swap."
	systemd-cryptenroll --wipe-slot=tpm2 "$ROOT_PART" --tpm2-device=auto --tpm2-pcrs=0+2+7 || error "TPM enrollment failed on Root."
	
	success "Root disk setup and mounting verified."
	echo
}

# --- 5. Partition, Encrypt, and Mount the Additional Drive (if selected) ---
setup_additional_disk() {
	if [[ "$ENCRYPT_ADDITIONAL" == "true" ]]; then
		echo "=== 5. Setting up Additional Disk ==="
		cleanup_and_zap "$ADDITIONAL_DEVICE"

		echo "[-] Partitioning $ADDITIONAL_DEVICE..."
		parted -s "$ADDITIONAL_DEVICE" -- mklabel gpt
		parted -s "$ADDITIONAL_DEVICE" -- mkpart primary ext4 1MiB 100%
		
		partprobe "$ADDITIONAL_DEVICE" 2>/dev/null || true
		udevadm settle

		ADD_PART=$(get_part "$ADDITIONAL_DEVICE" 1)
		wait_for_dev "$ADD_PART"

		echo "[-] Encrypting additional partition ($ADD_PART)..."
		echo -n "$INST_PASSWD" | cryptsetup -q --type luks2 luksFormat "$ADD_PART" - 
		echo -n "$INST_PASSWD" | cryptsetup luksOpen "$ADD_PART" enc-additional -d - 
		wait_for_dev "/dev/mapper/enc-additional"

		echo "[-] Formatting additional disk as ext4..."
		mkfs.ext4 -L additional /dev/mapper/enc-additional

		echo "[-] Mounting additional disk..."
		mkdir -p "/mnt$ADDITIONAL_MOUNT"
		mount /dev/mapper/enc-additional "/mnt$ADDITIONAL_MOUNT"

		echo "[-] Enrolling TPM for additional disk..."
		systemd-cryptenroll --wipe-slot=tpm2 "$ADD_PART" --tpm2-device=auto --tpm2-pcrs=0+2+7 || error "TPM enrollment failed on additional disk."
		
		success "Additional disk setup and mounting verified."
		echo
	fi
}

# --- 6. Clone NixOS Configuration Repo ---
clone_nixos_config() {
	echo "=== 6. Cloning NixOS Config ==="
	mkdir -p /mnt/etc
	rm -rf /mnt/etc/nixos
	echo "[-] Cloning https://github.com/Sanatana-Linux/nixos-config..."
	git clone --depth 1 https://github.com/Sanatana-Linux/nixos-config /mnt/etc/nixos
	success "Repository successfully cloned."
	echo
}

# --- 7. Ask Flake Config ---
ask_flake_config() {
	echo "=== 7. Select Flake Configuration ==="
	echo "Available configurations in flake.nix:"
	
	CONFIG_OPTIONS=$(grep -oP '(?<=self\.nixosConfigurations\.)[^.= ]+' /mnt/etc/nixos/flake.nix || true)
	if [[ -z "$CONFIG_OPTIONS" ]]; then
		error "No configurations found in flake.nix. Check the repository."
		exit 1
	fi

	IFS=$'\n' read -r -d '' -a OPTIONS_ARRAY <<<"$CONFIG_OPTIONS" || true
	for i in "${!OPTIONS_ARRAY[@]}"; do
		echo "  $((i + 1)) - ${OPTIONS_ARRAY[$i]}"
	done

	while true; do
		read -p "[?] Choose a configuration number: " CONFIG_CHOICE </dev/tty
		if [[ "$CONFIG_CHOICE" =~ ^[0-9]+$ ]] && [[ "$CONFIG_CHOICE" -ge 1 ]] && [[ "$CONFIG_CHOICE" -le ${#OPTIONS_ARRAY[@]} ]]; then
			FLAKE_CONFIG="${OPTIONS_ARRAY[$((CONFIG_CHOICE - 1))]}"
			export FLAKE_CONFIG
			break
		else
			echo "Invalid choice. Please select a number from the list."
		fi
	done
	success "Chosen configuration: ${FLAKE_CONFIG}"
	echo
}

# --- 8. Generate Hardware Config ---
generate_hardware_config() {
	echo "=== 8. Generating Hardware Configuration ==="
	echo "[-] Running nixos-generate-config..."
	
	mkdir -p /mnt/etc/nixos/hosts/"$FLAKE_CONFIG"
	rm -f /mnt/etc/nixos/hosts/"$FLAKE_CONFIG"/hardware-configuration.nix
	
	nixos-generate-config --root /mnt
	mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/"$FLAKE_CONFIG"/
	rm -f /mnt/etc/nixos/configuration.nix

	echo "[-] Adding new hardware-configuration.nix to git tracking..."
	git -C /mnt/etc/nixos add hosts/"$FLAKE_CONFIG"/hardware-configuration.nix

	success "Hardware configuration generated and staged successfully."
	echo
}

# --- 9. Install NixOS ---
run_nixos_install() {
	echo "=== 9. Installing NixOS ==="
	echo "[-] Running nixos-install with flake configuration '.#${FLAKE_CONFIG}'..."
	cd /mnt/etc/nixos
	nixos-install --root /mnt --flake ".#${FLAKE_CONFIG}" --no-root-passwd --impure
	cd /
	success "NixOS base installation complete."
	echo
}

# --- 10. Set Passwords & Recommend Reboot ---
post_install_and_reboot() {
	echo "=== 10. Finalizing Installation ==="
	echo "[-] Setting new root and user passwords..."

	nixos-enter --root /mnt -c "echo 'root:$INST_PASSWD' | chpasswd" >/dev/null 2>&1

	NEW_USER=$(nixos-enter --root /mnt -c "getent passwd" | awk -F: '$3 >= 1000 && $3 < 60000 {print $1}' | head -n 1)
	if [[ -n "$NEW_USER" ]]; then
		echo "[-] Setting password for standard user: $NEW_USER"
		nixos-enter --root /mnt -c "echo '$NEW_USER:$INST_PASSWD' | chpasswd" >/dev/null 2>&1
	fi

	success "Passwords successfully set."
	
	clear
	echo "======================================================"
	echo "                 INSTALLATION COMPLETE                "
	echo "======================================================"
	echo " NixOS has been successfully installed!"
	echo " The system has been configured with TPM2 auto-unlock."
	echo ""
	echo " ${BOLD}We highly recommend that you REBOOT your system now.${NORMAL}"
	echo "======================================================"
	echo
	while true; do
		read -p "[?] Would you like to reboot now? [Yes/No] " confirm </dev/tty
		case $confirm in
		[yY][eE][sS]*)
			echo "Rebooting..."
			sleep 2
			reboot
			break
			;;
		[nN][oO]*)
			echo "You can reboot manually using the 'reboot' command when ready."
			break
			;;
		*)
			echo "Please answer Yes or No."
			;;
		esac
	done
}

# --- Main Script Execution Sequence ---
print_banner
ask_password
ask_root_disk
ask_additional_disk
setup_root_disk
setup_additional_disk
clone_nixos_config
ask_flake_config
generate_hardware_config
run_nixos_install
post_install_and_reboot

exit 0
