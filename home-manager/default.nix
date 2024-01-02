{
  config,
  pkgs,
  lib,
  flake-self,
  nixpkgs-unstable,
  ...
}:
with lib; let
  cfg = config.tlh.home-manager;
in {
  options.tlh.home-manager = {
    enable = mkEnableOption "home-manager configuration";

    profile = mkOption {
      type = types.str;
      default = "desktop";
      description = "Profile to use";
      example = "desktop";
    };

    username = mkOption {
      type = types.str;
      default = "tlh";
      description = "Main user";
      example = "lisa";
    };
  };

  config = mkIf cfg.enable {
    # DON'T set useGlobalPackages! It's not necessary in newer
    # home-manager versions and does not work with configs using
    # nixpkgs.config`
    home-manager.useUserPackages = true;

    home-manager.users."${cfg.username}" = {
      imports = [
        {
          nixpkgs.overlays = [
            flake-self.overlays.default
            (final: prev: {
              unstable = import nixpkgs-unstable {
                system = "${pkgs.system}";
                config.allowUnfree = true;
              };
            })
          ];
        }
        ./profiles/${cfg.profile}.nix
      ];
    };
  };
}
