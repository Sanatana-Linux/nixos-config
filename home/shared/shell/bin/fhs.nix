{pkgs, ...}: {
  environment.systemPackages = [
    (let
      base = pkgs.appimageTools.defaultFhsEnvArgs;
    in
      pkgs.buildFHSUserEnv (base
        // {
          name = "fhs";
          targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
          profile = "export FHS=1";
          runScript = "zsh";
          extraOutputsToInstall = ["dev"];
        }))
  ];
}
