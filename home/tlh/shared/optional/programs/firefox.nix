{ config
, pkgs
, ...
}: {
  home.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  programs.firefox = {
    enable = true;
    profiles = {
      tlh = {
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
          form-history-control
          foxytab
          stylus
        ];

        settings = {
          "general.smoothScroll" = true;
          "browser.compactmode.show" = true;
          "browser.ctrlTab.sortByRecentlyUsed" = true;

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
          "app.shield.optoutstudies.enabled" = false;
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

        userChrome = ''
                      @import "${pkgs.firefox-gnome-theme}/share/firefox-gnome-theme/userChrome.css";
           ::-moz-selection { /* Code for Firefox */
            color: #202020 !important;
            background: #5ad4e6
!important;
            }
            ::selection {
          color: #202020 !important;
            background:#5ad4e6 !important;
            }

            /* remove maximum/minimum width restriction of sidebar to create tab tiling... sort of */
            #sidebar-box {
            max-width: none !important;
            min-width: 30% !important;
            }
            #alltabs-button{
              display: inline !important;
              position: relative !important;
                visibility: visible !important;
            }
        '';

        userContent = ''
                    @import "${pkgs.firefox-gnome-theme}/share/firefox-gnome-theme/userContent.css";
                    @-moz-document url-prefix("chrome://mozapps/content/extensions/aboutaddons.html"), url("about:addons"){
          // Add Ons Page
          //----------------------------------------------//
            :root{  overflow-x: hidden } /* Remove this if it causes horizontal scrolling problems */

            @media (min-width:720px){
              #main{ max-width: unset !important; padding-right: 28px; }
              addon-list > section,
              recommended-addon-list{
                padding: 1em;
                display: grid;
                grid-template-areas: "hd hd" "cd cd";
                grid-auto-columns: 1fr;
                column-gap: 1em;
                height: 6rem !important
                minimum-height:6rem !important
                maxmium-height: 6rem !important

              }

              addon-card .card-contents{ width: unset !important; white-space: initial !important; }

              .card-heading-image{ max-width: calc(100% + 32px) }
              section > h2{ grid-area: hd }
              addon-card{
                padding-bottom: 0px !important;
                padding-top: 0px !important;
                grid-area: auto;
                height: 6rem !important;
                minimum-height:6rem !important;
                maxmium-height: 6rem !important;

              }
              addon-card .addon-description{ max-height: 3em; scrollbar-width: thin; }
            }

            @media (min-width:1220px){
              addon-list > section,
              recommended-addon-list{
                grid-template-areas: "hd hd hd" "cd cd cd";
              }
            }

            @media (min-width:1720px){
              addon-list > section,
              recommended-addon-list{
                grid-template-areas: "hd hd hd hd" "cd cd cd cd";
              }
            }
          }
          // Compact Add Ons Page
          //----------------------------------------------//
          @-moz-document url-prefix("chrome://mozapps/content/extensions/aboutaddons.html"), url("about:addons"){

            :root{ overflow-x: hidden } /* Remove this if it causes horizontal scrolling problems */

            @media (min-width:420px){
              #main{ max-width: unset !important; padding-right: 28px; }
              addon-list > section{
                padding: 1em;
                display: grid;
                grid-template-areas: "hd hd" "cd cd";
                grid-auto-columns: 1fr;
                column-gap: 1em;
              }

              addon-card .card-contents{ width: unset !important; white-space: initial !important; }

              addon-list[type="extension"] .addon-name-container{
                display: grid !important;
                grid-template-areas: "name opt" "name toggle" "name badge";
                grid-row-gap: 1em;
                grid-auto-columns: 1fr 24px;
              }
              .addon-icon{ align-self: center }
              .addon-name-container > .addon-name{ grid-area: name }
              .addon-name-container > .toggle-button{ grid-area: toggle }
              .addon-name-container > .more-options-button{ grid-area: opt }
              .addon-name-container > .addon-badge{ grid-area: badge }

              addon-list[type="extension"] .more-options-button{
                margin-inline: 0 !important;
              }

              .card-heading-image{
                max-width: calc(100% + 32px);
                object-position: left;
              }

              section > h2{ grid-area: hd }
              addon-card{
                padding-bottom: 0px !important;
                padding-top: 0px !important;
                grid-area: auto;
              }

              addon-card .addon-description{
                max-height: 3em;
                height: 3em;
                min-height: 3em;
                scrollbar-width: thin;
              }

              addon-list[type="theme"] addon-card{
                margin-right: auto;
              }
            }

            @media (min-width:640px){
              addon-list[type="extension"] > section{ grid-template-areas: "hd hd hd" "cd cd cd"; }
            }
            @media (min-width:960px){
              addon-list[type="extension"] > section{ grid-template-areas: "hd hd hd hd" "cd cd cd cd"; }
            }
            @media (min-width:1180px){
              addon-list[type="extension"] > section{ grid-template-areas: "hd hd hd hd hd" "cd cd cd cd cd"; }
            }
            @media (min-width:1420px){
              addon-list[type="extension"] > section{ grid-template-areas: "hd hd hd hd hd hd" "cd cd cd cd cd cd"; }
            }

            /* Note: addon-card verified and recommended badges are hidden here. They should remain visible in the "manage" addon page though.  */
            addon-card:not([expanded]) .addon-badge-verified,
            addon-card:not([expanded]) .addon-badge-recommended,
            addon-card:not([expanded]) .addon-description,
            addon-card:not([expanded]) .addon-card-message button[action]{ display: none !important; }

            addon-list[type="extension"]{ --card-padding: 8px }

          }

          @-moz-document url-prefix("about:addons"){
            :root{ --sidebar-width: 60px !important; }
            #categories{ width: var(--sidebar-width) !important; }
            #categories > .category{
              margin-left: 10px !important;
              -moz-box-pack: center;
            }
            .sidebar-footer-list{ margin-left: 18px !important; }
            .sidebar-footer-label,
            .category > .category-name{ display: none }
          }
        '';
        extraConfig = builtins.readFile "${pkgs.firefox-gnome-theme}/share/firefox-gnome-theme/configuration/user.js";
      };
    };
  };
}
