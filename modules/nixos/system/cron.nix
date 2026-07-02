{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.system.cron = {
    enable = mkEnableOption "cron daemon";

    jobs = mkOption {
      type = types.listOf (types.submodule {
        options = {
          command = mkOption {
            type = types.str;
            description = "Command to run";
          };
          schedule = mkOption {
            type = types.str;
            default = "0 6 * * 1";
            description = "Cron schedule expression (default: weekly Monday 6am)";
          };
          user = mkOption {
            type = types.str;
            default = "root";
            description = "User to run the job as";
          };
        };
      });
      default = [];
      description = "Cron jobs managed by system cron";
    };
  };

  config = mkIf config.modules.system.cron.enable {
    services.cron = {
      enable = true;
      systemCronJobs = map (job: "${job.schedule} ${job.user} ${job.command}") config.modules.system.cron.jobs;
    };
  };
}
