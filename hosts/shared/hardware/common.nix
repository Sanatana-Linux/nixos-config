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
    ];
  };
}
