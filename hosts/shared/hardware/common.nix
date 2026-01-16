{
  pkgs,
  config,
  ...
}: {
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    i2c.enable = true;

    acpilight.enable = true;
    firmware = with pkgs; [
      linux-firmware
    ];
  }; # end hardware

  environment.systemPackages = with pkgs; [
    tpm-tools
    tpm2-tools
    tpmmanager
    tpm2-tss
    udisks
    udiskie
    usbutils
    wirelesstools
    solaar
    pciutils
    dmidecode
  ];
}
