# Declarative disk layout for matangi (Sara's Lenovo Legion Pro).
#
# NOT applied to the running install — kept for future clean installs:
#   nix run github:nix-community/disko/latest -- --mode disko \
#     /etc/nixos/hosts/matangi/disko.nix
#
# Identical arrangement to bagalamukhi (two 1TB NVMe).
#
# WARNING: WIPES BOTH 1TB NVMe drives.
#
#   nvme0n1 (OS)    -> 1G ESP (/boot/efi) + 2G plaintext /boot + LUKS2 ext4 /
#   nvme1n1 (Data)  -> LUKS2 ext4 /home/smg/Data
#
# Single unlock at boot: /boot is plaintext so GRUB never cryptomounts, and
# both LUKS2 volumes share ONE passphrase (passwordFile) that is then bound to
# the platform TPM2 (Intel PTT) with systemd-cryptenroll:
#
#   systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme0n1p3
#   systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/nvme1n1p1
#
# Until enrolled, the passphrase is the fallback.
#
# NOTE: this layout moves the ESP to /boot/efi and adds a separate /boot
# partition, whereas matangi's current config sets `boot.efiMountPoint = "/boot"`.
# Before installing with this file, change hosts/matangi/default.nix to
# `boot.efiMountPoint = "/boot/efi"` (or omit it — that is the default) and add
# `boot.initrd.systemd.tpm2.enable = true;`.
#
# Create the shared passphrase file before running disko:
#   printf '%s' 'PASSPHRASE' > /root/luks.key && chmod 600 /root/luks.key
{
  disko.devices.disk = {
    system = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = ["fmask=0022" "dmask=0022"];
            };
          };
          boot = {
            size = "2G";
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
              passwordFile = "/root/luks.key";
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

    data = {
      type = "disk";
      device = "/dev/nvme1n1";
      content = {
        type = "gpt";
        partitions.data = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptdata";
            passwordFile = "/root/luks.key";
            settings = {
              allowDiscards = true;
              crypttabExtraOpts = ["tpm2-device=auto"];
            };
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home/smg/Data";
            };
          };
        };
      };
    };
  };
}
