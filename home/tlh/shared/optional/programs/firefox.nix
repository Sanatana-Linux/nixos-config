{
  config,
  pkgs,
  ...
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
          metamask
          search-by-image
          tab-stash
          undoclosetabbutton
          view-image
          form-history-control
        ];

        settings = {
          "general.smoothScroll" = true;

          # enable custom userchrome
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # turn of google safebrowsing (it literally sends a sha sum of everything you download to google)
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
          # telemetry
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;

          # experiments
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

          # Disable another source of heart palpitations
          "extensions.pocket.enabled" = false;
          "extensions.pocket.onSaveRecs" = false;
        };

        userChrome = ''
                      @import "${pkgs.firefox-gnome-theme}/share/firefox-gnome-theme/userChrome.css";
           ::-moz-selection { /* Code for Firefox */
            color: #202020 !important;
            background: #00caff !important;
            }
            ::selection {
          color: #202020 !important;
            background: #00caff !important;
            }

            /* remove maximum/minimum width restriction of sidebar to create tab tiling... sort of */
            #sidebar-box {
            max-width: none !important;
            min-width: 30% !important;
            }
        '';

        userContent = ''
          @import "${pkgs.firefox-gnome-theme}/share/firefox-gnome-theme/userContent.css";
        '';
  extraConfig = builtins.readFile "${pkgs.firefox-gnome-theme}/share/firefox-gnome-theme/configuration/user.js";
      };
    };
  };
}
