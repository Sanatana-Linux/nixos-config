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
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        absolute-enable-right-click
        add-custom-search-engine
        auto-tab-discard
        bitwarden
        cookie-quick-manager
        copy-selection-as-markdown
        don-t-fuck-with-paste
        export-cookies-txt
        export-tabs-urls-and-titles
        firemonkey
        form-history-control
        foxytab
        gaoptout
        github-file-icons
        ipfs-companion
        istilldontcareaboutcookies
        justdeleteme
        keybase
        lexicon
        link-gopher
        lovely-forks
        markdownload
        multi-account-containers
        raindropio
        re-enable-right-click
        refined-github
        search-engines-helper
        stylebot-web
        stylus
        ublock-origin
        view-image
      ];

      settings = {
        "accessibility.tabfocus_applies_to_xul" = true; # Tab focus applies to XUL elements
        "app.normandy.enabled" = false; # Disable Normandy (remote experiments)
        "app.normandy.first_run" = false; # Disable Normandy first run
        "app.shield.optoutstudies.enabled" = false; # Disable Shield studies
        "browser.aboutConfig.showWarning" = false; # Hide about:config warning
        "browser.bookmarks.restore_default_bookmarks" = false; # Don't restore default bookmarks
        "browser.compactmode.show" = true; # Show compact mode option in UI
        "browser.ctrlTab.sortByRecentlyUsed" = true; # Ctrl+Tab sorts tabs by recent use
        "browser.discovery.enabled" = false; # Disable add-on discovery
        "browser.display.use_system_colors" = true; # Use system colors for rendering
        "browser.display.windows.non_native_menus" = 1; # Use non-native menus on Windows
        "browser.download.autohideButton" = false; # Always show download button
        "browser.download.dir" = "/home/tlh/Downloads"; # Set default download directory
        "browser.download.folderList" = 2; # Use custom download directory
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false; # Disable top stories on new tab
        "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = false; # Disable new tab wallpapers
        "browser.privatebrowsing.enable-new-indicator" = false; # Hide private browsing indicator
        "browser.proton.enabled" = true; # Enable Proton UI
        "browser.proton.places-tooltip.enabled" = true; # Enable Proton tooltips for bookmarks/history
        "browser.safebrowsing.downloads.enabled" = false; # Disable Safe Browsing for downloads
        "browser.safebrowsing.downloads.remote.block_dangerous_host" = false; # Don't block dangerous hosts
        "browser.safebrowsing.downloads.remote.block_dangerous" = false; # Don't block dangerous downloads
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false; # Don't block PUPs
        "browser.safebrowsing.downloads.remote.block_uncommon" = false; # Don't block uncommon downloads
        "browser.safebrowsing.downloads.remote.enabled" = false; # Disable remote Safe Browsing for downloads
        "browser.safebrowsing.downloads.remote.url" = false; # Disable remote Safe Browsing URL
        "browser.safebrowsing.enabled" = false; # Disable Safe Browsing
        "browser.safebrowsing.malware.enabled" = false; # Disable malware protection
        "browser.shell.checkDefaultBrowser" = false; # Don't check if Firefox is default browser
        "browser.startup.blankWindow" = false; # Don't show blank window at startup
        "browser.startup.homepage_override.mstone" = "ignore"; # Ignore homepage override milestone
        "browser.startup.page" = "0"; # Start with blank page
        "browser.startup.preXulSkeletonUI" = true; # Enable pre-XUL skeleton UI for faster startup
        "browser.tabs.hoverPreview.enabled" = true; # Enable tab hover preview
        "browser.tabs.tabmanager.enabled" = true; # Enable tab manager
        "browser.uitour.enabled" = false; # Disable UI tour
        "browser.urlbar.suggest.calculator" = true; # Enable calculator in URL bar
        "browser.urlbar.suggest.quicksuggest.sponsored" = false; # Disable sponsored suggestions
        "browser.urlbar.unitConversion.enabled" = true; # Enable unit conversion in URL bar
        "datareporting.healthreport.service.enabled" = false; # Disable health report
        "datareporting.healthreport.uploadEnabled" = false; # Disable health report upload
        "datareporting.policy.dataSubmissionEnabled" = false; # Disable data submission
        "devtools.chrome.enabled" = true; # Enable devtools for browser chrome
        "devtools.debugger.prompt-connection" = false; # Don't prompt for remote debugger connection
        "devtools.debugger.remote-enabled" = true; # Enable remote debugging
        "experiments.enabled" = false; # Disable experiments
        "experiments.manifest.uri" = ""; # Clear experiments manifest URI
        "experiments.supported" = false; # Mark experiments as unsupported
        "extensions.autoDisableScopes" = 0; # Don't auto-disable extensions
        "extensions.pocket.enabled" = false; # Disable Pocket integration
        "extensions.pocket.onSaveRecs" = false; # Disable Pocket recommendations
        "extensions.shield-recipe-client.enabled" = false; # Disable Shield recipe client
        "general.config.obscure_value" = 0; # Don't obscure config file
        "general.config.sandbox_enabled" = false; # Disable config sandbox
        "general.smoothScroll" = true; # Enable smooth scrolling
        "gfx.canvas.accelerated" = true; # Enable accelerated canvas rendering
        "gfx.webrender.all" = true; # Force-enable WebRender for all GPUs
        "gfx.webrender.enabled" = true; # Enable WebRender
        "gfx.webrender.svg-images" = true; # Enable WebRender for SVG images
        "gfx.x11-egl.force-enabled" = true; # Force-enable EGL on X11
        "layers.acceleration.force-enabled" = true; # Force-enable layer acceleration
        "layout.css.backdrop-filter.enabled" = true; # Enable backdrop-filter (acrylic blur)
        "layout.css.cached-scrollbar-styles.enabled" = false; # Disable cached scrollbar styles
        "layout.css.color-mix.enabled" = true; # Enable color-mix() CSS function
        "layout.css.font-visibility.private" = 3; # Max font visibility in private mode
        "layout.css.font-visibility.resistFingerprinting" = 3; # Max font visibility for fingerprinting resistance
        "layout.css.has-selector.enabled" = true; # Enable :has() CSS selector
        "layout.css.light-dark.enabled" = true; # Enable light/dark CSS media queries
        "layout.css.moz-document.content.enabled" = true; # Enable -moz-document in content
        "layout.css.moz-outline-radius.enabled" = true; # Enable outline-radius CSS property
        "layout.css.xul-box-display-values.content.enabled" = true; # Enable XUL box display values in content
        "layout.css.xul-display-values.content.enabled" = true; # Enable XUL display values in content
        "layout.css.xul-tree-pseudos.content.enabled" = true; # Allow stylesheets to modify XUL trees in tabs
        "loop.logDomains" = false; # Disable Loop logging
        "media.av1.enabled" = false; # Disable AV1 codec
        "media.ffmpeg.vaapi.enabled" = true; # Enable VAAPI hardware decoding via FFmpeg
        "media.hardware-video-decoding.force-enabled" = true; # Force-enable hardware video decoding
        "media.rdd-ffmpeg.enabled" = true; # Enable FFmpeg in RDD process
        "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false; # Disable PiP when switching tabs
        "network.cookie.cookieBehavior" = 1; # Allow all cookies except third-party
        "privacy.globalprivacycontrol.enabled" = true; # Enable Global Privacy Control
        "privacy.globalprivacycontrol.functionality.enabled" = true; # Enable GPC functionality
        "privacy.popups.disable_from_plugins" = 0; # Allow popups from plugins
        "sidebar.revamp" = true; # Enable sidebar revamp
        "sidebar.verticalTabs" = true; # Enable vertical tabs in sidebar
        "svg.context-properties.content.enabled" = true; # Enable SVG context properties in content
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome/userContent CSS
        "toolkit.tabbox.switchByScrolling" = false; # Disable tab switching by scrolling
        "toolkit.telemetry.archive.enabled" = false; # Disable telemetry archive
        "toolkit.telemetry.enabled" = false; # Disable telemetry
        "toolkit.telemetry.unified" = false; # Disable unified telemetry
        "ui.systemUsesDarkTheme" = 1; # Force dark theme
        "dom.webgpu.workers.enabled" = true; # Enable WebGPU in workers
        "dom.webgpu.enabled" = true; # Enable WebGPU
        "gfx.webgpu.force-enabled" = true; # Force-enable WebGPU

        "browser.tabs.allow_transparent_browser" = true; # Allow transparent browser tabs
        "widget.disable-native-theme-for-content" = true; # Disable native theme for content
        "widget.dmabuf.force-enabled" = true; # Force-enable DMABUF for buffer sharing
        "widget.gtk.rounded-bottom-corners.enabled" = true; # Enable rounded bottom corners in GTK
        "widget.non-native-theme.win.scrollbar.use-system-size" = false; # Don't use system scrollbar size on Windows
        "widget.use-xdg-desktop-portal" = true; # Use XDG desktop portal integration
        "xpinstall.signatures.required" = false; # Don't require signe extensions
      };
      search = {
        default = "google";
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@no"];
          };
          "NixOS Wiki" = {
            urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@nw"];
          };
          "Home Manager Options" = {
            urls = [{template = "https://home-manager-options.extranix.com/?query={searchTerms}";}];
            icon = "https://home-manager-options.extranix.com/images/favicon.png";
            definedAliases = ["hm"];
          };
          "Firefox Addons" = {
            urls = [{template = "https://addons.mozilla.org/en-US/firefox/search/?q={searchTerms}";}];
            icon = "https://en.wikipedia.org/wiki/File:Firefox_logo,_2017.svg";
            definedAliases = ["af"];
          };
          Searchfox = {
            urls = [{template = "https://searchfox.org/mozilla-central/search?q={searchTerms}";}];
            icon = "https://searchfox.org/favicon.ico";
            definedAliases = ["sf"];
          };
          "ddg" = {
            urls = [{template = "https://duckduckgo.com/?q={searchTerms}";}];
            icon = "https://duckduckgo.com/assets/icons/meta/DDG-icon_256x256.png";
            definedAliases = ["ddg"];
          };
          "Yandex" = {
            urls = [{template = "https://yandex.com/search/?text={searchTerms}";}];
            icon = "https://yastatic.net/s3/home/branding/favicon.ico";
            definedAliases = ["ya"];
          };
          "StartPage" = {
            urls = [{template = "https://startpage.com/search?q={searchTerms}";}];
            icon = "https://www.startpage.com/sp/cdn/images/startpage-logo-dark-new.svg";
            definedAliases = ["s"];
          };

          "Brave" = {
            urls = [{template = "https://search.brave.com/search?q={searchTerms}";}];
            icon = "https://brave.com/static-assets/images/brave-logo-dark.svg";
            definedAliases = ["b"];
          };
          "Anna's Archive" = {
            urls = [{template = "https://annas-archive.org/search?q={searchTerms}";}];
            icon = "https://annas-archive.org/favicon-32x32.png?hash=989ac03e6b8daade6d2d";
            definedAliases = ["a"];
          };
          "youtube" = {
            urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
            definedAliases = ["yt"];
          };
          "Github Users" = {
            urls = [{template = "https://github.com/search?q={searchTerms}&type=users";}];
            icon = "https://www.svgrepo.com/show/68072/github-logo-face.svg";
            definedAliases = ["gu"];
          };
          "Github Repos" = {
            urls = [{template = "https://github.com/search?q={searchTerms}&type=repositories";}];
            icon = "https://www.svgrepo.com/show/68072/github-logo-face.svg";
            definedAliases = ["gr"];
          };
          "bing".metaData.alias = "@b";
          "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
        };
      };
    };
  };
  home.file.".mozilla/firefox/${profile}/chrome" = {
    source = "${inputs.higgs-boson}";
    recursive = true;
  };
}
