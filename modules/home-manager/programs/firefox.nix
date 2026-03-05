{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  options.modules.programs.firefox = {
    enable = mkEnableOption "Firefox browser with extensions";
    higgs-boson = mkEnableOption "Enable higgs-boson Firefox customizations (tlh user on bagalamukhi only)";
    defaultBrowser = mkOption {
      type = types.bool;
      default = true;
      description = "Set Firefox as the default browser";
    };
  };

  config = mkIf config.modules.programs.firefox.enable (mkMerge [
    {
      home.sessionVariables = {
        MOZ_USE_XINPUT2 = "1";
        MOZ_DISABLE_RDD_SANDBOX = "1";
      };

      xdg.mimeApps = mkIf config.modules.programs.firefox.defaultBrowser {
        enable = true;
        defaultApplications = {
          "text/html" = ["firefox.desktop"];
          "text/xml" = ["firefox.desktop"];
          "x-scheme-handler/http" = ["firefox.desktop"];
          "x-scheme-handler/https" = ["firefox.desktop"];
        };
      };

      programs.firefox = let
        firefox-custom =
          (
            pkgs.firefox.override {
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
                          # Find firefox Dir
                          firefoxDir=$(find "$out/lib/" -type d -name 'firefox*' -print -quit)

                          # Function to replace symlink with destination file
                          replaceSymlink() {
                            local symlink_path="$firefoxDir/$1"
                            local target_path=$(readlink -f "$symlink_path")
                            rm "$symlink_path"
                            cp "$target_path" "$symlink_path"
                          }

                          # Copy firefox binaries
                #          replaceSymlink "firefox"
                #          replaceSymlink "firefox-bin"
              '';
          });
        profile = config.home.username;
      in {
        enable = true;
        package = firefox-custom;
        profiles.${profile} = {
          id = 0;
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            about-sync
            absolute-enable-right-click
            add-custom-search-engine
            auto-referer
            auto-tab-discard
            bitwarden
            chrome-mask
            cookie-quick-manager
            copy-selection-as-markdown
            don-t-fuck-with-paste
            export-cookies-txt
            export-tabs-urls-and-titles
            firemonkey
            form-history-control
            foxytab
            gaoptout
            ipfs-companion
            istilldontcareaboutcookies
            justdeleteme
            link-gopher
            markdownload
            multi-account-containers
            multiple-tab-handler
            overview
            persistentpin
            raindropio
            refined-github
            tab-stash
            ublock-origin
            view-image
          ];

          settings = {
            "security.allow_unsafe_dangerous_privileged_evil_eval" = true;
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
            "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
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
            "browser.dom.window.dump.enabled" = true;
            "experiments.enabled" = true;
            "experiments.supported" = true;
            "extensions.autoDisableScopes" = 0;
            "extensions.pocket.enabled" = false;
            "extensions.pocket.onSaveRecs" = false;
            "extensions.shield-recipe-client.enabled" = false;
            "general.config.filename" = "mozilla.cfg";
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
            "layout.css.light-dark.enabled" = true;
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
            "privacy.resistFingerprinting" = false;
            "sidebar.revamp" = true;
            "sidebar.verticalTabs" = true;
            "svg.context-properties.content.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "toolkit.tabbox.switchByScrolling" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "ui.systemUsesDarkTheme" = 1;
            "dom.webgpu.workers.enabled" = true;
            "dom.webgpu.enabled" = true;
            "gfx.webgpu.force-enabled" = true;
            "widget.dmabuf.force-enabled" = true;
            "widget.gtk.rounded-bottom-corners.enabled" = true;
            "widget.content.gtk-theme-override" = "Materia-Dark-Compact";
            "widget.non-native-theme.win.scrollbar.use-system-size" = false;
            "widget.use-xdg-desktop-portal" = true;
            "xpinstall.signatures.required" = false;
            "extensions.webextensions.restrictedDomains" = " ";
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
                updateInterval = 24 * 60 * 60 * 1000;
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
              "google".metaData.alias = "@g";
            };
          };
        };
      };
    }

    # Higgs-boson customizations
    (mkIf config.modules.programs.firefox.higgs-boson {
      # Use higgs-boson for customizations but override utils with latest fx-autoconfig
      home.file.".mozilla/firefox/${config.home.username}/chrome" = {
        source = "${inputs.higgs-boson}";
        recursive = true;
      };

      # Override utils directory with latest fx-autoconfig to fix Firefox 147 compatibility
      home.file.".mozilla/firefox/${config.home.username}/chrome/utils" = {
        source = "${inputs.fx-autoconfig}/profile/chrome/utils";
        recursive = true;
        force = true;
      };

      # higgs-boson specific Firefox settings that must be injected into the profile
      programs.firefox.profiles.${config.home.username}.settings = {
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
      };
    })
  ]);
}
