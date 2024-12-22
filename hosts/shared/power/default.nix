{
  config,
  pkgs,
  ...
}: {
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "balanced";
  };

  # Power Management
  services.tlp.enable = true;
  services.upower = {
    enable = true;
    # Adjusts the action taken at the point of the battery being critical and adjusts when that is
    #criticalPowerAction = "Hibernate";
    percentageLow = 15;
    percentageCritical = 8;
    percentageAction = 5;
    usePercentageForPolicy = true;
  };
  # handle ACPI events
  services.acpid.enable = true;
  # thermal sensors and controls
  services.thermald.enable = true;
}
