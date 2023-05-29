{ config, ... }:

{
  home = {
    file = {
      ".local/bin/extract" = {
        executable = true;
        text = import ./extract.nix { };
      };
      ".local/bin/gita" = {
        executable = true;
        text = import ./gita.nix { };
      };
      ".local/bin/fetch" = {
        executable = true;
        text = import ./nixfetch.nix { };
      };
      ".local/bin/nux" = {
        executable = true;
        text = import ./nux.nix { };
      };
      ".local/bin/panes" = {
        executable = true;
        text = import ./panes.nix { };
      };
      ".local/bin/updoot" = {
        executable = true;
        text = import ./updoot.nix { };
      };
    };
  };
}