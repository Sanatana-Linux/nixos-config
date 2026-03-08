{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.printer.brother;
in {
  options.modules.printer.brother = {
    enable = mkEnableOption "Brother laser printer support with CUPS";

    drivers = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        brlaser
      ];
      description = "Brother printer drivers to install (defaults to brlaser for Brother laser printers)";
    };

    user = mkOption {
      type = types.str;
      default = "smg";
      description = "User to add to printer groups (lp, scanner)";
    };

    enableAvahi = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Avahi for network printer discovery";
    };
  };

  config = mkIf cfg.enable {
    # Enable CUPS printing service
    services.printing = {
      enable = true;
      drivers = cfg.drivers;
    };

    # Enable network printer discovery
    services.avahi = mkIf cfg.enableAvahi {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Add user to printer groups
    users.users.${cfg.user}.extraGroups = ["lp" "scanner"];
  };
}
