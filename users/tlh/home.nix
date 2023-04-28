{ config, pkgs, lib, inputs, ... }:

let

  # Script Construction (must be included with the packages below)
  run = import ../../modules/home/bin/run.nix { inherit pkgs; };
  gita = import ../../modules/home/bin/gita.nix { inherit pkgs; };
  nux = import ../../modules/home/bin/nux.nix { inherit pkgs; };
  extract = import ../../modules/home/bin/extract.nix { inherit pkgs; };

  images-packages =
    import ../../modules/home/profiles/images/pkgs.nix { inherit pkgs; };

  desktop-packages =
    import ../../modules/home/profiles/desktop/pkgs.nix { inherit pkgs; };

  # Integrate nur within Home-Manager
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    sha256 = "0rb4dhfpcshmlyirfq5r5qwmr7r3y4di8jzpc51fww04c9qjjs47";

  }) { inherit pkgs; };

  colors = import ../../modules/home/theme/colors.nix { };
  base16-theme = import ../../modules/home/theme/base16.nix { };

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
      ln -sf "/etc/nixos/modules/home/fonts" "$HOME/.local/share/"
      chmod -R +w "$HOME/.local/share/fonts"
      fc-cache -f
      fi
  '';
  # -------------------------------------------------------------------------- #
  # Programs Imports
  imports = lib.attrValues nur.repos.rycee.hmModules ++ [
    (import ../../modules/home/programs/kitty { inherit pkgs; })
    (import ../../modules/home/programs/firefox {
      inherit pkgs config nur colors;
    })
    (import ../../modules/home/programs/vscode { inherit pkgs config; })
    (import ../../modules/home/programs/bat { inherit config; })
    (import ../../modules/home/programs/direnv { inherit config lib pkgs inputs; })
    (import ../../modules/home/programs/exa { inherit config; })
    (import ../../modules/home/programs/git { inherit config; })
    (import ../../modules/home/programs/picom { })
    (import ../../modules/home/programs/rofi { inherit pkgs config; })
    (import ../../modules/home/programs/starship)
    (import ../../modules/home/programs/default-applications { inherit lib; })
    # -------------------------------------------------------------------------- #
    # Profiles

    # gtk configuration
    (import ../../modules/home/profiles/desktop)

  ];

  xresources.extraConfig =
    import ../../modules/home/programs/xresources { inherit colors; };

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
      EDITOR = "${pkgs.neovim}/bin/nvim";
      GOPATH = "${config.home.homeDirectory}/go";
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    };
  };
}
