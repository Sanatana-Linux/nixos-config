# Declarative disk layout for Kamala (AMD desktop).
#
# Applied with disko BEFORE nixos-install:
#   nix run github:nix-community/disko/latest -- --mode disko \
#     /mnt/etc/nixos/hosts/kamala/disko.nix
#
# WARNING: this WIPES /dev/nvme0n1 and /dev/sda.
#
#   nvme0n1  ->  512M ESP (/boot/efi)  +  LUKS2 cryptroot (ext4 /)
#   sda      ->  LUKS2 cryptdata (ext4 /home/tlh/Data)
#
# Because disko owns the mount layout, generate the hardware config with
# `nixos-generate-config --root /mnt --no-filesystems` so it does not also
# declare fileSystems (which would conflict).
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
          root = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings.allowDiscards = true;
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
            settings.allowDiscards = true;
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
