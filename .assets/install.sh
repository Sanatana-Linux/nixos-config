#!/usr/bin/env bash
set -e # Exit immediately if a command exits with a non-zero status
set -u # Treat unset variables as an error and exit immediately

# --- Root Privilege Check ---
if [[ $EUID -ne 0 ]]; then
	error "This script must be run as root. Use sudo."
	exit 1
fi

# --- Output Formatting ---
RED="\033[1;31m"
GREEN="\033[1;32m"
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
error() { echo -e " ${RED}*${NORMAL}  $@"; }     # Print error messages in red
success() { echo -e " ${GREEN}*${NORMAL}  $@"; } # Print success messages in green

# --- Prompt user for Yes/No confirmation ---
yesno_prompt() {
	while true; do
		read -p "$1 [Yes/No] " confirm
		case $confirm in
		[yY][eE][sS]*) return 0 ;;
		[nN][oO]*) return 1 ;;
		*) echo "Please answer Yes or No." ;;
		esac
	done
}

# --- Print installer banner and warning ---
print_banner() {
	echo
	echo " N)    nn  I)iiii  "
	echo " N)n   nn    I)    "
	echo " N)nn  nn    I)           Welcome to"
	echo " N) nn nn    I)             NixOS"
	echo " N)  nnnn    I)           Installer"
	echo " N)   nnn    I)"
	echo " N)    nn  I)iiii"
	echo
	echo
	echo
	echo " We are going to install NixOS on this computer."
	echo "         !!! ALL DATA WILL BE LOST !!! "
	echo
	echo
	while true; do
		if ! yesno_prompt "[?] Do you understand?"; then
			echo "Terminating the installer. Bye!"
			exit
		else
			break
		fi
	done
}

