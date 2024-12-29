{
  pkgs,
  config,
  ...
}: {
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    acpilight.enable = true;
    firmware = with pkgs; [
      linux-firmware
      firmwareLinuxNonfree
    ];
  };# end hardware

  environment.systemPackages = with pkgs; [
      tpm-tools
      tpm2-tools
      tpmmanager
      tpm2-tss
      udevil
      udisks
      udiskie
      usbutils
      wirelesstools
      solaar
      pciutils
      dmidecode
  ];
}
