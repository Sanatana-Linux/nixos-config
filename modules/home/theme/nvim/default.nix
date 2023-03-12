{ colors }:

let
  nvim-theme = import ./theme.nix { inherit colors; };
in {
  xdg.configFile.nvim.source = ../../../../configurations/nvim;
  xdg.configFile."nvim-colors.lua".text = nvim-theme;
}