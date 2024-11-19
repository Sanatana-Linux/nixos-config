{
  pkgs,
  config,
  inputs,
  ...
}: let
  # Firefox Nightly with https://github.com/MrOtherGuy/fx-autoconfig
  firefox-nightly =
    (
      inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin.override {
        extraPrefsFiles = [
          (builtins.fetchurl {
            url = "https://raw.githubusercontent.com/MrOtherGuy/fx-autoconfig/master/program/config.js";
            sha256 = "1mx679fbc4d9x4bnqajqx5a95y1lfasvf90pbqkh9sm3ch945p40";
          })
        ];
      }
    )
    .overrideAttrs (oldAttrs: {
      buildCommand =
        (oldAttrs.buildCommand or "")
        + ''
          # Find firefox dir
          firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)

          # Function to replace symlink with destination file
          replaceSymlink() {
            local symlink_path="$firefoxDir/$1"
            local target_path=$(readlink -f "$symlink_path")
            rm "$symlink_path"
            cp "$target_path" "$symlink_path"
          }

          # Copy firefox binaries
          replaceSymlink "firefox"
          replaceSymlink "firefox-bin"
        '';
    });
  profile = "tlh";
in {
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  programs.firefox = {
    enable = true;
    package = firefox-nightly;
    profiles.${profile} = {
      id = 0;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        refined-github
        ublock-origin
        bitwarden
        buster-captcha-solver
        keybase
        link-gopher
        tampermonkey
        metamask
        search-by-image
        tab-stash
        undoclosetabbutton
        view-image
        form-history-control
        foxytab
        stylus
      ];

      settings = {
        "general.smoothScroll" = true;
        "browser.compactmode.show" = true;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "extensions.autoDisableScopes" = 0;
        # Stupid Homepage Elimination
        "browser.startup.page" = "0";
        # config_prefs.js configurations
        "general.config.obscure_value" = 0;
        "general.config.sandbox_enabled" = false;
        # enable proton
        "browser.proton.enabled" = true;
        "browser.proton.places-tooltip.enabled" = true;
        # required for author sheets
        "layout.css.xul-box-display-values.content.enabled" = true;
        "layout.css.xul-display-values.content.enabled" = true;
        # required for icons with data URLs
        "svg.context-properties.content.enabled" = true;
        # required for acrylic gaussian blur
        "layout.css.backdrop-filter.enabled" = true;
        # prevent bugs that would otherwise be caused by the custom scrollbars in the user-agent sheet
        "layout.css.cached-scrollbar-styles.enabled" = false;
        # don't blind me
        "browser.startup.blankWindow" = false;
        "browser.startup.preXulSkeletonUI" = false;
        "ui.systemUsesDarkTheme" = 1;
        # svg optimizations
        "gfx.webrender.svg-images" = true;
        # allow stylesheets to modify trees in system pages viewed in regular tabs
        "layout.css.xul-tree-pseudos.content.enabled" = true;
        # allow the color-mix( CSS function
        "layout.css.color-mix.enabled" = true;
        # other CSS features
        "layout.css.moz-outline-radius.enabled" = true;
        # avoid native styling
        "browser.display.windows.non_native_menus" = 1;
        "widget.disable-native-theme-for-content" = true;
        "widget.non-native-theme.win.scrollbar.use-system-size" = false;
        # keep "all tabs" menu available at all times = useful for all tabs menu expansion pack
        "browser.tabs.tabmanager.enabled" = true;
        # Popups
        "privacy.popups.disable_from_plugins" = 0;

        # Enable Global Privacy Control functionality for Firefox
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.functionality.enabled" = true;
        # install addon from file > find the .zip file
        "xpinstall.signatures.required" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.display.use_system_colors" = false;
        "browser.privatebrowsing.enable-new-indicator" = false;

        # font settings
        "layout.css.font-visibility.private" = 3;
        "layout.css.font-visibility.resistFingerprinting" = 3;
        "app.shield.optoutstudies.enabled" = false;

        "layout.css.moz-document.content.enabled" = true;

        # enable custom userchrome
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # xul tabfocus
        "accessibility.tabfocus_applies_to_xul" = true;

        # turn off google safebrowsing (it literally sends a sha sum of everything you download to google)
        "browser.safebrowsing.downloads.remote.block_dangerous" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" =
          false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.downloads.remote.url" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        # turn off telemetry
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;

        # turn off experiments
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.discovery.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "loop.logDomains" = false;

        # iirc hides pocket stories
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

        # third party cookies
        "network.cookie.cookieBehavior" = 1;

        # default browser
        "browser.shell.checkDefaultBrowser" = false;

        # download location
        "browser.download.dir" = "/home/tlh/Downloads";
        "browser.download.folderList" = 2;
        "browser.download.autohideButton" = false;

        # Rendering
        "gfx.webrender.all" = true;
        "gfx.canvas.accelerated" = true;
        "gfx.webrender.enabled" = true;
        "gfx.x11-egl.force-enabled" = true;
        "layers.acceleration.force-enabled" = true;
        "media.av1.enabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "widget.dmabuf.force-enabled" = true;

        # Desktop Integration Linux
        "widget.use-xdg-desktop-portal" = true;

        # Disable pocket, I don't want to know how low the average IQ is
        "extensions.pocket.enabled" = false;
        "extensions.pocket.onSaveRecs" = false;
        # Mozilla Annoyances
        "app.normandy.enabled" = false;
        "app.normandy.first_run" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.uitour.enabled" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      };

      extraConfig = ''
        /*color schemes*/
        user_pref("user.theme.dark.a", true); /*default dark mode*/
        user_pref("user.theme.light.a", true); /*default light mode*/
        user_pref("user.theme.dark.catppuccin", false);
        user_pref("user.theme.dark.catppuccin-mocha", false); /*by Draff*/
        user_pref("user.theme.dark.gruvbox", false);
        user_pref("user.theme.light.gruvbox", false);
        user_pref("user.theme.dark.midnight", false);

        /*titlebar and tabs*/
        user_pref("ultima.disable.alltabs.button", true);
        user_pref("ultima.disable.windowcontrols.button", false);
        user_pref("ultima.disable.verticaltab.bar", false);
        user_pref("ultima.tabs.autohide", true);

        /*sidebar*/
        user_pref("ultima.sidebar.autohide", false);
        user_pref("ultima.sidebery.autohide", true);
        user_pref("ultima.sidebar.hidden", false);
        user_pref("ultima.sidebar.longer", true);

        /*extra theming*/
        user_pref("ultima.theme.extensions", true);
        user_pref("ultima.theme.color.swap", true);
        user_pref("ultima.theme.icons", true);
        user_pref("ultima.theme.menubar", true);

        /*url bar*/
        user_pref("ultima.urlbar.suggestions", true);
        user_pref("ultima.urlbar.centered", true);
        user_pref("ultima.urlbar.hidebuttons", false);
        user_pref("ultima.xstyle.urlbar", false);

        /*alternate styles*/
        user_pref("ultima.xstyle.containertabs.i", false);
        user_pref("ultima.xstyle.containertabs.ii", false);
        user_pref("ultima.xstyle.containertabs.iii", true);
        user_pref("ultima.xstyle.pinnedtabs.i", false);
        user_pref("ultima.xstyle.private", false);

        /*specific OS overrides (like titlebar buttons)*/
        /*user_pref("ultima.OS.kde", true);
        user_pref("ultima.OS.gnome", false);
        user_pref("ultima.OS.mac", false);
        user_pref("ultima.OS.kde.wds", false);
        user_pref("ultima.OS.gnome.wds", false);
        user_pref("ultima.OS.gnome.wdl", false);
        user_pref("ultima.OS.notitlebar", false);*/

        /*other*/
        user_pref("browser.aboutConfig.showWarning", false);
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("devtools.debugger.remote-enabled", true);
        user_pref("devtools.chrome.enabled", true);
        user_pref("devtools.debugger.prompt-connection", false);
        user_pref("svg.context-properties.content.enabled", true);
        user_pref("toolkit.tabbox.switchByScrolling", false);

        user_pref("sidebar.revamp", true);
        user_pref("sidebar.verticalTabs", true);
        user_pref("browser.tabs.hoverPreview.enabled", true);
        user_pref("browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled", false);
        user_pref("media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled", false);
      '';
    };
  };
  home.file.".mozilla/firefox/${profile}/chrome" = {
    source = "${inputs.higgs-boson}";
    recursive = true;
  };
}
