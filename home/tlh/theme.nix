{
  pkgs,
  config,
  ...
}: {
  modules.theme = {
    enable = true;

    fonts = {
      packages = with pkgs; [
        colloid-icon-theme
        emacs-all-the-icons-fonts
      ];
      serif = ["OperatorUltra Nerd Font Propo" "FreeSerif"];
      sansSerif = ["OperatorUltra Nerd Font Propo" "Ubuntu Nerd Font Medium"];
      monospace = ["Operator Mono Lig" "Ubuntu Nerd Font Mono"];
      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 12;
      };
    };

    gtk = {
      theme = {
        name = "Skeuos-Grey-Dark";
        package = pkgs.skeuos-gtk;
      };
      iconTheme = {
        name = "Colloid-Dark";
        package = pkgs.colloid-icon-theme;
      };
    };

    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 48;
    };
  };
}
