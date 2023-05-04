{ config, pkgs, lib, inputs, ... }:

let

  # Script Construction (must be included with the packages below)
  run = import ../../settings/home/bin/run.nix { inherit pkgs; };
  gita = import ../../settings/home/bin/gita.nix { inherit pkgs; };
  nux = import ../../settings/home/bin/nux.nix { inherit pkgs; };
  extract = import ../../settings/home/bin/extract.nix { inherit pkgs; };

  images-packages =
    import ../../settings/home/profiles/images/pkgs.nix { inherit pkgs; };

  desktop-packages =
    import ../../settings/home/profiles/desktop/pkgs.nix { inherit pkgs; };

  # Integrate nur within Home-Manager
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    sha256 = "00lpla5das5vf96588zgq001iak39kws953yszjwmbsri0cazf2a";

  }) { inherit pkgs; };

  colors = import ../../settings/home/theme/colors.nix { };
  base16-theme = import ../../settings/home/theme/base16.nix { };

in {

  # Declare Themes
  theme.base16.colors = base16-theme;

  #--------------------------------------------------#
  # Symlink Configuration Files
  #
  # Enable AwesomeWM Configuration
  home.activation.installAwesomeWMConfig = ''
    if [ ! -d "$HOME/.config/awesome" ]; then
      ln -s "/etc/nixos/configurations/awesome" "$HOME/.config/awesome"
      chmod -R +w "$HOME/.config/awesome"
    fi
  '';
  # Enable ZSH Configuration
  home.activation.installZSHConfig = ''
    if [ ! -d "$HOME/.zsh" ]; then
      ln -sf "/etc/nixos/configurations/zsh" "$HOME/.zsh"
      chmod -R +w "$HOME/.zsh"
      ln -s "$HOME/.zsh/zshenv" "$HOME/.zshenv"
    fi
  '';
  # extra fonts
  home.activation.installFontConfig = ''
    if [ ! -d "$HOME/.local/share/fonts" ]; then
      ln -sf "/etc/nixos/settings/home/fonts" "$HOME/.local/share/"
      chmod -R +w "$HOME/.local/share/fonts"
      fc-cache -f
      fi
  '';
  # -------------------------------------------------------------------------- #
  # Programs Imports
  imports = lib.attrValues nur.repos.rycee.hmModules ++ [
    (import ../../settings/home/programs/kitty { inherit pkgs; })
    (import ../../settings/home/programs/firefox {
      inherit pkgs config nur colors;
    })
    (import ../../settings/home/programs/vscode { inherit pkgs config; })
    (import ../../settings/home/programs/bat { inherit config; })
    (import ../../settings/home/programs/direnv { inherit config lib pkgs inputs; })
    (import ../../settings/home/programs/exa { inherit config; })
    (import ../../settings/home/programs/git { inherit config; })
    (import ../../settings/home/programs/picom { })
    (import ../../settings/home/programs/rofi { inherit pkgs config; })
    (import ../../settings/home/programs/starship)
    (import ../../settings/home/programs/default-applications { inherit lib; })
    # -------------------------------------------------------------------------- #
    # Profiles

    # gtk configuration
    (import ../../settings/home/profiles/desktop)

  ];

  xresources.extraConfig =
    import ../../settings/home/programs/xresources { inherit colors; };

  # -------------------------------------------------------------------------- #
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # enable unfree packages (again, just to be sure)
  nixpkgs.config.allowUnfree = true;

 nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  home = {
    username = "tlh";
    homeDirectory = "/home/tlh";
    # DO NOT CHANGE THIS apparently
    stateVersion = "22.05";
    # add support for .local/bin
    sessionPath = [ "$HOME/.local/bin" ];

    # cursor size (again) through sessionVariables

    file = {
      ".icons/default".source =
        "${pkgs.phinger-cursors}/share/icons/phinger-cursors-light";
    };

    # import more packages to home-manager ones.
    packages = desktop-packages ++ images-packages
      ++ (with pkgs; [ extract nux run gita ueberzug direnv  ]);

    sessionVariables = {
      GTK_THEME = "Colloid-Dark";
      XCURSOR_SIZE = "48";
      BROWSER = "${pkgs.firefox}/bin/firefox";
      EDITOR = "nvim";
      GOPATH = "${config.home.homeDirectory}/go";
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };
}
