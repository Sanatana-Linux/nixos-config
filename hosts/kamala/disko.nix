# Declarative disk layout for Kamala (AMD desktop).
#
# Applied with disko BEFORE nixos-install:
#   nix run github:nix-community/disko/latest -- --mode disko \
#     /etc/nixos/hosts/kamala/disko.nix
#
# WARNING: this WIPES /dev/nvme0n1 and /dev/sda.
#
#   nvme0n1  ->  512M ESP (/boot/efi) + 1G plaintext /boot + LUKS2 root (ext4 /)
#   sda      ->  LUKS2 data (ext4 /home/tlh/Data)
#
# /boot is deliberately a plaintext partition so GRUB can load the kernel and
# initrd WITHOUT cryptomounting the root — no GRUB passphrase prompt. The root
# and data volumes are LUKS2 and are unlocked in the (systemd) initrd via TPM2
# (crypttabExtraOpts = tpm2-device=auto), enrolled with `systemd-cryptenroll`
# after install. That yields ZERO passphrase prompts at boot. If the TPM2
# enrollment is absent, both fall back to a single passphrase prompt each.
#
# Because disko owns the mount layout, generate the hardware config with
# `nixos-generate-config --root /mnt --no-filesystems`.
{
  disko.devices.disk = {
    nvme = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = ["fmask=0022" "dmask=0022"];
            };
          };
          boot = {
            size = "1G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/boot";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings = {
                allowDiscards = true;
                crypttabExtraOpts = ["tpm2-device=auto"];
              };
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };

    sda = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions.data = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptdata";
            settings = {
              allowDiscards = true;
              crypttabExtraOpts = ["tpm2-device=auto"];
            };
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home/tlh/Data";
            };
          };
        };
      };
    };
  };
}
