{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.tlh.programs.htop;
in {
  options.tlh.programs.htop.enable = mkEnableOption "enable htop";

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;
      settings = {
        cpu_count_from_one = 1;
        show_cpu_usage = true;
        show_program_path = true;
        fields = with config.lib.htop.fields; [
          PID
          USER
          M_RESIDENT
          M_SHARE
          PERCENT_CPU
          PERCENT_MEM
          TIME
          COMM
        ];
      };
    };
  };
}
