#!/usr/bin/env bash
set -e
set -u  # Exit if an unset variable is used

# Jump into a root shell head first
sudo su

# Colours are for cool kids
error()   { echo -e " \033[1;31m*\033[0m  $@"; }
success() { echo -e " \033[1;32m*\033[0m  $@"; } # Added success color
bold=$(tput bold)
normal=$(tput sgr0)

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
    read -p "[?] Do you understand? [Yes/No] " confirm
      case $confirm in
        [yY][eE][sS]* ) break;;
        [Nn][oO]* ) echo "Terminating the installer. Bye!"; exit;;
        * ) echo "Please answer Yes or No.";;
      esac
  done
}


find_install_device() {
  local devices=()
  local device
  local i=1

  # Use lsblk to get a list of block devices (excluding loop devices and partitions)
  # The -d option shows only the device name, -n removes headers, -o NAME limits output.
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
    read -p "[?] Choose a device number: " choice < /dev/tty
    if [[ "$choice" =~ ^[0-9]+$ ]]; then
      if [[ "$choice" -ge 1 ]] && [[ "$choice" -le ${#devices[@]} ]]; then
          export INST_DEVICE="/dev/${devices[$((choice-1))]}"
          success "Selected device: $INST_DEVICE"
          break;
      else
        echo "Invalid choice. Please select a number from the list."
      fi
    else
      echo "Invalid input. Please enter a number."
    fi
  done
}

run_parted() {
  while true; do
    read -p "[?] We are going to run parted on ${bold}$INST_DEVICE${normal}.  This will erase ALL data on the device. Is this okay? [Yes/No] " confirm
    case $confirm in
      [yY][eE][sS]* ) break;;
      [Nn][oO]* ) echo "Terminating the installer. Bye!"; exit;;
      * ) echo "Please answer Yes or No.";;
    esac
  done
  echo -n "[-] Partitioning $INST_DEVICE... "
  if ! wipefs -a "$INST_DEVICE"; then # Use command substitution and check exit code
    error "ERROR: wipefs failed.  Is the device mounted?"
    exit 1
  fi
  # Use command substitution to check for errors, and redirect output to /dev/null
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

setup_encryption() {
  while true; do
    read -p "[?] Do you wish to ${bold} encrypt ${normal} your disk? [Yes/No] " confirm
    case $confirm in
      [yY][eE][sS]* ) ENCRYPTION=true; echo "Proceeding with encryption."; break;;
      [Nn][oO]* ) echo "Leaving your disk unencrypted."; ENCRYPTION=false; break;;
      * ) echo "Please answer Yes or No.";;
    esac
  done

  # Creating passwords for root and encryption (if enabled)
  INST_PASSWD=$(diceware -n 3);
  INST_PASSWD_SHA512=$(mkpasswd -m sha-512 -s <<< "${INST_PASSWD}")
  export INST_PASSWD
  export INST_PASSWD_SHA512
  export ENCRYPTION
}

run_cryptsetup(){
  if [ "$ENCRYPTION" = true ]; then
    echo -n "[-] Encrypting the disk... "
    # No need to check for /dev/nvme0n1 here; INST_DEVICE is already set
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

run_fssetup(){
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

run_nixos_config_setup() {
  echo "[-] Setting up NixOS configuration directory... "
  # Create the /etc/ file you'll be working in
  if ! mkdir -p /mnt/etc; then
     error "Failed to create /mnt/etc"
     exit 1
  fi
  # clone the repo
  if ! git clone https://github.com/Sanatana-Linux/nixos-config /mnt/etc/nixos; then
    error "Failed to clone the NixOS config repository"
    exit 1
  fi
  success "NixOS configuration directory setup complete."
}

ask_flake_config() {
  echo " "
  echo "Available configurations in flake.nix:"
  # Correctly extract configuration options
  CONFIG_OPTIONS=$(grep -oP '(?<=self\.nixosConfigurations\.)[^.= ]+' /mnt/etc/nixos/flake.nix)

  IFS=$'\n' read -r -d '' -a OPTIONS_ARRAY <<< "$CONFIG_OPTIONS"

  if [ ${#OPTIONS_ARRAY[@]} -eq 0 ]; then
    echo "No configurations found in flake.nix. Please check the file."
    exit 1
  fi

  for i in "${!OPTIONS_ARRAY[@]}"; do
    echo "  $((i+1)) - ${OPTIONS_ARRAY[$i]}"
  done

  while true; do
    read -p "[?] Choose a configuration number: " CONFIG_CHOICE < /dev/tty
    if [[ "$CONFIG_CHOICE" =~ ^[0-9]+$ ]]; then
      if [[ "$CONFIG_CHOICE" -ge 1 ]] && [[ "$CONFIG_CHOICE" -le ${#OPTIONS_ARRAY[@]} ]]; then
        FLAKE_CONFIG="${OPTIONS_ARRAY[$((CONFIG_CHOICE-1))]}"
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

run_nixos_hardware_config() {
  echo "[-] Configuring hardware for $FLAKE_CONFIG..."

  # Remove any existing hardware-configuration files
  rm -rf /mnt/etc/nixos/hosts/*
  # Generate a new hardware-configuration.nix, checking for success
  if ! nixos-generate-config --root /mnt; then
      error "nixos-generate-config failed"
      exit 1
  fi

  # Move the generated hardware-configuration.nix to the correct location
  if ! mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/"$FLAKE_CONFIG"/; then
      error "Failed to move hardware-configuration.nix"
      exit 1
  fi

  #Remove original config
  if ! rm /mnt/etc/nixos/configuration.nix; then
      error "Failed to remove old config"
      exit 1
  fi
  success "Hardware configuration complete."
}

run_nixos_flake_install(){
  # to install the chosen version:
  echo "[-] Running nixos-install with flake configuration '.#${FLAKE_CONFIG}'... "
   # Use sudo only for the installation command
  if ! nixos-install --flake ".#${FLAKE_CONFIG}" --impure; then
      error "nixos-install failed"
      exit 1
  fi
  success "NixOS installation complete."
}

print_finish(){
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

run_reboot() {
    while true; do
        read -p "[?] Have you written down the ${bold}password${normal} - continue with ${bold}REBOOT${normal} [Yes/No] " confirm
        case $confirm in
            [yY][eE][sS]*)
                echo "REBOOTING";
                sleep 1;
                # Use sudo only for reboot
                reboot
                break
                ;;
            [nN][oO]*)
                echo "Password:${bold} $INST_PASSWD ${normal}";
                ;;
            *)
                echo "Please write down your password, then reboot.";
                ;;
        esac
    done
}

# --- Main Script Execution ---

clear
print_banner

# Run the script within a nix-shell, ensuring all dependencies are present.
if ! nix-shell -p git nixUnstable neovim git diceware  --run "
  find_install_device
  setup_encryption
  run_parted
  run_cryptsetup
  run_fssetup
  run_nixos_config_setup
  ask_flake_config
  run_nixos_hardware_config
  run_nixos_flake_install
  print_finish
  run_reboot
"; then
  error "Script execution failed within nix-shell."
  exit 1
fi

exit 0 # Explicitly exit with success codeerror checking* after `mkfs.*` commands, `mount`, or `swapon`.  These are critical operations that could fail.
