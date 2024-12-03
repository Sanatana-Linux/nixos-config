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
        auto-sort-bookmarks
        export-tabs-urls-and-titles
        firefox-translations
        form-history-control
        bitwarden
        buster-captcha-solver
        keybase
        link-gopher
        tampermonkey
        metamask
        search-by-image
        undoclosetabbutton
        view-image
        form-history-control
        foxytab
        stylus
      ];

      settings = {
        "accessibility.tabfocus_applies_to_xul" = true;
        "app.normandy.enabled" = false;
        "app.normandy.first_run" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.aboutConfig.showWarning" = false;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.compactmode.show" = true;
        "browser.ctrlTab.sortByRecentlyUsed" = true;
        "browser.discovery.enabled" = false;
        "browser.display.use_system_colors" = true;
        "browser.display.windows.non_native_menus" = 1;
        "browser.download.autohideButton" = false;
        "browser.download.dir" = "/home/tlh/Downloads";
        "browser.download.folderList" = 2;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = false;
        "browser.privatebrowsing.enable-new-indicator" = false;
        "browser.proton.enabled" = true;
        "browser.proton.places-tooltip.enabled" = true;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
        "browser.safebrowsing.downloads.remote.block_dangerous" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.url" = false;
        "browser.safebrowsing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.startup.blankWindow" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.startup.page" = "0";
        "browser.startup.preXulSkeletonUI" = true;
        "browser.tabs.hoverPreview.enabled" = true;
        "browser.tabs.tabmanager.enabled" = true;
        "browser.uitour.enabled" = false;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.unitConversion.enabled" = true;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "devtools.chrome.enabled" = true;
        "devtools.debugger.prompt-connection" = false;
        "devtools.debugger.remote-enabled" = true;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "experiments.supported" = false;
        "extensions.autoDisableScopes" = 0;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.onSaveRecs" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "general.config.obscure_value" = 0;
        "general.config.sandbox_enabled" = false;
        "general.smoothScroll" = true;
        "gfx.canvas.accelerated" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.enabled" = true;
        "gfx.webrender.svg-images" = true;
        "gfx.x11-egl.force-enabled" = true;
        "layers.acceleration.force-enabled" = true;
        "layout.css.backdrop-filter.enabled" = true;
        "layout.css.cached-scrollbar-styles.enabled" = false;
        "layout.css.color-mix.enabled" = true;
        "layout.css.font-visibility.private" = 3;
        "layout.css.font-visibility.resistFingerprinting" = 3;
        "layout.css.has-selector.enabled" = true;
        "layout.css.moz-document.content.enabled" = true;
        "layout.css.moz-outline-radius.enabled" = true;
        "layout.css.xul-box-display-values.content.enabled" = true;
        "layout.css.xul-display-values.content.enabled" = true;
        "layout.css.xul-tree-pseudos.content.enabled" = true;
        "loop.logDomains" = false;
        "media.av1.enabled" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;
        "network.cookie.cookieBehavior" = 1;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.globalprivacycontrol.functionality.enabled" = true;
        "privacy.popups.disable_from_plugins" = 0;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "toolkit.tabbox.switchByScrolling" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "ui.systemUsesDarkTheme" = 1;
        "higgs-boson.disable.verticaltab.bar" = false;

        "higgs-boson.disable.windowcontrols.button" = true;
        "higgs-boson.OS.gnome.wdl" = true;
        "higgs-boson.OS.gnome.wds" = true;
        "higgs-boson.OS.gnome" = true;
        "higgs-boson.OS.notitlebar" = true;
        "higgs-boson.sidebar.autohide" = true;
        "higgs-boson.sidebar.hidden" = false;
        "higgs-boson.sidebar.longer" = true;

        "higgs-boson.tabs.autohide" = true;
        "higgs-boson.theme.color.swap" = true;
        "higgs-boson.theme.extensions" = true;
        "higgs-boson.theme.icons" = true;
        "higgs-boson.theme.menubar" = true;
        "higgs-boson.urlbar.centered" = true;
        "higgs-boson.urlbar.hidebuttons" = false;
        "higgs-boson.urlbar.suggestions" = true;
        "higgs-boson.xstyle.containertabs.i" = false;
        "higgs-boson.xstyle.containertabs.ii" = false;
        "higgs-boson.xstyle.containertabs.iii" = true;
        "higgs-boson.xstyle.pinnedtabs.i" = true;
        "higgs-boson.xstyle.private" = true;
        "higgs-boson.xstyle.urlbar" = true;
        "user.theme.dark.a" = true;
        "user.theme.dark.catppuccin-mocha" = false;
        "user.theme.dark.catppuccin" = false;
        "user.theme.dark.gruvbox" = false;
        "user.theme.dark.midnight" = false;
        "user.theme.light.a" = false;
        "user.theme.light.gruvbox" = false;
        "widget.disable-native-theme-for-content" = true;
        "widget.dmabuf.force-enabled" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "widget.non-native-theme.win.scrollbar.use-system-size" = false;
        "widget.use-xdg-desktop-portal" = true;
        "xpinstall.signatures.required" = false;
      };
    };
  };
  home.file.".mozilla/firefox/${profile}/chrome" = {
    source = "${inputs.higgs-boson}";
    recursive = true;
  };
}
