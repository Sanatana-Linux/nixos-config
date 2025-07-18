# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{...}: {
  home-manager.sharedModules = [
    ({lib, ...}:
      with lib.hm.gvariant; {
        dconf.settings = {
          "org/gnome/Console" = {
            last-window-size = mkTuple [1362 743];
          };

          "org/gnome/control-center" = {
            last-panel = "info-overview";
            window-state = mkTuple [1660 882 false];
          };

          "org/gnome/desktop/app-folders/folders/Utilities" = {
            apps = ["gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop"];
            categories = ["X-GNOME-Utilities"];
            name = "X-GNOME-Utilities.directory";
            translate = true;
          };

          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
            primary-color = "#241f31";
            secondary-color = "#000000";
          };

          "org/gnome/desktop/calendar" = {
            show-weekdate = false;
          };

          "org/gnome/desktop/input-sources" = {
            show-all-sources = false;
            sources = [(mkTuple ["xkb" "gb"])];
            xkb-options = ["terminate:ctrl_alt_bksp"];
          };

          "org/gnome/desktop/interface" = {
            clock-show-date = true;
            clock-show-seconds = true;
            clock-show-weekday = true;
            color-scheme = "prefer-dark";
            cursor-size = 48;
            cursor-theme = "Phinger Cursors (light)";
            enable-animations = true;
            enable-hot-corners = false;
            font-antialiasing = "grayscale";
            font-hinting = "slight";
            gtk-theme = "Materia-dark-compact";
            icon-theme = "Papirus-Dark";
          };

          "org/gnome/desktop/notifications" = {
            application-children = ["org-gnome-tweaks"];
          };

          "org/gnome/desktop/notifications/application/org-gnome-tweaks" = {
            application-id = "org.gnome.tweaks.desktop";
          };

          "org/gnome/desktop/peripherals/tablets/056a:037a" = {
            keep-aspect = false;
          };

          "org/gnome/desktop/peripherals/touchpad" = {
            disable-while-typing = true;
            two-finger-scrolling-enabled = true;
          };

          "org/gnome/desktop/screensaver" = {
            lock-enabled = true;
            picture-options = "zoom";
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            primary-color = "#241f31";
            secondary-color = "#000000";
          };

          "org/gnome/desktop/search-providers" = {
            sort-order = ["org.gnome.Contacts.desktop" "org.gnome.Documents.desktop" "org.gnome.Nautilus.desktop"];
          };

          "org/gnome/desktop/session" = {
            idle-delay = mkUint32 300;
          };

          "org/gnome/desktop/wm/keybindings" = {
            maximize = ["<Super>Up"];
            move-to-monitor-down = ["<Super><Shift>Down"];
            move-to-monitor-left = ["<Super><Shift>Left"];
            move-to-monitor-right = ["<Super><Shift>Right"];
            move-to-monitor-up = ["<Super><Shift>Up"];
            switch-applications = ["<Super>Tab" "<Alt>Tab"];
            switch-applications-backward = ["<Shift><Super>Tab" "<Shift><Alt>Tab"];
            switch-group = ["<Super>Above_Tab" "<Alt>Above_Tab"];
            switch-group-backward = ["<Shift><Super>Above_Tab" "<Shift><Alt>Above_Tab"];
            switch-to-workspace-1 = ["<Super>Home"];
            switch-to-workspace-last = ["<Super>End"];
            switch-to-workspace-left = ["<Super>Page_Up" "<Super><Alt>Left" "<Control><Alt>Left"];
            switch-to-workspace-right = ["<Super>Page_Down" "<Super><Alt>Right" "<Control><Alt>Right"];
            unmaximize = ["<Super>Down" "<Alt>F5"];
          };

          "org/gnome/desktop/wm/preferences" = {
            auto-raise = false;
            button-layout = "close,minimize,maximize:appmenu";
            focus-mode = "sloppy";
            mouse-button-modifier = "<Super>";
            num-workspaces = 10;
            resize-with-right-button = false;
            workspace-names = ["Workspace 1" "Workspace 2" "Workspace 3" "Workspace 4" "Workspace 5" "Workspace 6" "Workspace 7" "Workspace 8" "Workspace 9" "Workspace 10"];
          };

          "org/gnome/evolution-data-server" = {
            migrated = true;
          };

          "org/gnome/gnome-system-monitor" = {
            maximized = false;
            network-total-in-bits = false;
            show-dependencies = false;
            show-whose-processes = "user";
            window-state = mkTuple [700 500 103 103];
          };

          "org/gnome/gnome-system-monitor/disktreenew" = {
            col-6-visible = true;
            col-6-width = 0;
          };

          "org/gnome/mutter" = {
            attach-modal-dialogs = true;
            edge-tiling = false;
            overlay-key = "Super_L";
            workspaces-only-on-primary = false;
          };

          "org/gnome/mutter/keybindings" = {
            cancel-input-capture = ["<Super><Shift>Escape"];
            toggle-tiled-left = ["<Super>Left"];
            toggle-tiled-right = ["<Super>Right"];
          };

          "org/gnome/mutter/wayland/keybindings" = {
            restore-shortcuts = ["<Super>Escape"];
          };

          "org/gnome/nautilus/preferences" = {
            default-folder-viewer = "icon-view";
            migrated-gtk-settings = true;
            search-filter-time-type = "last_modified";
          };

          "org/gnome/nautilus/window-state" = {
            initial-size = mkTuple [890 550];
          };

          "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = false;
            night-light-schedule-automatic = false;
            night-light-schedule-from = 0.0;
            night-light-schedule-to = 23.983333;
            night-light-temperature = mkUint32 2700;
          };
          "org/gnome/settings-daemon/plugins/power" = {
            power-button-action = "suspend";
            sleep-inactive-ac-type = "suspend";
          };

          "org/gnome/shell" = {
            disabled-extensions = ["native-window-placement@gnome-shell-extensions.gcampax.github.com" "window-list@gnome-shell-extensions.gcampax.github.com" "windowsNavigator@gnome-shell-extensions.gcampax.github.com"];
            enabled-extensions = ["apps-menu@gnome-shell-extensions.gcampax.github.com" "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
            favorite-apps = ["org.gnome.Settings.desktop" "org.gnome.Nautilus.desktop" "gnome-system-monitor.desktop" "firefox.desktop" "Alacritty.desktop" "org.gnome.Console.desktop"];
            last-selected-power-profile = "performance";
            welcome-dialog-last-shown-version = "45.4";
          };

          "org/gnome/shell/extensions/dash-to-panel" = {
            available-monitors = [0 1];
            primary-monitor = 0;
          };

          "org/gnome/shell/extensions/just-perfection" = {
            accessibility-menu = true;
            background-menu = true;
            controls-manager-spacing-size = 0;
            dash = true;
            dash-icon-size = 0;
            double-super-to-appgrid = true;
            osd = true;
            panel = true;
            panel-in-overview = true;
            ripple-box = true;
            search = true;
            show-apps-button = true;
            startup-status = 1;
            theme = true;
            window-demands-attention-focus = false;
            window-picker-icon = true;
            window-preview-caption = true;
            window-preview-close-button = true;
            workspace = true;
            workspace-background-corner-size = 0;
            workspace-popup = true;
            workspaces-in-app-grid = true;
          };

          "org/gnome/shell/keybindings" = {
            focus-active-notification = ["<Super>n"];
            shift-overview-down = ["<Super><Alt>Down"];
            shift-overview-up = ["<Super><Alt>Up"];
          };

          "org/gnome/tweaks" = {
            show-extensions-notice = false;
          };
        };
      })
  ];
}
