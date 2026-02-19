{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  environment = {
    systemPackages = with pkgs; [
      blueman
      chromium
      deja-dup
      drawing
      elementary-xfce-icon-theme
      # Firefox removed - smg user doesn't want any firefox customizations
      # and doesn't want it building from source
      # firefox
      evince
      foliate
      font-manager
      file-roller
      libqalculate
      orca
      pavucontrol
      qalculate-gtk
      wmctrl
      xclip
      xcolor
      xdo
      xdotool
      catfish
      gigolo
      orage
      xfburn
      xfce4-appfinder
      xfce4-clipman-plugin
      xfce4-cpugraph-plugin
      xfce4-dict
      xfce4-fsguard-plugin
      xfce4-genmon-plugin
      xfce4-netload-plugin
      xfce4-panel
      xfce4-pulseaudio-plugin
      xfce4-systemload-plugin
      xfce4-weather-plugin
      xfce4-whiskermenu-plugin
      xfce4-xkb-plugin
      xfdashboard
      xev
      xsel
      xtitle
      xwinmosaic
      orchis-theme
      papirus-icon-theme
      phinger-cursors
    ];
  };

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };

  security.pam.services.gdm.enableGnomeKeyring = true;

  services = {
    blueman.enable = true;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
      ];
      displayManager = {
        lightdm = {
          enable = true;
          background = ../wallpaper/monokaiprospectrum.png;
          greeters.gtk = {
            enable = true;
            theme = {
              name = "Orchis-Grey-Dark-Compact";
              package = pkgs.orchis-theme;
            };
            cursorTheme = {
              name = "Phinger Cursors (light)";
              package = pkgs.phinger-cursors;
              size = 48;
            };
            iconTheme = {
              name = "Papirus-Dark";
              package = pkgs.papirus-icon-theme;
            };
            indicators = ["~session" "~spacer"];
          };
        };
      };
      desktopManager.xfce.enable = true;
    };
  };
}
