# Declarative disk layout for Kamala (AMD desktop).
#
#   nix run github:nix-community/disko/latest -- --mode disko \
#     /etc/nixos/hosts/kamala/disko.nix
#
# WARNING: this WIPES /dev/nvme0n1 and /dev/sda.
#
#   nvme0n1  ->  512M ESP (/boot/efi) + 1G plaintext /boot + LUKS2 root (ext4 /)
#   sda      ->  LUKS2 data (ext4 /home/tlh/Data)
#
# BOTH LUKS volumes are formatted from the SAME passphrase file
# (/root/luks.key) so disko asks for NOTHING and the two share one password.
# Create it on the live ISO before running disko:
#
#   printf '%s' 'YOUR-PASSPHRASE' > /root/luks.key && chmod 600 /root/luks.key
#
# At boot the volumes unlock automatically via TPM2 (crypttabExtraOpts =
# tpm2-device=auto) once enrolled with `systemd-cryptenroll`; until then the
# initrd falls back to prompting for the passphrase.
#
# disko owns the mount layout, so generate the hardware config with:
#   nixos-generate-config --root /mnt --no-filesystems
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
            passwordFile = "/root/luks.key";
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

    # Second NVMe holds the container image store so large docker/comfyui
    # images stop competing with / and /nix on the root disk. Unlocks from the
    # keyfile copied into the initrd by boot.initrd.secrets (see default.nix),
    # so it never prompts.
    nvme1 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_500GB_S5H7NS0N545721D";
      content = {
        type = "gpt";
        partitions.containers = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptcontainers";
            settings = {
              allowDiscards = true;
              keyFile = "/etc/cryptkeys/luks.key";
            };
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/var/lib/containerd";
            };
          };
        };
      };
    };
  };
}
