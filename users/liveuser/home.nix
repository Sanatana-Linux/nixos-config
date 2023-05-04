{ config, pkgs, lib, ... }:

let

  # Script Construction (must be included with the packages below)
  run = import ../../settings/home/bin/run.nix { inherit pkgs; };
  nux = import ../../settings/home/bin/nux.nix { inherit pkgs; };
  extract = import ../../settings/home/bin/extract.nix { inherit pkgs; };

  # Integrate nur within Home-Manager
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    sha256 = "00lpla5das5vf96588zgq001iak39kws953yszjwmbsri0cazf2a";

  }) { inherit pkgs; };

  colors = import ../../settings/home/theme/colors.nix { };
  base16-theme = import ../../settings/home/theme/base16.nix { };

  extra-fonts = import ../../settings/home/fonts { };

in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "liveuser";
  home.homeDirectory = "/home/liveuser";

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # link some configuration files
  xdg.configFile."BetterDiscord/themes".source = ../../configurations/bd-themes;

  # enable awesomewm
  home.activation.installAwesomeWMConfig = ''
    if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
      ln -s "/etc/nixos/configurations/awesome" "${config.home.homeDirectory}/.config/awesome" 
    fi

  '';
  # enable zsh
  home.activation.installZSHConfig = ''
    if [ ! -d "${config.home.homeDirectory}/.zsh" ]; then
      ln -s "/etc/nixos/configurations/zsh" "${config.home.homeDirectory}/.zsh" 
      ln -s "${config.home.homeDirectory}/.zsh/zshenv" "${config.home.homeDirectory}/.zshenv"
    fi

  '';
 


  theme.base16.colors = base16-theme;

  imports = lib.attrValues nur.repos.rycee.hmModules ++ [
    (import ../../settings/home/programs/kitty { inherit pkgs; })
    (import ../../settings/home/programs/firefox { inherit pkgs config nur colors; })
    (import ../../settings/home/programs/bat { inherit config; })
    (import ../../settings/home/programs/exa { inherit config; })
    (import ../../settings/home/programs/git { inherit config; })
    (import ../../settings/home/programs/picom { })
    (import ../../settings/home/programs/rofi { inherit pkgs config; })
    (import ../../settings/home/programs/starship)
    (import ../../settings/home/programs/zathura)
    #(import ../../settings/home/programs/xresources)
    # (import ./theme/nvim { inherit colors; })
  ];
  xresources.extraConfig = import ../../settings/home/programs/xresources { inherit colors; };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # font-config
  fonts.fontconfig.enable = true;

  # services
  services.playerctld.enable = true;

  # gtk configuration
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    iconTheme.name = "Colloid-dark";
    theme.name = "Colloid-Dark";
  };

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

  # enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # add support for .local/bin
  home.sessionPath = [ "$HOME/.local/bin" ];

  # cursor size (again) through sessionVariables
  home.sessionVariables = {
    GTK_THEME = "Jasper-Grey-Dark-Compact";
    XCURSOR_SIZE = "48";
  };

  # import more packages to home-manager ones.
  home.packages = with pkgs; [
    cairo
    cairomm
    dconf
    feh
    sysz
    extract
    giph
    goocanvas3
    gtk_engines
    imv
    inotify-tools
    jq
    gobject-introspection-unwrapped
    libcanberra-gtk3
    
    maim
    mesa
    neofetch
    networkmanagerapplet
    nux
    pango
    pangomm
    run
    wirelesstools
    xclip
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.xfce4-settings
    xfce.xfconf
    go
    xterm
    ueberzug
  ];
}
