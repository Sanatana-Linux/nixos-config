{ config, pkgs, nur, colors, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.tlh = {
      id = 0;
      settings."general.smoothScroll" = true;
      # yes these are huge css configurations, but the effect is worth it imho
      userChrome = import ./userChrome-css.nix { inherit colors; };
      userContent = import ./userContent-css.nix { };

      extraConfig = ''
         user_pref("browser.startup.homepage", "startpage-zwei.vercel.app");
         user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
         user_pref("layers.acceleration.force-enabled", true);
         user_pref("gfx.webrender.all", true);
         user_pref("svg.context-properties.content.enabled", true);
         user_pref("full-screen-api.ignore-widgets", true);
         user_pref("media.ffmpeg.vaapi.enabled", true);
         user_pref("media.rdd-vpx.enabled", true);
         user_pref("layout.css.xul-tree-pseudos.content.enabled", true);
         user_pref("layout.css.color-mix.enabled", true);
         user_pref("layout.css.moz-outline-radius.enabled", true);
         user_pref("browser.display.windows.non_native_menus", 1);
         user_pref("widget.disable-native-theme-for-content", true);
        user_pref("widget.non-native-theme.win.scrollbar.use-system-size", false);
        user_pref("browser.tabs.tabmanager.enabled", true);

      '';
    };
  };


  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/chrome" = ["firefox.desktop"];
      "text/html" = ["firefox.desktop"];
      "application/x-extension-htm" = ["firefox.desktop"];
      "application/x-extension-html" = ["firefox.desktop"];
      "application/x-extension-shtml" = ["firefox.desktop"];
      "application/xhtml+xml" = ["firefox.desktop"];
      "application/x-extension-xhtml" = ["firefox.desktop"];
      "application/x-extension-xht" = ["firefox.desktop"];
    };
  };
}