# --- Find and select installation device interactively ---
find_install_device() {
	local devices=()
	local device
	local i=1

	# List block devices (excluding loop devices and partitions)
	while read -r device; do
		devices+=("$device")
		echo "  $i) /dev/$device"
		((i++))
	done < <(lsblk -d -n -o NAME | grep -v '^loop')

	if [ ${#devices[@]} -eq 0 ]; then
		error "No suitable block devices found."
		exit 1
	fi

	while true; do
		read -p "[?] Choose a device number: " choice </dev/tty
		if [[ "$choice" =~ ^[0-9]+$ ]]; then
			if [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#devices[@]} ]]; then
				export INST_DEVICE="/dev/${devices[$((choice - 1))]}"
				success "Selected device: $INST_DEVICE"
				break
			else
				echo "Invalid choice. Please select a number from the list."
			fi
		else
			echo "Invalid input. Please enter a number."
		fi
	done
}

# --- Partition the selected device using parted ---
run_parted() {
	if ! yesno_prompt "[?] We are going to run parted on ${BOLD}$INST_DEVICE${NORMAL}.  This will erase ALL data on the device. Is this okay?"; then
		echo "Terminating the installer. Bye!"
		exit
	fi

	echo -n "[-] Partitioning $INST_DEVICE... "
	if ! wipefs -a "$INST_DEVICE"; then
		error "ERROR: wipefs failed.  Is the device mounted?"
		exit 1
	fi
	if ! parted "$INST_DEVICE" -- mklabel gpt >/dev/null 2>&1; then
		error "ERROR: parted mklabel failed."
		exit 1
	fi
	if ! parted "$INST_DEVICE" -- mkpart ESP fat32 1MiB 512MiB set 1 boot on >/dev/null 2>&1; then
		error "ERROR: parted mkpart ESP failed."
		exit 1
	fi
	if ! parted "$INST_DEVICE" mkpart primary ext4 537M 100% set 2 lvm on >/dev/null 2>&1; then
		error "ERROR: parted mkpart primary failed."
		exit 1
	fi

	success "Partitioning complete."
}

# --- Ask user if disk encryption should be enabled, generate passwords ---
setup_encryption() {
	while true; do
		if yesno_prompt "[?] Do you wish to ${BOLD}encrypt${NORMAL} your disk?"; then
			ENCRYPTION=true
			echo "Proceeding with encryption."
			break
		else
			echo "Leaving your disk unencrypted."
			ENCRYPTION=false
			break
		fi
	done

	# Generate root and encryption passwords
	INST_PASSWD=$(diceware -n 3)
	INST_PASSWD_SHA512=$(mkpasswd -m sha-512 -s <<<"${INST_PASSWD}")
	export INST_PASSWD
	export INST_PASSWD_SHA512
	export ENCRYPTION
}

# --- Encrypt the partition using cryptsetup if enabled ---
run_cryptsetup() {
	if [ "$ENCRYPTION" = true ]; then
		echo -n "[-] Encrypting the disk... "
		local device="${INST_DEVICE}p2"
		if ! echo -n "$INST_PASSWD" | cryptsetup -q --type luks1 luksFormat "$device" -; then
			error "ERROR: cryptsetup luksFormat failed."
			exit 1
		fi
		if ! echo -n "$INST_PASSWD" | cryptsetup luksOpen "$device" enc-pv -d -; then
			error "ERROR: cryptsetup luksOpen failed."
			exit 1
		fi
		success "Disk encryption complete."
	fi
}

# --- Set up LVM, format filesystems, and mount them ---
run_fssetup() {
	echo -n "[-] Setting up LVM... "
	local vg_device
	if [ "$ENCRYPTION" = true ]; then
		vg_device="/dev/mapper/enc-pv"
	else
		vg_device="${INST_DEVICE}2"
	fi

	if ! pvcreate "$vg_device" >/dev/null 2>&1; then
		error "ERROR: pvcreate failed."
		exit 1
	fi
	if ! vgcreate vg "$vg_device" >/dev/null 2>&1; then
		error "ERROR: vgcreate failed."
		exit 1
	fi
	if ! lvcreate -n swap vg -L 8G >/dev/null 2>&1; then
		error "ERROR: lvcreate swap failed."
		exit 1
	fi
	if ! lvcreate -n root vg -l 100%FREE >/dev/null 2>&1; then
		error "ERROR: lvcreate root failed."
		exit 1
	fi
	success "LVM setup complete."

	echo -n "[-] Formating filesystems... "
	if ! mkfs.fat -F 32 -n boot "${INST_DEVICE}1" >/dev/null 2>&1; then
		error "ERROR: mkfs.fat failed."
		exit 1
	fi
	if ! mkfs.ext4 -L root /dev/vg/root >/dev/null 2>&1; then
		error "ERROR: mkfs.ext4 failed."
		exit 1
	fi
	if ! mkswap -L swap /dev/vg/swap >/dev/null 2>&1; then
		error "ERROR: mkswap failed."
		exit 1
	fi
	success "Filesystem formatting complete."

	echo -n "[-] Mouting filesystems... "
	if ! mount /dev/disk/by-label/root /mnt; then
		error "ERROR: mount /dev/vg/root failed."
		exit 1
	fi
	if ! mkdir -p /mnt/boot; then
		error "ERROR: mkdir /mnt/boot failed."
		exit 1
	fi

	if ! mount /dev/disk/by-label/boot /mnt/boot; then
		error "ERROR: mount /dev/disk/by-label/boot failed."
		exit 1
	fi
	if ! swapon /dev/disk/by-label/swap >/dev/null 2>&1; then
		error "ERROR: swapon failed."
		exit 1
	fi
	success "Filesystems mounted."
}

# --- Clone NixOS configuration repository into target system ---
run_nixos_config_setup() {
	echo "[-] Setting up NixOS configuration directory... "
	if ! mkdir -p /mnt/etc; then
		error "Failed to create /mnt/etc"
		exit 1
	fi
	if ! git clone https://github.com/Sanatana-Linux/nixos-config /mnt/etc/nixos; then
		error "Failed to clone the NixOS config repository"
		exit 1
	fi
	success "NixOS configuration directory setup complete."
}

# --- Ask user to select a configuration from flake.nix ---
ask_flake_config() {
	echo " "
	echo "Available configurations in flake.nix:"
	# Extract configuration options from flake.nix
	CONFIG_OPTIONS=$(grep -oP '(?<=self\.nixosConfigurations\.)[^.= ]+' /mnt/etc/nixos/flake.nix)

	IFS=$'\n' read -r -d '' -a OPTIONS_ARRAY <<<"$CONFIG_OPTIONS"

	if [ ${#OPTIONS_ARRAY[@]} -eq 0 ]; then
		echo "No configurations found in flake.nix. Please check the file."
		exit 1
	fi

	for i in "${!OPTIONS_ARRAY[@]}"; do
		echo "  $((i + 1)) - ${OPTIONS_ARRAY[$i]}"
	done

	while true; do
		read -p "[?] Choose a configuration number: " CONFIG_CHOICE </dev/tty
		if [[ "$CONFIG_CHOICE" =~ ^[0-9]+$ ]]; then
			if [[ "$CONFIG_CHOICE" -ge 1 ]] && [[ "$CONFIG_CHOICE" -le ${#OPTIONS_ARRAY[@]} ]]; then
				FLAKE_CONFIG="${OPTIONS_ARRAY[$((CONFIG_CHOICE - 1))]}"
				export FLAKE_CONFIG="${FLAKE_CONFIG}"
				break
			else
				echo "Invalid choice. Please select a number from the list."
			fi
		else
			echo "Invalid input. Please enter a number."
		fi
	done
	echo "You have chosen configuration: ${FLAKE_CONFIG}"
}

# --- Generate and move hardware configuration for selected flake ---
run_nixos_hardware_config() {
	echo "[-] Configuring hardware for $FLAKE_CONFIG..."

	# Remove any existing hardware-configuration files
	rm -rf /mnt/etc/nixos/hosts/*
	# Generate new hardware-configuration.nix
	if ! nixos-generate-config --root /mnt; then
		error "nixos-generate-config failed"
		exit 1
	fi

	# Move generated hardware-configuration.nix to correct location
	if ! mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/"$FLAKE_CONFIG"/; then
		error "Failed to move hardware-configuration.nix"
		exit 1
	fi

	# Remove original configuration.nix
	if ! rm /mnt/etc/nixos/configuration.nix; then
		error "Failed to remove old config"
		exit 1
	fi
	success "Hardware configuration complete."
}

# --- Run NixOS installation using the selected flake configuration ---
run_nixos_flake_install() {
	# Install the chosen configuration
	echo "[-] Running nixos-install with flake configuration '.#${FLAKE_CONFIG}'... "
	if ! nixos-install --flake ".#${FLAKE_CONFIG}" --impure; then
		error "nixos-install failed"
		exit 1
	fi
	success "NixOS installation complete."
}

# --- Print final instructions and passwords to user ---
print_finish() {
	clear
	echo "Installation finished."
	echo "Please take note of your password before reboot."
	echo
	printf "!!! This is your initial ROOT PASSWORD"
	if [ "$ENCRYPTION" = true ]; then
		printf " and DISK ENCRYPTION PASSPHRASE"
	fi
	echo " !!!"
	echo
	echo "Password:${bold} $INST_PASSWD ${normal}"
	echo
	printf "!!! This is your initial ROOT PASSWORD"
	if [ "$ENCRYPTION" = true ]; then
		printf "and DISK ENCRYPTION PASSPHRASE"
	fi
	echo " !!!"
	echo
}

# --- Prompt user to confirm password is saved, then reboot ---
run_reboot() {
	while true; do
		read -p "[?] Have you written down the ${bold}password${normal} - continue with ${bold}REBOOT${normal} [Yes/No] " confirm
		case $confirm in
		[yY][eE][sS]*)
			echo "REBOOTING"
			sleep 1
			reboot
			break
			;;
		[nN][oO]*)
			echo "Password:${bold} $INST_PASSWD ${normal}"
			;;
		*)
			echo "Please write down your password, then reboot."
			;;
		esac
	done
}

# --- Configure additional disk with optional encryption and mount points ---
setup_additional_disk() {
	if [ "$ADDITIONAL_DISK" != "true" ]; then
		return 0
	fi

	echo
	echo "=== Additional Disk Configuration ==="
	echo

	# Find available disks (excluding the installation disk)
	local devices=()
	local device
	local i=1

	while read -r device; do
		if [ "/dev/$device" != "$INST_DEVICE" ]; then
			devices+=("$device")
			echo "  $i) /dev/$device"
			((i++))
		fi
	done < <(lsblk -d -n -o NAME | grep -v '^loop')

	if [ ${#devices[@]} -eq 0 ]; then
		echo "No additional disks found. Skipping."
		return 0
	fi

	while true; do
		read -p "[?] Choose an additional disk number (or 'q' to skip): " choice </dev/tty
		if [[ "$choice" == "q" ]] || [[ "$choice" == "Q" ]]; then
			echo "Skipping additional disk configuration."
			return 0
		elif [[ "$choice" =~ ^[0-9]+$ ]]; then
			if [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#devices[@]} ]]; then
				export ADDITIONAL_DISK_DEVICE="/dev/${devices[$((choice - 1))]}"
				success "Selected additional disk: $ADDITIONAL_DISK_DEVICE"
				break
			else
				echo "Invalid choice. Please select a number from the list."
			fi
		else
			echo "Invalid input. Please enter a number or 'q' to skip."
		fi
	done

	# Ask about encryption for additional disk
	local additional_encryption=false
	if yesno_prompt "[?] Do you want to encrypt this additional disk?"; then
		additional_encryption=true
		echo "Additional disk will be encrypted with the same passphrase as the main disk."
	else
		echo "Additional disk will be unencrypted."
	fi

	# Ask for mount point
	echo
	echo "Enter the desired mount point for this disk (e.g., /data, /home/storage, /mnt/backup):"
	read -p "[?] Mount point: " mount_point </dev/tty

	# Validate mount point
	if [[ ! "$mount_point" =~ ^/ ]]; then
		error "Mount point must start with /"
		mount_point="/mnt/$(basename "$mount_point")"
		echo "Using default mount point: $mount_point"
	fi

	export ADDITIONAL_DISK_MOUNT="$mount_point"
	export ADDITIONAL_DISK_ENCRYPTED="$additional_encryption"

	# Partition the additional disk
	echo -n "[-] Partitioning additional disk $ADDITIONAL_DISK_DEVICE... "
	if ! wipefs -a "$ADDITIONAL_DISK_DEVICE"; then
		error "ERROR: wipefs failed on additional disk."
		exit 1
	fi

	if ! parted "$ADDITIONAL_DISK_DEVICE" -- mklabel gpt >/dev/null 2>&1; then
		error "ERROR: parted mklabel failed on additional disk."
		exit 1
	fi

	if ! parted "$ADDITIONAL_DISK_DEVICE" mkpart primary ext4 1MiB 100% >/dev/null 2>&1; then
		error "ERROR: parted mkpart failed on additional disk."
		exit 1
	fi

	success "Partitioning complete."

	# Encrypt if requested
	if [ "$additional_encryption" = true ]; then
		echo -n "[-] Encrypting additional disk... "
		local device="${ADDITIONAL_DISK_DEVICE}p1"
		# Use the same passphrase as the main disk
		if ! echo -n "$INST_PASSWD" | cryptsetup -q --type luks1 luksFormat "$device" -; then
			error "ERROR: cryptsetup luksFormat failed on additional disk."
			exit 1
		fi
		if ! echo -n "$INST_PASSWD" | cryptsetup luksOpen "$device" enc-additional-disk -d -; then
			error "ERROR: cryptsetup luksOpen failed on additional disk."
			exit 1
		fi
		success "Additional disk encryption complete."

		# Set up LVM on encrypted volume (same as main disk)
		echo -n "[-] Setting up LVM on additional disk... "
		local vg_device="/dev/mapper/enc-additional-disk"

		if ! pvcreate "$vg_device" >/dev/null 2>&1; then
			error "ERROR: pvcreate failed on additional disk."
			exit 1
		fi
		if ! vgcreate vg-additional "$vg_device" >/dev/null 2>&1; then
			error "ERROR: vgcreate failed on additional disk."
			exit 1
		fi
		if ! lvcreate -n data vg-additional -l 100%FREE >/dev/null 2>&1; then
			error "ERROR: lvcreate failed on additional disk."
			exit 1
		fi
		success "LVM setup complete."

		# Format the logical volume
		echo -n "[-] Formatting additional disk... "
		if ! mkfs.ext4 -L additional_disk /dev/vg-additional/data >/dev/null 2>&1; then
			error "ERROR: mkfs.ext4 failed on additional disk."
			exit 1
		fi
		success "Formatting complete."
	else
		# For unencrypted disks, still use LVM for consistency
		echo -n "[-] Setting up LVM on additional disk... "
		local vg_device="${ADDITIONAL_DISK_DEVICE}p1"

		if ! pvcreate "$vg_device" >/dev/null 2>&1; then
			error "ERROR: pvcreate failed on additional disk."
			exit 1
		fi
		if ! vgcreate vg-additional "$vg_device" >/dev/null 2>&1; then
			error "ERROR: vgcreate failed on additional disk."
			exit 1
		fi
		if ! lvcreate -n data vg-additional -l 100%FREE >/dev/null 2>&1; then
			error "ERROR: lvcreate failed on additional disk."
			exit 1
		fi
		success "LVM setup complete."

		# Format the logical volume
		echo -n "[-] Formatting additional disk... "
		if ! mkfs.ext4 -L additional_disk /dev/vg-additional/data >/dev/null 2>&1; then
			error "ERROR: mkfs.ext4 failed on additional disk."
			exit 1
		fi
		success "Formatting complete."
	fi

	# Create mount point directory
	if ! mkdir -p "/mnt$mount_point"; then
		error "ERROR: Failed to create mount point directory."
		exit 1
	fi

	# Mount the additional disk temporarily for hardware config generation
	if ! mount /dev/disk/by-label/additional_disk "/mnt$mount_point"; then
		error "ERROR: Failed to mount additional disk."
		exit 1
	fi

	success "Additional disk mounted at $mount_point"

	# Store configuration for later use in hardware-config generation
	export ADDITIONAL_DISK_CONFIGURED=true
}

# --- Generate hardware configuration with additional disk support ---
run_nixos_hardware_config_with_additional_disk() {
	echo "[-] Configuring hardware for $FLAKE_CONFIG..."

	# Remove any existing hardware-configuration files
	rm -rf /mnt/etc/nixos/hosts/*
	# Generate new hardware-configuration.nix
	if ! nixos-generate-config --root /mnt; then
		error "nixos-generate-config failed"
		exit 1
	fi

	# Move generated hardware-configuration.nix to correct location
	if ! mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/"$FLAKE_CONFIG"/; then
		error "Failed to move hardware-configuration.nix"
		exit 1
	fi

	# Remove original configuration.nix
	if ! rm /mnt/etc/nixos/configuration.nix; then
		error "Failed to remove old config"
		exit 1
	fi

	# Add additional disk configuration to hardware-configuration.nix if configured
	if [ "$ADDITIONAL_DISK_CONFIGURED" = true ]; then
		echo "[-] Adding additional disk configuration to hardware-configuration.nix..."

		local hw_config="/mnt/etc/nixos/hosts/$FLAKE_CONFIG/hardware-configuration.nix"
		local uuid_label

		# Get UUID of the LVM logical volume (same for both encrypted and unencrypted)
		uuid_label=$(blkid -s UUID -o value /dev/vg-additional/data)

		# Add file system entry before the closing brace of the main configuration
		# Find the line with networking.useDHCP and insert before it
		local insert_line=$(grep -n "networking.useDHCP" "$hw_config" | cut -d: -f1)

		if [ -n "$insert_line" ]; then
			# Create temporary file with additional disk configuration
			local temp_file=$(mktemp)

			# Read the file up to the insertion point
			head -n $((insert_line - 1)) "$hw_config" >"$temp_file"

			# Add additional disk filesystem configuration
			cat >>"$temp_file" <<EOF

  # Additional disk configuration
  fileSystems."$ADDITIONAL_DISK_MOUNT" = {
    device = "/dev/disk/by-uuid/$uuid_label";
    fsType = "ext4";
    options = [ "nofail" "x-systemd.device-timeout=30" ];
  };
EOF

			# Add the rest of the file
			tail -n +$insert_line "$hw_config" >>"$temp_file"

			# Replace original file
			mv "$temp_file" "$hw_config"

			success "Additional disk configuration added to hardware-configuration.nix"
		else
			error "Could not find insertion point in hardware-configuration.nix"
		fi

		# If encrypted, add boot initrd configuration to unlock both disks with same password
		if [ "$ADDITIONAL_DISK_ENCRYPTED" = true ] && [ "$ENCRYPTION" = true ]; then
			echo "[-] Configuring LUKS keyfile for automatic unlocking of additional disk..."

			# Create a keyfile that will be used to unlock the additional disk
			# This keyfile will be stored in the initrd and removed after unlocking
			local keyfile="/tmp/additional-disk.key"
			echo -n "$INST_PASSWD" >"$keyfile"

			# Add the keyfile to the additional disk's LUKS slot
			if ! echo -n "$INST_PASSWD" | cryptsetup luksAddKey "${ADDITIONAL_DISK_DEVICE}p1" "$keyfile" -d -; then
				error "ERROR: Failed to add keyfile to additional disk."
				rm -f "$keyfile"
				exit 1
			fi

			# The keyfile approach: we'll configure boot.initrd.luks.devices to use the same password
			# by adding another luks device entry that uses the same password interactively
			# For now, we'll note that manual configuration may be needed in the host config

			# Add comment to hardware-configuration.nix about manual LUKS configuration
			cat >>"$hw_config" <<EOF

  # Note: Additional encrypted disk requires manual configuration in host-specific settings.
  # Add the following to your host configuration (e.g., hosts/$FLAKE_CONFIG/default.nix):
  #
  # boot.initrd.luks.devices."enc-additional-disk" = {
  #   device = "/dev/disk/by-uuid/$(blkid -s UUID -o value ${ADDITIONAL_DISK_DEVICE}p1)";
  #   preLVM = true;
  #   # Use the same passphrase as the main disk - it will be prompted during boot
  # };
  #
  # Or configure keyfile-based unlocking for automatic unlock with the same password.
EOF

			rm -f "$keyfile"
			success "LUKS configuration notes added to hardware-configuration.nix"
		fi
	fi

	success "Hardware configuration complete."
}

# --- Main Script Execution ---

clear
print_banner

# Run the script within a nix-shell to ensure dependencies are present
if ! nix-shell -p git nixUnstable neovim git diceware --run '
find_install_device
setup_encryption
run_parted
run_cryptsetup
run_fssetup

# Ask about additional disks
if yesno_prompt "[?] Do you want to configure an additional disk?"; then
	export ADDITIONAL_DISK=true
	echo "Proceeding with additional disk configuration."
	setup_additional_disk
else
	export ADDITIONAL_DISK=false
	echo "Skipping additional disk configuration."
fi

run_nixos_config_setup
ask_flake_config
run_nixos_hardware_config_with_additional_disk
run_nixos_flake_install
print_finish
run_reboot
'; then
	error "Script execution failed within nix-shell."
	exit 1
fi

exit 0 # Explicitly exit with success code
