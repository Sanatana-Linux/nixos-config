{ config, pkgs, lib, ... }:

let

  # Script Construction (must be included with the packages below)
  run = import ../../modules/home/bin/run.nix { inherit pkgs; };
  nux = import ../../modules/home/bin/nux.nix { inherit pkgs; };
  extract = import ../../modules/home/bin/extract.nix { inherit pkgs; };

  images-packages =
    import ../../modules/home/profiles/images/pkgs.nix { inherit pkgs; };

  desktop-packages =
    import ../../modules/home/profiles/desktop/pkgs.nix { inherit pkgs; };

  awesomewm-packages =
    import ../../modules/home/profiles/awesomewm/pkgs.nix { inherit pkgs; };

  # Integrate nur within Home-Manager
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    sha256 = "16rmzn230nvagwhpby1xclix3mksv8893gjypg8acjd358imrry4";

  }) { inherit pkgs; };

  colors = import ../../modules/home/theme/colors.nix { };
  base16-theme = import ../../modules/home/theme/base16.nix { };

  extra-fonts = import ../../modules/home/fonts { };

in {
  # User Name 
  home.username = "tlh";
  home.homeDirectory = "/home/tlh";
  # DO NOT CHANGE THIS apparently
  home.stateVersion = "22.05";
  # Declare Themes
  theme.base16.colors = base16-theme;

  #--------------------------------------------------#
  # Symlink Configuration Files
  xdg.configFile."BetterDiscord/themes".source = ../../configurations/bd-themes;

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
  # Enable GTK theme
  home.activation.installGTKConfig = ''
    if [ ! -d "$HOME/.themes/Jasper-Gray-Dark-Compact" ]; then
      ln -sf "/etc/nixos/modules/home/gtk/Jasper-Grey-Dark-Compact" "$HOME/.themes/"
      chmod -R +w "$HOME/.themes"
      fi
  '';
  #--------------------------------------------------#

  # -------------------------------------------------------------------------- #
  # Programs Imports
  imports = lib.attrValues nur.repos.rycee.hmModules ++ [
    (import ../../modules/home/programs/kitty { inherit pkgs; })
    (import ../../modules/home/programs/firefox {
      inherit pkgs config nur colors;
    })
    (import ../../modules/home/programs/vscode { inherit pkgs config; })
    (import ../../modules/home/programs/bat { inherit config; })
    (import ../../modules/home/programs/direnv { inherit config; })
    (import ../../modules/home/programs/exa { inherit config; })
    (import ../../modules/home/programs/git { inherit config; })
    (import ../../modules/home/programs/picom { })
    (import ../../modules/home/programs/rofi { inherit pkgs config; })
    (import ../../modules/home/programs/starship)
# -------------------------------------------------------------------------- #
    # Profiles

      # gtk configuration
    (import ../../modules/home/profiles/desktop)

    # (import ./theme/nvim { inherit colors; })
  ];

  xresources.extraConfig =
    import ../../modules/home/programs/xresources { inherit colors; };

  # -------------------------------------------------------------------------- #
  # Let Home Manager install and manage itself.
  # 
  programs.home-manager.enable = true;

  # services
  services.playerctld.enable = true;



  # editor (nvim)
  systemd.user.sessionVariables.EDITOR = "nvim";

  # bat (cat clone)
  programs.bat = {
    enable = true;
    config = {
      paging = "never";
      style = "plain";
      theme = "base16";
    };
  };

  # enable unfree packages (again, just to be sure)
  nixpkgs.config.allowUnfree = true;

  # add support for .local/bin
  home.sessionPath = [ "$HOME/.local/bin" ];

  # cursor size (again) through sessionVariables
  home.sessionVariables = {
    GTK_THEME = "Jasper-Grey-Dark-Compact";
    XCURSOR_SIZE = "48";
  };

  # import more packages to home-manager ones.
  home.packages = awesomewm-packages ++ desktop-packages ++ images-packages
    ++ (with pkgs; [
      extract
      nux
      run
      ueberzug

    ]);

}
