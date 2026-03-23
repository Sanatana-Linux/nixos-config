{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.programs.shotcut;
in {
  options.modules.programs.shotcut = {
    enable = mkEnableOption "Shotcut video editor with filters fix";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = let
      shotcut-wrapped = pkgs.symlinkJoin {
        name = "shotcut-wrapped";
        paths = [pkgs.stable.shotcut];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/shotcut \
            --prefix FREI0R_PATH : "${pkgs.frei0r}/lib/frei0r-1"
        '';
        meta.mainProgram = "shotcut";
      };
    in [shotcut-wrapped];
  };
}
