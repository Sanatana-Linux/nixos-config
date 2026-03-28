# Justfile for NixOS VM management and common tasks

# Default: list available recipes
default:
    @just --list

# Run a VM from a live ISO using qemu-system-x86_64 with KVM acceleration
# Usage: just vm-iso /path/to/live.iso
vm-iso path:
    #!/usr/bin/env bash
    set -e
    
    ISO_PATH="$(realpath "{{path}}")"
    ISO_NAME="$(basename "$ISO_PATH" .iso)"
    VM_DIR="$HOME/Data/VM_Storage/QCOW_Disk_Images/"
    
    mkdir -p "$VM_DIR"
    
    # Create disk image if it doesn't exist
    if [ ! -f "$VM_DIR/${ISO_NAME}.qcow2" ]; then
        echo "Creating disk image: $VM_DIR/${ISO_NAME}.qcow2"
        qemu-img create -f qcow2 "$VM_DIR/${ISO_NAME}.qcow2" 40G
    fi
    
    echo "Starting VM with ISO: $ISO_NAME"
    echo "Path: $ISO_PATH"
    
    qemu-system-x86_64 \
        -enable-kvm \
        -cpu host \
        -smp 4 \
        -m 4G \
        -cdrom "$ISO_PATH" \
        -boot d \
        -drive file="$VM_DIR/${ISO_NAME}.qcow2,format=qcow2,if=virtio" \
        -netdev user,id=net0,hostfwd=tcp::2222-:22 \
        -device virtio-net-pci,netdev=net0 \
        -vga virtio \
        -display gtk

# Run a VM with UEFI firmware (OVMF)
# Usage: just vm-uefi /path/to/live.iso
vm-uefi path:
    #!/usr/bin/env bash
    set -e
    
    ISO_PATH="$(realpath "{{path}}")"
    ISO_NAME="$(basename "$ISO_PATH" .iso)"
    VM_DIR="$HOME/VMs"
    
    mkdir -p "$VM_DIR"
    
    # Create disk image if it doesn't exist
    if [ ! -f "$VM_DIR/${ISO_NAME}.qcow2" ]; then
        echo "Creating disk image: $VM_DIR/${ISO_NAME}.qcow2"
        qemu-img create -f qcow2 "$VM_DIR/${ISO_NAME}.qcow2" 40G
    fi
    
    echo "Starting UEFI VM with ISO: $ISO_NAME"
    echo "Path: $ISO_PATH"
    
    qemu-system-x86_64 \
        -enable-kvm \
        -cpu host \
        -smp 4 \
        -m 4G \
        -bios /run/libvirt/nix-ovmf/OVMF_CODE.fd \
        -cdrom "$ISO_PATH" \
        -boot d \
        -drive file="$VM_DIR/${ISO_NAME}.qcow2,format=qcow2,if=virtio" \
        -netdev user,id=net0,hostfwd=tcp::2222-:22 \
        -device virtio-net-pci,netdev=net0 \
        -vga virtio \
        -display gtk

# Create a new qcow2 disk image for a VM
# Usage: just vm-disk vmname 40G
vm-disk name size="40G":
    #!/usr/bin/env bash
    VM_DIR="$HOME/VMs"
    mkdir -p "$VM_DIR"
    qemu-img create -f qcow2 "$VM_DIR/{{name}}.qcow2" {{size}}
    echo "Created: $VM_DIR/{{name}}.qcow2"

# Quick VM with minimal config (no persistent disk)
# Usage: just vm-quick /path/to/live.iso
vm-quick path:
    qemu-system-x86_64 \
        -enable-kvm \
        -m 2G \
        -cdrom "{{path}}" \
        -boot d \
        -vga virtio \
        -display gtk

# Run a raw disk image (.img) as a bootable drive
# Usage: just vm-img /path/to/disk.img
# Optional: just vm-img /path/to/disk.img 8G
vm-img path memory="4G":
    #!/usr/bin/env bash
    set -e
    
    IMG_PATH="$(realpath "{{path}}")"
    IMG_NAME="$(basename "$IMG_PATH" .img)"
    
    echo "Starting VM from image: $IMG_NAME"
    echo "Path: $IMG_PATH"
    echo "Memory: {{memory}}"
    
    qemu-system-x86_64 \
        -enable-kvm \
        -cpu host \
        -smp 4 \
        -m {{memory}} \
        -drive file="$IMG_PATH,format=raw,if=virtio" \
        -netdev user,id=net0,hostfwd=tcp::2222-:22 \
        -device virtio-net-pci,netdev=net0 \
        -vga virtio \
        -display gtk

# Run a raw disk image with UEFI firmware
# Usage: just vm-img-uefi /path/to/disk.img
# Optional: just vm-img-uefi /path/to/disk.img 8G
vm-img-uefi path memory="4G":
    #!/usr/bin/env bash
    set -e
    
    IMG_PATH="$(realpath "{{path}}")"
    IMG_NAME="$(basename "$IMG_PATH" .img)"
    
    echo "Starting UEFI VM from image: $IMG_NAME"
    echo "Path: $IMG_PATH"
    echo "Memory: {{memory}}"
    
    qemu-system-x86_64 \
        -enable-kvm \
        -cpu host \
        -smp 4 \
        -m {{memory}} \
        -bios /run/libvirt/nix-ovmf/OVMF_CODE.fd \
        -drive file="$IMG_PATH,format=raw,if=virtio" \
        -netdev user,id=net0,hostfwd=tcp::2222-:22 \
        -device virtio-net-pci,netdev=net0 \
        -vga virtio \
        -display gtk

# SSH into a running VM (requires SSH server on guest, port 2222 forwarded)
vm-ssh:
    ssh -p 2222 localhost
