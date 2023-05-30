{colors, ...}:
with colors; ''
  @namespace xul "http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul";
  @namespace html url("http://www.w3.org/1999/xhtml");

  /* Set theme version text in customization panel */
  #customization-footer::before {
  	background: url(icons/icon.svg) no-repeat;
  	background-size: contain;
  	content: "Colloid firefox theme";
  	padding: 9px 9px 9px 50px;
  }


  /* Toolbox, a container for all toolbars (toolbox#navigator-toolbox):
   * - menu bar (toolbar#toolbar-menubar)
   * - tab bar (toolbar#TabsToolbar)
   * - header bar (toolbar#nav-bar)
   * - bookmark bar (toolbar#PersonalToolbar)
   * - add-ons can add their own toolbars (toolbar) */


   /* Toolbox colors */
   #navigator-toolbox {
     border: 0 !important;
     background: none !important;
   }

   #nav-bar, #PersonalToolbar, #toolbar-menubar, #TabsToolbar, findbar {
     border: none !important;
     background: var(--gnome-toolbar-background) !important;
   }

   #nav-bar, #PersonalToolbar, #toolbar-menubar, #TabsToolbar {
     border-bottom: 1px solid var(--gnome-toolbar-border-color) !important;
   }

   findbar {
     border-top: 1px solid var(--gnome-toolbar-border-color) !important;
   }

   #toolbar-menubar[autohide="true"][inactive="true"]:not([customizing="true"]) {
     min-height: 0 !important;
     height: 0 !important;
     padding: 0 !important;
     appearance: none !important;
     border-bottom: none !important;
   }

   #nav-bar:-moz-window-inactive,
   #PersonalToolbar:-moz-window-inactive,
   #toolbar-menubar:-moz-window-inactive,
   #TabsToolbar:-moz-window-inactive,
   findbar:-moz-window-inactive,
   .container.infobar:-moz-window-inactive {
     background: var(--gnome-inactive-toolbar-background) !important;
     border-color: var(--gnome-inactive-toolbar-border-color) !important;
   }

   #navigator-toolbox:-moz-window-inactive label, #navigator-toolbox:-moz-window-inactive image,
   #downloads-indicator-anchor:-moz-window-inactive,
   findbar:-moz-window-inactive image:not(#hack),
   findbar:-moz-window-inactive label,
   findbar:-moz-window-inactive description,
   #viewButton:-moz-window-inactive dropmarker,
   .container.infobar:-moz-window-inactive {
     opacity: 0.7 !important;
   }

   #toolbar-menubar:not([inactive=true]) {
     margin-bottom: 0 !important;
   }
   #PersonalToolbar {
     padding: 1px !important;
   }

   /* Overrides: Remove border below the menu bar / above the header bar */
   #TabsToolbar:not([collapsed="true"]) + #nav-bar {
     border-top-width: 0 !important;
   }
   #navigator-toolbox::after {
     border-bottom-width: 0 !important;
   }

   /* Reorder toolbars */
   /* #navigator-toolbox #nav-bar {
   *  -moz-box-ordinal-group: 0;
   *}
   *#navigator-toolbox #PersonalToolbar {
   *  -moz-box-ordinal-group: 1;
   *}
   *#navigator-toolbox #titlebar {
   *  -moz-box-ordinal-group: 2;
   *}
   *#navigator-toolbox toolbar {
   *  -moz-box-ordinal-group: 10;
   *}
   *#navigator-toolbox #TabsToolbar {
   *  -moz-box-ordinal-group: 100;
   *}*/

   /* Overrides: Don't shift other toolbars on tab drag and drop */
   #TabsToolbar[movingtab] {
     padding-bottom: 0 !important;
   }
   #TabsToolbar[movingtab] > .tabbrowser-tabs {
     padding-bottom: 0 !important;
     margin-bottom: 0 !important;
   }
   #TabsToolbar[movingtab] + #nav-bar {
     margin-top: 0 !important;
   }

   /* Content notifications */
   .notificationbox-stack notification-message {
     border: 0 !important;
     font-size: 1em !important;
     padding: 0 !important;
     border-radius: 0 !important;
     margin: 0 !important;
   }
   .notificationbox-stack notification-message[style*="margin-top"] {
     margin-top: -48px !important;
   }

   .container.infobar {
     background: var(--gnome-toolbar-background) !important;
     box-shadow: none !important;
     padding: 6px !important;
     border-radius: 0 !important;
   }
   .container.infobar::before {
     display: none !important;
   }

   .container.infobar .icon {
     height: 16px !important;
     width: 16px !important;
   }
   .notificationbox-stack notification-message[type="warning"] {
     background: ${yellow} !important;
   }
   .notificationbox-stack notification-message[type="critical"] {
     background: ${red} !important;
   }

   .notificationbox-stack[notificationside="top"] notification-message {
     border-bottom: 1px solid var(--gnome-toolbar-border-color) !important;
   }
   .notificationbox-stack[notificationside="bottom"] notification-message {
     border-top: 1px solid var(--gnome-toolbar-border-color) !important;
   }

   /* Text link */
   .text-link {
     color: var(--gnome-accent) !important;
   }

   /* OPTIONAL: Hide WebRTC indicator */
   @supports -moz-bool-pref("gnomeTheme.hideWebrtcIndicator") {
     #webrtcIndicator {
       display: none;
     }
   }

   /* OPTIONAL: Move Bookmarks toolbar under tabs */
   @supports -moz-bool-pref("gnomeTheme.bookmarksToolbarUnderTabs") {
     #navigator-toolbox #titlebar {
       -moz-box-ordinal-group: 1 !important;
     }
     #navigator-toolbox #PersonalToolbar {
       -moz-box-ordinal-group: 2 !important;
     }
   }
   /* Headerbar */
  #nav-bar {
  	padding: 3px !important;
  }

  /* Headerbar CSD colors */
  :root[tabsintitlebar] #nav-bar {
  	background: var(--gnome-headerbar-background) !important;
  	border: none !important;
  	border-bottom: 1px solid var(--gnome-headerbar-border-color) !important;
  	box-shadow: var(--gnome-headerbar-box-shadow) !important;
  }
  :root[tabsintitlebar] #nav-bar:-moz-window-inactive {
  	background: var(--gnome-inactive-headerbar-background) !important;
  	border-bottom-color: var(--gnome-inactive-headerbar-border-color) !important;
  	box-shadow: var(--gnome-inactive-headerbar-box-shadow) !important;
  }


  :root[privatebrowsingmode="temporary"] {
  	--gnome-accent: var(--gnome-private-accent) !important;
  	--gnome-accent-fg: var(--gnome-private-accent) !important;
  	/* Toolbars */
  	--gnome-toolbar-background: var(--gnome-private-toolbar-background) !important;
  	--gnome-inactive-toolbar-background: var(--gnome-private-inactive-toolbar-background)  !important;
  	/* Menus */
  	--gnome-menu-background: var(--gnome-private-menu-background) !important;
  	/* Change headerbar colors */
  	--gnome-headerbar-background: var(--gnome-private-headerbar-background) !important;
  	--gnome-inactive-headerbar-background: var(--gnome-private-inactive-headerbar-background) !important;
  }

  /* Add private window headerbar indicator */
  :root[privatebrowsingmode="temporary"] #nav-bar toolbarspring:first-of-type:before {
  	background-size: 64px 64px;
  	content: "";
  	display: block;
  	position: absolute;
  	width: 64px;
  	height: 46px;
  	top: 0;
  	transform: translate(15px, 0);
  	fill: var(--gnome-toolbar-color) !important;
  	fill-opacity: 0.2 !important;
  	-moz-context-properties: fill, fill-opacity;
  }

  /* Hide tabsbar default private browsing indicator */
  #TabsToolbar .private-browsing-indicator {
  	display: none !important;
  }

  #main-window {
  	-moz-appearance: -moz-window-titlebar !important;
  }

  /* Headerbar top border corners rounded */
  :root[tabsintitlebar][sizemode="normal"]:not([gtktiledwindow="true"]) #nav-bar {
  	border-radius: env(-moz-gtk-csd-titlebar-radius) env(-moz-gtk-csd-titlebar-radius) 0 0 !important;
  }

  /* Window buttons: at least 1 button */
  @media (-moz-gtk-csd-minimize-button), (-moz-gtk-csd-maximize-button), (-moz-gtk-csd-close-button) {
  	:root[tabsintitlebar]:not([inFullscreen]) #nav-bar {
  		padding-right: 50px !important;
  	}
  }
  /* Window buttons: at least 2 buttons */
  @media (-moz-gtk-csd-minimize-button) and (-moz-gtk-csd-maximize-button),
         (-moz-gtk-csd-minimize-button) and (-moz-gtk-csd-close-button),
         (-moz-gtk-csd-maximize-button) and (-moz-gtk-csd-close-button) {
  	:root[tabsintitlebar]:not([inFullscreen]) #nav-bar {
  		padding-right: 90px !important;
  	}
  }
  /* Window buttons: 3 buttons */
  @media (-moz-gtk-csd-minimize-button) and (-moz-gtk-csd-maximize-button) and (-moz-gtk-csd-close-button) {
  	:root[tabsintitlebar]:not([inFullscreen]) #nav-bar {
  		padding-right: 130px !important;
  	}
  }

  /* Left window buttons */
  @media (-moz-gtk-csd-reversed-placement) {
  	:root[tabsintitlebar]:not([inFullscreen]) #nav-bar {
  		padding-right: 3px !important;
  	}

  	/* Window buttons box */
  	:root[tabsintitlebar] #titlebar .titlebar-buttonbox-container {
  		left: 9px;
  		right: auto !important;
  	}

  	/* Window controls: at least 1 button */
  	@media (-moz-gtk-csd-minimize-button), (-moz-gtk-csd-maximize-button), (-moz-gtk-csd-close-button) {
  		:root[tabsintitlebar]:not([inFullscreen]) #nav-bar {
  			padding-left: 50px !important;
  		}
  	}
  	/* Window controls: at least 2 buttons */
  	@media (-moz-gtk-csd-minimize-button) and (-moz-gtk-csd-maximize-button),
  				 (-moz-gtk-csd-minimize-button) and (-moz-gtk-csd-close-button),
  				 (-moz-gtk-csd-maximize-button) and (-moz-gtk-csd-close-button) {
  		:root[tabsintitlebar]:not([inFullscreen]) #nav-bar {
  			padding-left: 90px !important;
  		}
  	}
  	/* Window controls: 3 buttons */
  	@media (-moz-gtk-csd-minimize-button) and (-moz-gtk-csd-maximize-button) and (-moz-gtk-csd-close-button) {
  		:root[tabsintitlebar]:not([inFullscreen]) #nav-bar {
  			padding-left: 130px !important;
  		}
  	}
  }

  /* Fullscreen headerbar padding for 1 button */
  :root[tabsintitlebar][inFullscreen] #nav-bar {
  	padding-right: 50px !important;
  }

  /* Remove close and minimize buttons from fullscreen buttons */
  :root[tabsintitlebar][inFullscreen] #window-controls #close-button,
  :root[tabsintitlebar][inFullscreen] #window-controls #minimize-button,
  :root[tabsintitlebar][inFullscreen] #titlebar .titlebar-buttonbox-container {
  	display: none !important;
  }

  /* Remove tabsbar titlebar blank spaces */
  :root[tabsintitlebar] #TabsToolbar .titlebar-placeholder {
  	display: none !important;
  }

  /* Prevent menubar from breaking */
  :root[tabsintitlebar] #toolbar-menubar:not([inactive=true]) {
  	height: 30px !important;
  	margin-bottom: 8px;
  }

  /* Remove default style of titlebar */
  :root[tabsintitlebar] #titlebar {
  	-moz-appearance: none !important;
  }

  /* Fix the issue when dragging tabs */
  :root[tabsintitlebar] #navigator-toolbox[movingtab] #TabsToolbar {
  	padding-bottom: 0px !important;
  }

  /* Window buttons box */
  :root[tabsintitlebar] #titlebar .titlebar-buttonbox-container,
  :root[tabsintitlebar] #titlebar-buttonbox-container,
  :root[tabsintitlebar][inFullscreen] #window-controls {
  	-moz-appearance: none !important;
  	padding: 6px 10px 6px 0;
  	position: absolute !important;
  	right: 0;
  	top: 0;
  	display: block !important;
  }
  :root[tabsintitlebar] #titlebar .titlebar-buttonbox {
  	-moz-appearance: none !important;
  }

  /* Window buttons style */
  :root[tabsintitlebar] #titlebar .titlebar-button,
  :root[tabsintitlebar][inFullscreen] #window-controls toolbarbutton {
  	-moz-appearance: none !important;
  	padding: 0 !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-button {
  	border-radius: 100% !important;
  	height: 16px !important;
  	margin: 10px 7px !important;
  	width: 16px !important;
  }

  :root[tabsintitlebar][inFullscreen] #window-controls toolbarbutton {
  	border-radius: 6px !important;
  	height: 32px;
  	margin: 0 4px !important;
  	width: 32px;
  }

  :root[tabsintitlebar] #titlebar toolbarbutton > .toolbarbutton-icon {
  	padding: 0 !important;
  	stroke: none !important;
  	-moz-context-properties: fill, fill-opacity !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-button .toolbarbutton-icon,
  :root[tabsintitlebar][inFullscreen] #window-controls toolbarbutton .toolbarbutton-icon {
  	width: 16px;
  }
  :root[tabsintitlebar] #titlebar:-moz-window-inactive .titlebar-button,
  :root[tabsintitlebar][inFullscreen] #window-controls:-moz-window-inactive toolbarbutton {
  	opacity: .3 !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-min,
  :root[tabsintitlebar] #titlebar #titlebar-min {
  	background: var(--gnome-titlebutton-min-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-restore,
  :root[tabsintitlebar] #titlebar .titlebar-max,
  :root[tabsintitlebar] #titlebar #titlebar-max {
  	background: var(--gnome-titlebutton-max-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-close,
  :root[tabsintitlebar] #titlebar #titlebar-close {
  	background: var(--gnome-titlebutton-close-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-min:hover,
  :root[tabsintitlebar] #titlebar #titlebar-min:hover {
  	background: var(--gnome-titlebutton-min-hover-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-restore:hover,
  :root[tabsintitlebar] #titlebar .titlebar-max:hover,
  :root[tabsintitlebar] #titlebar #titlebar-max:hover {
  	background: var(--gnome-titlebutton-max-hover-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-close:hover,
  :root[tabsintitlebar] #titlebar #titlebar-close:hover {
  	background: var(--gnome-titlebutton-close-hover-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-min:active,
  :root[tabsintitlebar] #titlebar #titlebar-min:active {
  	background: var(--gnome-titlebutton-min-active-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-restore:active,
  :root[tabsintitlebar] #titlebar .titlebar-max:active,
  :root[tabsintitlebar] #titlebar #titlebar-max:active {
  	background: var(--gnome-titlebutton-max-active-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-close:active,
  :root[tabsintitlebar] #titlebar #titlebar-close:active {
  	background: var(--gnome-titlebutton-close-active-background) !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-button:not(:hover):not(:active) .toolbarbutton-icon {
  	list-style-image: none !important;
  	filter: none !important;
  	fill: transparent !important;
  	color: transparent !important;
  }

  :root[tabsintitlebar] #titlebar .titlebar-button:hover .toolbarbutton-icon,
  :root[tabsintitlebar] #titlebar .titlebar-button:active .toolbarbutton-icon {
  	filter: invert(100%) brightness(200%) !important;
  }

  /* OPTIONAL: Allow draging the window from headerbar buttons */
  @supports -moz-bool-pref("gnomeTheme.dragWindowHeaderbarButtons") {
  	:root[tabsintitlebar] #nav-bar *,
  	:root[tabsintitlebar] #titlebar .titlebar-button,
  	:root[tabsintitlebar][inFullscreen] #window-controls toolbarbutton {
  		-moz-window-dragging: drag;
  	}

  	/* Avoid window dragging from urlbar */
  	:root[tabsintitlebar] #nav-bar .urlbar-input-box,
  	:root[tabsintitlebar] #nav-bar .urlbar-input-box * {
  		-moz-window-dragging: no-drag !important;
  	}
  }

  #urlbar {
  	--urlbar-height: 38px;
  	--urlbar-toolbar-height: 38px !important;
  }

  /* Center the URL bar */
  toolbarspring {
  	max-width: 10000px !important;
  }

  /* URL bar */
  #urlbar {
  	box-shadow: none !important;
  }
  #urlbar-background {
  	box-shadow: none !important;
  	border: 0 !important;
  	background: transparent !important;
  }

  #urlbar[breakout][breakout-extend] {
  	left: 0 !important;
  	top: 0 !important;
  	width: 100% !important;
  	z-index: 5 !important;
  }

  #urlbar #urlbar-input-container {
  	padding: 0 !important;
  }

  /* URL bar results */
  .urlbarView {
  	background: var(--gnome-menu-background) !important;
  	color: var(--gnome-toolbar-color) !important;
  	margin: 6px 0 0 0 !important;
  	width: 100% !important;
  	position: absolute !important;
  	box-shadow: var(--gnome-urlbarView-shadow) !important;
  	border-radius: 12px !important;
  	border: 0 !important;
  }

  @media (prefers-color-scheme: dark) {
  	.urlbarView {
  		border: 1px solid rgba(255, 255, 255, 0.1) !important;
  	}
  }
  /* Search bar result */
  #PopupSearchAutoComplete {
  	margin-top: 7px !important;
  }

  .urlbarView-body-outer {
  	--item-padding-start: 0 !important;
  	--item-padding-end: 0 !important;
  	background: none !important;
  	overflow-x: auto;
  	padding: 2px 6px !important;
  	border-radius: 8px 8px 0 0 !important;
  	border: none !important;
  }

  .urlbarView-body-inner {
  	border: 0 !important;
  }

  .urlbarView-row-inner, .urlbarView-no-wrap  {
  	align-items: center !important;
  }
  .urlbarView-row-inner {
  	padding-block: 5px !important;
  	border-radius: 5px !important;
  }

  .urlbarView-row[selected] .urlbarView-row-inner {
  	background: var(--gnome-accent-bg) !important;
  	color: white !important;
  }
  .urlbarView-row:not([selected]):hover .urlbarView-row-inner {
  	background: var(--gnome-menu-button-hover-background) !important;
  }

  .urlbarView-action {
  	background: transparent !important;
  }

  /* Search engines buttons */
  .search-one-offs {
  	padding: 8px !important;
  	background: var(--gnome-entry-background) !important;
  	border-top: 1px solid var(--gnome-menu-separator-color) !important;
  	border-radius: 0 0 8px 8px !important;
  }

  .search-one-offs[is_searchbar="true"] {
  	margin-bottom: -8px !important;
  }

  /* URL bar and Search bar */
  #urlbar[focused] .urlbar-textbox-container {
  	margin: -1px !important;
  }
  #searchbar > .searchbar-textbox[focused] .searchbar-search-button {
  	margin-left: -1px !important;
  }
  #searchbar > .searchbar-textbox[focused] .search-go-button {
  	margin-right: -1px !important;
  }

  /* URL bar and Search bar's icons */
  .urlbar-icon:hover,
  .urlbar-icon-wrapper:hover,
  .urlbar-icon[open],
  .urlbar-icon-wrapper[open],
  .urlbar-icon:hover:active,
  .urlbar-icon-wrapper:hover:active,
  .searchbar-search-button:hover .searchbar-search-icon,
  .searchbar-search-button[open] .searchbar-search-icon,
  .searchbar-search-button:hover:active .searchbar-search-icon {
  	background-color: transparent !important;
  	fill-opacity: 1 !important;
  }

  /* Fixed size for some urlbar-icon */
  /*#star-button.urlbar-icon,*/
  /*#reader-mode-button > .urlbar-icon {*/
  /*	padding: 3px 0 !important;*/
  /*}*/

  /* Search mode indicator */
  #urlbar-search-mode-indicator,
  #urlbar-label-box,
  #urlbar-zoom-button {
  	background: var(--gnome-button-background) !important;
  	border: 0 !important;
  	border-radius: 26px !important;
  	outline: 0 !important;
  	margin: 4px 0;
  }
  #urlbar-search-mode-indicator {
  	padding-right: 0 !important;
  }
  #urlbar-search-mode-indicator-title {
  	color: var(--gnome-toolbar-color);
  	padding-inline: 4px !important;
  }
  #urlbar-search-mode-indicator-close {
  	background-size: 16px !important;
  	background-position: center;
  	border-radius: 26px !important;
  	padding: 5px !important;
  }
  #urlbar-search-mode-indicator-close:hover {
  	background-color: var(--gnome-button-hover-background) !important;
  }
  #urlbar-zoom-button {
  	opacity: 0.8;
  }
  #urlbar-zoom-button:hover {
  	opacity: 1;
  }

  /* Firefox identity box */
  #identity-box[pageproxystate="valid"].notSecureText > .identity-box-button,
  #identity-box[pageproxystate="valid"].chromeUI > .identity-box-button,
  #identity-box[pageproxystate="valid"].extensionPage > .identity-box-button,
  #urlbar-label-box {
  	background-color: transparent !important;
  }

  #identity-box[pageproxystate="valid"].notSecureText > .identity-box-button:hover:not([open]),
  #identity-box[pageproxystate="valid"].chromeUI > .identity-box-button:hover:not([open]),
  #identity-box[pageproxystate="valid"].extensionPage > .identity-box-button:hover:not([open]) {
  	background-color: hsla(0,0%,70%,.2) !important;
  }

  #identity-box[pageproxystate="valid"].notSecureText > .identity-box-button:hover:active,
  #identity-box[pageproxystate="valid"].notSecureText > .identity-box-button[open=true],
  #identity-box[pageproxystate="valid"].chromeUI > .identity-box-button:hover:active,
  #identity-box[pageproxystate="valid"].chromeUI > .identity-box-button[open=true],
  #identity-box[pageproxystate="valid"].extensionPage > .identity-box-button:hover:active,
  #identity-box[pageproxystate="valid"].extensionPage > .identity-box-button[open=true] {
  	background-color: hsla(0,0%,70%,.3) !important;
  }

  :root {
  	--space-above-tabbar: 0 !important;
  }

  /* Fix tabs bar icon sizes */
  #TabsToolbar {
  	--toolbarbutton-inner-padding: var(--toolbarbutton-inner-padding) !important;
  	--lwt-tab-line-color: transparent !important;
  }

  #TabsToolbar {
  	background-color: var(--gnome-tabbar-tab-background) !important;
  	padding: 0 1px !important;
  	border-bottom: 1px solid var(--gnome-tabbar-tab-border-color);
  }

  #TabsToolbar:-moz-window-inactive {
  	background-color: var(--gnome-inactive-tabbar-tab-background) !important;
  }

  /* Tabs bar height */
  #tabbrowser-tabs,
  #tabbrowser-tabs arrowscrollbox {
  	height: auto !important;
  	min-height: auto !important;
  }

  tab > stack {
  	height: 32px !important;
  	min-height: 32px !important;
    	max-width:  350px !important;

  }

  /* Remove hover effects on tab bar buttons */
  #TabsToolbar {
  	--toolbarbutton-active-background: transparent !important;
  	--toolbarbutton-hover-background: transparent !important;
  }

  /* Tabsbar buttons */
  #TabsToolbar .toolbarbutton-1:not(#hack) {
  	border: none !important;
  	border-radius: 6px !important;
  	margin: 3px 2px !important;
  	padding: 0 !important;
  	height: 32px !important;
  	width: 32px !important;
  }

  #TabsToolbar .toolbarbutton-1:not([disabled]):not(:active):not([open]):hover {
  	background-color: var(--gnome-tabbar-tab-hover-background) !important;
  }
  #TabsToolbar .toolbarbutton-1:active, #TabsToolbar .toolbarbutton-1[open] {
  	background-color: var(--gnome-tabbar-tab-border-color) !important;
  }

  /* firefox-view-button */
  :root:not([privatebrowsingmode="temporary"]):not([firefoxviewhidden]) :is(#firefox-view-button, #wrapper-firefox-view-button) + #tabbrowser-tabs {
  	border-inline-start: 1px solid var(--gnome-tabbar-tab-border-color) !important;
  	padding-inline-start: calc(var(--tab-overflow-pinned-tabs-width) + 1px) !important;
  	margin-inline-start: 1px !important;
  }


  #firefox-view-button > .toolbarbutton-icon {
  	filter: none !important;
  	width: 22px !important;
  	height: 22px !important;
  	box-shadow: none !important;
  }

  /* Remove shadow next to tab scroll buttons */
  .arrowscrollbox-overflow-start-indicator,
  .arrowscrollbox-overflow-end-indicator {
  	display: none;
  }

  #tabbrowser-tabs[movingtab=true] #tabbrowser-arrowscrollbox::after {
  	bottom: unset;
  	top: 38px;
  }

  /* Tabs separators */
  .tabbrowser-tab {
  	border-width: 1px !important;
  	border-left: 1px solid transparent !important;
  }

  .tabbrowser-tab + .tabbrowser-tab:not([selected], :hover) {
  	border-image: linear-gradient(
  		to bottom,
  		transparent 0,
  		transparent 20%,
  		var(--gnome-tabbar-tab-border-color) 20%,
  		var(--gnome-tabbar-tab-border-color) 80%,
  		transparent 80%,
  		transparent 100%) 1 !important;
  }

  .tabbrowser-tab[selected] + .tabbrowser-tab,
  .tabbrowser-tab:hover + .tabbrowser-tab,
  .tabbrowser-tab[pinned] + .tabbrowser-tab {
  	border-image: none !important;
  }

  /* Space between tabs */
  .tabbrowser-tab {
  /*	border: none !important;*/
  	padding-inline: 0 !important;
  	padding: 3px 2px 3px !important;

  }

  #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs]) > #tabbrowser-arrowscrollbox > .tabbrowser-tab[first-visible-unpinned-tab] {
  	margin-inline-start: 6px !important;
  }

  /* Tab labels */
  tab {
  	color: var(--gnome-toolbar-color) !important;
  	font-weight: normal;
  	font-size: 1em;

  }

  /* Reset tab background */
  .tab-background {
  	border-radius: 6px !important;
  	box-shadow: none !important;
  	margin-block: 0 !important;
  	border: 0 !important;
  	padding: 0 !important;
  }

  /* Center all inside tab */
  .tab-content {
  	display: flex;
  	justify-content: center;
  	align-items: center;
  	min-width: 100% !important;
   	max-width:  350px !important;
  	padding: 0 10px !important;
  }

  /* Fix custom info tab icon */
  .tabbrowser-tab[image="chrome://global/skin/icons/info.svg"]:not([pinned]):not([busy]):not([progress]) .tab-icon-stack::before {
  	margin-inline-end: 5.5px;
  }
  .tabbrowser-tab[image="chrome://global/skin/icons/info.svg"] .tab-icon-image {
  	display: none !important;
  }

  /* Prevent tab icons size breaking */
  .tab-icon-image, .tab-icon-sound, .tab-throbber, .tab-throbber-fallback, .tab-close-button {
  	min-width: 16px;
  }

  /* Center tab icon contents */
  .tabbrowser-tab .tab-icon-stack {
  	align-items: center;
  	justify-items: center;
  }

  /* Adjust tab label width */
  .tab-label-container {
  	min-width: 0 !important;
  }

  /* Put tab close button to the right */
  .tabbrowser-tab .tab-close-button {
  	margin-left: auto !important;
  }

  /* Force tab favicon to the center */
  .tabbrowser-tab .tab-icon-stack {
  	margin-left: auto !important;
  }

  /* Tab icon margin */
  .tabbrowser-tab:not([pinned]) .tab-icon-stack {
  	margin-right: 2px;
  }
  .tab-throbber:not([pinned]), .tab-icon-pending:not([pinned]), .tab-icon-image:not([pinned]), .tab-sharing-icon-overlay:not([pinned]), .tab-icon-overlay:not([pinned]) {
  	margin-inline-end: 0 !important;
  }
  .tabbrowser-tab:not([soundplaying], [muted], [activemedia-blocked], [crashed]) .tab-icon-stack {
  	padding: 4px;
  }

  /* Hide favicon when mute icon is present */
  .tabbrowser-tab:not([pinned]):is([soundplaying], [muted], [activemedia-blocked], [crashed]) .tab-icon-image:not([sharing]),
  .tabbrowser-tab:not([pinned]):is([soundplaying], [muted], [activemedia-blocked], [crashed])[selected] .tab-icon-image {
  	display: none;
  }

  /* Hide secondary label about muting */
  .tabbrowser-tab:is([soundplaying], [muted], [activemedia-blocked], [crashed]) .tab-secondary-label {
  	display: none;
  }

  /* Tab buttons */
  .tab-icon-overlay,
  .tab-close-button {
  	border: 0px solid transparent;
  	box-sizing: content-box; /* Avoid deformation on flexbox */
  	border-radius: 99px !important;
  	padding: 4px !important;
  	background-size: 24px;
  	transition: all 0.2s ease-out !important;
  }
  :root:not(:-moz-window-inactive) .tab-icon-overlay:hover,
  :root:not(:-moz-window-inactive) .tab-close-button:hover {
  	background: var(--gnome-button-flat-hover-background) !important;
  }

  .tab-icon-stack:is([soundplaying], [muted], [activemedia-blocked]) image {
  	margin: auto !important;
  }

  /* Always show the muted icon when poresent */
  #tabbrowser-tabs:not([secondarytext-unsupported]) .tabbrowser-tab:not(:hover) .tab-icon-overlay[indicator-replaces-favicon] {
  	opacity: 1 !important;
  }

  /* Icon overlay smaller */
  .tab-icon-overlay[pinned], .tab-icon-overlay:not([indicator-replaces-favicon="true"], [selected]) {
  	width: 12px !important;
  	height: 12px !important;
  	padding: 2px !important;
  }
  /* Icon overlay small style */
  .tab-icon-overlay:is([pinned], [sharing]):not([crashed]) {
  	stroke: unset !important;
  }
  .tab-icon-overlay:is([pinned]):not([crashed]),
  .tab-icon-overlay:is([sharing]):not([crashed], [selected]) {
  	background: var(--gnome-tab-button-background) !important;
  }
  .tab-icon-overlay:is([pinned], [sharing]):not([crashed]):hover {
  	background: var(--gnome-tab-button-hover-background) !important;
  }

  /* Fix icon overlay posisition when sharing */
  .tab-icon-overlay:not([crashed], [pinned]):is([sharing])[selected] {
  	top: 0 !important;
  	inset-inline-end: 0 !important;
  }


  /* Close tab button */
  :root {
  	--gnome-fill-icon: red !important;
  }

  .tab-close-button {
  	fill: var(--gnome-toolbar-color) !important;
  	fill-opacity: 1 !important;
  	-moz-context-properties: fill, fill-opacity !important;
  	height: 16px !important;
  	opacity: 1 !important;
  	width: 16px !important;
  	z-index: 100 !important;
  }

  :root:not(:-moz-window-inactive) .tab-close-button:hover {
  	background-color: var(--gnome-button-hover-background) !important;
  	border: none !important;
  	opacity: 1;
  }
  :root:not(:-moz-window-inactive) .tab-close-button:active {
  	background-color: var(--gnome-button-active-background) !important;
  }

  .tab-close-button:active:not(:hover) {
  	background-image: none !important;
  	box-shadow: none !important;
  }

  @media (prefers-color-scheme: dark) {
  	.tab-close-button.close-icon {
  		filter: invert(60%) brightness(150%);
  	}
  }

  :root:-moz-window-inactive .tab-close-button:not(#hack) {
  	opacity: .18 !important;
  }

  /* Autohide */
  .tabbrowser-tab:not([selected="true"]) .tab-close-button {
  	visibility: hidden !important;
  	opacity: 0 !important;
  }
  .tabbrowser-tab:hover .tab-close-button {
  	visibility: visible !important;
  	opacity: 1 !important;
  }

  /* Fix close button position */
  .tabbrowser-tab:not([pinned]) .tab-label-container {
  	margin-right: -16px;
  }
  .tabbrowser-tab:not([pinned]):is([selected="true"], :hover) .tab-label-container[textoverflow="true"] {
  	margin-right: 0;
  }
  #tabbrowser-tabs[closebuttons="activetab"] .tabbrowser-tab:not([pinned]) .tab-close-button {
  	display: block !important;
  }

  /* Close button overlay */
  .tabbrowser-tab:not([pinned]) .tab-content::after, .tabbrowser-tab:not([pinned]) .tab-content::before {
  	bottom: 1px;
  	content: "";
  	height: 100%;
  	opacity: 0;
  	position: absolute;
  	right: 0;
  	transition: all 0.2s ease-out;
  	width: 55px;
  }
  .tabbrowser-tab:not([pinned]) .tab-content::after {
  	background: transparent;
  	z-index: 90;
  }
  .tabbrowser-tab:not([pinned]) .tab-content::before {
  	background: linear-gradient(to left, var(--gnome-tabbar-tab-close-overlay-bg) 50%, transparent);
  	z-index: 99;
  }
  .tabbrowser-tab:not([pinned], :-moz-window-inactive):is([selected="true"], :hover) .tab-content::before {
  	opacity: 1;
  }

  /* Tab close button etc. positioning */
  .tab-throbber, .tab-icon-image, .tab-sharing-icon-overlay, .tab-icon-sound, .tab-close-button {
  	margin-top: 0 !important;
  }

  /* Active tab */
  .tab-background[selected=true] {
  	background-color: var(--gnome-tabbar-tab-active-background) !important;
  	background-image: none !important;
  	border: none !important;
  	border-image: none !important;
  	box-shadow: 0 2px 3px rgba(0, 0, 0, 0.08) !important;
  }

  .tab-background[selected=true]:-moz-window-inactive {
  	background-color: var(--gnome-inactive-tabbar-tab-active-background) !important;
  }

  /* Hover tab */
  :root:not(:-moz-window-inactive) .tabbrowser-tab:hover > .tab-stack > .tab-background[selected=true] {
  	background-color: var(--gnome-tabbar-tab-active-hover-background) !important;
  }
  .tabbrowser-tab:hover > .tab-stack > .tab-background:not([selected=true]),
  #TabsToolbar[brighttext] > #tabbrowser-tabs > .tabbrowser-tab:hover > .tab-stack > .tab-background:not([selected=true]),
  #TabsToolbar[brighttext] > #tabbrowser-tabs > .tabbrowser-tab:hover > .tab-stack > .tab-background > .tab-line:not([selected=true]) {
  	background-color: transparent !important;
  }
  :root:not(:-moz-window-inactive) .tabbrowser-tab:hover > .tab-stack > .tab-background:not([selected=true]) {
  	background-color: var(--gnome-tabbar-tab-hover-background) !important;
  	border-image: none !important;
  }

  /* Full width tabs */
  .tabbrowser-tab:not([style^="max-width"]):not([pinned]),
  .tabbrowser-tab[style^="max-width: 100px !important;"]:not([pinned]) {
  	max-width: 100% !important;
  }
  .tabbrowser-tab:not([style^="max-width"]):not([pinned]):not([fadein]),
  .tabbrowser-tab[style^="max-width: 100px !important;"]:not([pinned]):not([fadein]) {
  	max-width: .1px !important;
  }

  /* Remove blank spaces on tabs start and end */
  #TabsToolbar .titlebar-spacer {
  	display: none !important;
  }

  /* Pinned tab size */
  .tabbrowser-tab[pinned] {
  	max-width: 36px !important;
  }

  /* Remove container bottom line indicator */
  .tabbrowser-tab[usercontextid] > .tab-stack > .tab-background > .tab-context-line {
  	display: none;
  }

  /* Create new container tab indicator */
  .tabbrowser-tab[class*="identity-color-"] .tab-background:not(#hack)  { /* Normal */
  	background: var(--identity-tab-color) !important;
  	opacity: calc(.1 + var(--gnome-tabbar-tab-identity-base-opacity));
  }
  :root:not(:-moz-window-inactive) .tabbrowser-tab[class*="identity-color-"]:hover > .tab-stack > .tab-background:not([selected=true]) {  /* Hover */
  	opacity: calc(.15 + var(--gnome-tabbar-tab-identity-base-opacity)) !important;
  }
  .tabbrowser-tab[class*="identity-color-"] .tab-background[selected=true] {  /* Active */
  	opacity: calc(.3 + var(--gnome-tabbar-tab-identity-base-opacity)) !important;
  }
  :root:not(:-moz-window-inactive) .tabbrowser-tab[class*="identity-color-"]:hover > .tab-stack > .tab-background[selected=true] { /* Active + Hover */
  	opacity: calc(.35 + var(--gnome-tabbar-tab-identity-base-opacity)) !important;
  }

  .tabbrowser-tab[class*="identity-color-"]:not([pinned], :-moz-window-inactive):is([selected="true"], :hover) .tab-content::after {
  	background: linear-gradient(to left, var(--gnome-tabbar-tab-background) 50%, transparent);
  	opacity: 1;
  }
  .tabbrowser-tab[class*="identity-color-"]:not([pinned])[selected="true"] .tab-content::before,
  :root:not(:-moz-window-inactive) .tabbrowser-tab[class*="identity-color-"]:not([pinned])[selected="true"]:hover .tab-content::before,
  .tabbrowser-tab[class*="identity-color-"]:not([pinned]):hover .tab-content::before,
  .tabbrowser-tab[class*="identity-color-"]:not([pinned])[selected="true"]:-moz-window-inactive .tab-content::before {
  	--gnome-tabbar-tab-close-overlay-bg: var(--identity-tab-color)  !important;
  }
  .tabbrowser-tab[class*="identity-color-"]:not([pinned]):hover .tab-content::before {  /* Hover */
  	opacity: calc(.15 + var(--gnome-tabbar-tab-identity-base-opacity));
  }
  .tabbrowser-tab[class*="identity-color-"]:not([pinned])[selected="true"] .tab-content::before /* Active */ {
  	opacity: calc(.3 + var(--gnome-tabbar-tab-identity-base-opacity));
  }
  :root:not(:-moz-window-inactive) .tabbrowser-tab[class*="identity-color-"]:hover > .tab-stack > .tab-content[selected=true]::before {  /* Active + Hover */
  	opacity: calc(.35 + var(--gnome-tabbar-tab-identity-base-opacity));
  }
  :root:-moz-window-inactive .tabbrowser-tab[class*="identity-color-"]:not([pinned])[selected="true"] .tab-content::before {
  	opacity: 0;
  	transition: none !important;
  }

  /* Tab spinner */
  .tab-throbber::before {
  	animation: gnome-spinner 1s linear infinite !important;
  	!important;
  	width: 16px !important;
  	opacity: 1 !important;
  }


  @keyframes gnome-spinner {
  	from {
  		transform: rotate(0deg);
  	}
  	to {
  		transform: rotate(360deg);
  	}
  }

  /* OPTIONAL: Hide single tab */
  @supports -moz-bool-pref("gnomeTheme.hideSingleTab") {
  	#tabbrowser-tabs tab:only-of-type {
  		display: none !important;
  	}
  }

  /* OPTIONAL: Use normal width tabs */
  @supports -moz-bool-pref("gnomeTheme.normalWidthTabs") {
  	.tabbrowser-tab:not([style^="max-width"]):not([pinned]),
  	.tabbrowser-tab[style^="max-width: 100px !important;"]:not([pinned]) {
  		max-width: 225px !important;
  	}
  }

  /* OPTIONAL: Add more contrast to the active tab */
  @supports -moz-bool-pref("gnomeTheme.activeTabContrast") {
  	.tab-background[selected=true],
  	:root:not(:-moz-window-inactive) .tabbrowser-tab:hover > .tab-stack > .tab-background:not(#hack) {
  		background: var(--gnome-tabbar-tab-active-background-contrast) !important;
  	}
  }

  findbar {
  	padding: 0 !important;
  	position: relative;
  }

  findbar label, findbar description {
  	color: var(--gnome-toolbar-color) !important;
  }

  .findbar-container {
  	align-items: center;
  	padding: 6px !important;
  	display: flex;
  	justify-content: flex-start;
  	position: relative;
  	flex-direction: row;
  	margin: 0 !important;
  	width: calc(100% - 42px);
  	height: auto !important;
  }

  hbox[anonid="findbar-textbox-wrapper"] {
  	display: flex !important;
  }

  .findbar-entire-word {
  	margin-right: auto !important;
  }

  .findbar-find-status, .found-matches {
  	margin-right: 6px !important;
  }

  .findbar-closebutton {
  	margin: 6px 6px 6px 0 !important;
  }

  .findbar-container toolbarbutton .toolbarbutton-text {
  	display: none !important;
  }

  #sidebar-box, .sidebar-panel {
  	background: var(--gnome-sidebar-background) !important;
  }
  #sidebar-box:-moz-window-inactive, .sidebar-panel:-moz-window-inactive {
  	background: var(--gnome-inactive-sidebar-background) !important;
  }
  #sidebar-box:-moz-window-inactive label, #sidebar-box:-moz-window-inactive image,
  .sidebar-panel:-moz-window-inactive label, .sidebar-panel:-moz-window-inactive image,
  .sidebar-placesTreechildren:-moz-window-inactive {
  	opacity: 0.7 !important;
  }
  #sidebar-splitter {
  	background: var(--gnome-toolbar-background) !important;
  	border: 0 !important;
  	border-right: 1px solid var(--gnome-toolbar-border-color) !important;
  	width: 0 !important;
  }
  #sidebar-splitter:-moz-window-inactive {
  	background: var(--gnome-inactive-toolbar-background) !important;
  	border-color: var(--gnome-inactive-toolbar-border-color) !important;
  }

  #sidebar-header {
  	padding: 6px !important;
  	border-bottom: 1px solid var(--gnome-toolbar-border-color) !important;
  }
  #sidebar-search-container {
  	padding: 6px !important;
  }

  /* List container */
  #permission-popup-permission-list,
  richlistbox#items {
  	--in-content-item-selected: var(--gnome-accent-bg) !important;
  	--in-content-item-selected-text: #fff !important;
  	background: var(--gnome-menu-background) !important;
  	border: 1px solid var(--gnome-button-border-color) !important;
  	border-radius: 12px !important;
  	padding: 0 !important;
  	overflow: hidden;
  }

  richlistbox#items {
  	box-shadow: 0 0 0 1px rgba(0, 0, 0, .03),
                  0 1px 3px 1px rgba(0, 0, 0, .07),
                  0 2px 6px 2px rgba(0, 0, 0, .03);
  }

  /* List item */
  .permission-popup-permission-list-anchor,
  richlistbox#items richlistitem {
  	padding: 6px 6px 1px !important;
  	margin: 0 !important;
  }
  .permission-popup-permission-list-anchor:not(:last-child),
  richlistbox#items richlistitem:not(:last-child) {
  	border-bottom: 1px solid var(--gnome-menu-separator-color);
  }

  /* Fix list buttons on selected state */
  @media (prefers-color-scheme: light) {
  	richlistbox#items richlistitem[selected=true] button:not(:hover) {
  		filter: invert() brightness(200%) !important;
  	}
  }

  /* Hide buttons separator */
  #nav-bar .toolbaritem-combined-buttons separator {
  	display: none !important;
  }
  #appMenu-popup .toolbaritem-combined-buttons toolbarseparator {
  	border: 0 !important;
  }

  /* Buttons */
  menulist,
  #nav-bar toolbarbutton:not(#urlbar-zoom-button),
  .subviewbutton.panel-subview-footer,
  .panel-footer button,
  #downloadsPanel-mainView .download-state .downloadButton,
  #appMenu-popup .panel-banner-item,
  #appMenu-popup .toolbaritem-combined-buttons toolbarbutton:not(#appMenu-fxa-label),
  #context-navigation menuitem,
  .identity-popup-preferences-button:not(#hack),
  .findbar-container toolbarbutton,
  #sidebar-switcher-target,
  #viewButton,
  .close-icon:not(.tab-close-button),
  button.close,
  .menulist-label-box,
  .expander-down, .expander-up,
  .notification-button,
  #identity-popup-security-expander,
  #protections-popup-info-button,
  #PanelUI-panic-view-button,
  .tracking-protection-button,
  .dialog-button,
  .autocomplete-richlistitem[type="loginsFooter"],
  .dialog-button-box button,
  .searchbar-engine-one-off-item,
  .permission-popup-permission-remove-button,
  .button.connect-device,
  #item-choose button,
  #editBMPanel_newFolderButton {
  	-moz-appearance: none !important;
  	background: var(--gnome-button-background) !important;
  	border-radius: 6px !important;
  	border: 0 !important;
  	padding: 0 1px !important;
  	height: 34px !important;
  	max-height: 34px !important;
  	min-height: 34px !important;
  	min-width: 34px !important;
  	color: var(--gnome-toolbar-color) !important;
  	outline: 0 !important;
  	font: menu !important;
  	-moz-box-align: center !important;
  }
  .subviewbutton-iconic {
  	-moz-box-pack: center !important;
  }

  /* Flat Buttons */
  #nav-bar toolbarbutton:not(#urlbar-zoom-button),
  .close-icon:not(.tab-close-button),
  button.close,
  #protections-popup-info-button,
  .permission-popup-permission-remove-button {
  	background: transparent !important;
  }

  /* Buttons with margins */
  #nav-bar toolbarbutton:not(#urlbar-zoom-button),
  .notification-button,
  .subviewbutton.panel-subview-footer:not(:only-of-type),
  .panel-footer button:not(:only-of-type) {
  	margin: 0 3px !important;
  }
  .close-icon:not(.tab-close-button) {
  	margin-left: 6px !important;
  }

  /* Text buttons */
  menulist,
  .subviewbutton.panel-subview-footer,
  .panel-footer button,
  #appMenu-popup .panel-banner-item,
  #appMenu-popup #appMenu-zoomReset-button2:not(#hack),
  #tracking-protection-preferences-button:not(#hack),
  .findbar-container toolbarbutton.findbar-button,
  .notification-button,
  #PanelUI-panic-view-button,
  .tracking-protection-button,
  .dialog-button,
  .autocomplete-richlistitem[type="loginsFooter"],
  .dialog-button-box button,
  .toolbaritem-combined-buttons:is(:not([cui-areatype="toolbar"]), [overflowedItem="true"]) > #appMenu-fxa-label2:not(#hack),
  .button.connect-device,
  #item-choose button,
  #editBMPanel_newFolderButton {
  	padding: 2px 16px !important;
  }
  .subviewbutton.panel-subview-footer label,
  .panel-footer button,
  #appMenu-popup .panel-banner-item .toolbarbutton-text,
  #appMenu-popup #appMenu-zoomReset-button2:not(#hack),
  #tracking-protection-preferences-button:not(#hack),
  .findbar-container toolbarbutton.findbar-button,
  .notification-button,
  #PanelUI-panic-view-button,
  .tracking-protection-button,
  .dialog-button,
  .autocomplete-richlistitem[type="loginsFooter"],
  .dialog-button-box button,
  .button.connect-device,
  #item-choose button {
  	text-align: center !important;
  }

  /* Drop down buttons */
  #sidebar-switcher-target,
  #viewButton {
  	padding: 2px 16px !important;
  	position: relative;
  }
  #sidebar-switcher-arrow,
  #viewButton .button-menu-dropmarker { /* Arrow position, type b */
  	transform: translate(6px, 0)
  }
  .menulist-label-box {
  	padding: 2px 26px 2px 16px !important;
  	position: relative;
  }
  .menulist-label-box:after { /* Arrow position */
  	position: absolute !important;
  	right: 8px !important;
  	top: 8px !important;
  }
  .menulist-label-box:after { /* Create arrow if icon tag no exist */
  	content: "";
  }

  /* Hover buttons */
  menulist:hover,
  .subviewbutton.panel-subview-footer:hover,
  .panel-footer button:hover,
  #downloadsPanel-mainView .download-state .downloadButton:hover,
  #appMenu-popup .panel-banner-item:hover,
  #appMenu-popup .toolbaritem-combined-buttons toolbarbutton:not(#appMenu-fxa-label):not([disabled="true"]):hover,
  #context-navigation menuitem:not([disabled="true"]):hover,
  .identity-popup-preferences-button:not(#hack):hover,
  .findbar-container toolbarbutton:hover,
  .findbar-closebutton .toolbarbutton-icon:hover,
  #sidebar-switcher-target:hover,
  #viewButton:hover,
  menulist:hover .menulist-label-box,
  .expander-down:hover, .expander-up:hover,
  .notification-button:hover,
  #identity-popup-security-expander:hover,
  .tracking-protection-button:hover,
  .dialog-button:hover,
  .autocomplete-richlistitem[type="loginsFooter"]:hover,
  .dialog-button-box button:not([disabled="true"]):hover,
  .searchbar-engine-one-off-item:hover,
  #editBMPanel_newFolderButton:hover {
  	outline: 0 !important;
  	background: var(--gnome-button-hover-background) !important;
  }

  /* Hover flat buttons */
  #nav-bar toolbarbutton:not(#urlbar-zoom-button):not([open]):not([disabled="true"]):not([checked]):hover,
  .close-icon:not(.tab-close-button):hover,
  button.close:hover,
  #protections-popup-info-button:hover,
  .permission-popup-permission-remove-button:hover,
  #item-choose button:hover {
  	outline: 0 !important;
  	background: var(--gnome-button-flat-hover-background) !important;
  }

  /* Active buttons */
  menulist[open],
  .subviewbutton.panel-subview-footer:active,
  .panel-footer button:active,
  #downloadsPanel-mainView .download-state .downloadButton:active,
  #appMenu-popup .panel-banner-item:active,
  #appMenu-popup .toolbaritem-combined-buttons toolbarbutton:not([disabled="true"]):not(#appMenu-fxa-label):active,
  #context-navigation menuitem:active:not([disabled="true"]),
  .identity-popup-preferences-button:not(#hack):active,
  .findbar-container toolbarbutton[checked],
  .findbar-container toolbarbutton:active,
  #sidebar-switcher-target:active, #sidebar-switcher-target.active,
  #viewButton[open],
  menulist[open] .menulist-label-box,
  .expander-down:active, .expander-up:active,
  .notification-button:active,
  #identity-popup-security-expander:active,
  .tracking-protection-button:active,
  .dialog-button:active,
  .autocomplete-richlistitem[type="loginsFooter"]:active,
  .dialog-button-box button:not([disabled="true"]):active,
  #editBMPanel_newFolderButton:active {
  	background: var(--gnome-button-active-background) !important;
  	box-shadow: none !important;
  }

  /* Active flat buttons */
  #nav-bar toolbarbutton:not(#urlbar-zoom-button):not([disabled="true"]):not(#hack):active,
  #nav-bar toolbarbutton:not(#urlbar-zoom-button):not([disabled="true"])[open],
  #nav-bar toolbarbutton:not(#urlbar-zoom-button):not([disabled="true"])[checked],
  .close-icon:not(.tab-close-button):active,
  button.close:active,
  #protections-popup-info-button:not(#hack):active,
  #protections-popup-info-button:not(#hack)[checked],
  .permission-popup-permission-remove-button:active,
  #item-choose button:active {
  	background: var(--gnome-button-flat-active-background) !important;
  	box-shadow: none !important;
  }

  /* Disabled buttons */
  #nav-bar toolbarbutton:not(#urlbar-zoom-button)[disabled="true"],
  #appMenu-popup .toolbaritem-combined-buttons toolbarbutton[disabled="true"],
  #context-navigation menuitem[disabled="true"],
  .dialog-button-box button[disabled="true"] {
  	opacity: .5 !important;
  }

  /* Inactive window buttons */
  #nav-bar toolbarbutton:not(#urlbar-zoom-button):-moz-window-inactive,
  .findbar-container toolbarbutton:-moz-window-inactive,
  #sidebar-switcher-target:-moz-window-inactive,
  #viewButton:-moz-window-inactive,
  .notification-button:-moz-window-inactive {
  	background: var(--gnome-inactive-button-background) !important;
  	box-shadow: var(--gnome-inactive-button-box-shadow) !important;
  	border-color: var(--gnome-inactive-button-border-color) !important;
  }

  /* Circle buttons */
  #downloadsPanel-mainView .download-state .downloadButton,
  .permission-popup-permission-remove-button:not(#hack) {
  	border-radius: 100% !important;
  }

  /* Combined buttons */
  #nav-bar .toolbaritem-combined-buttons:not(.unified-extensions-item) toolbarbutton:not(:last-of-type):not(#hack),
  #appMenu-popup .toolbaritem-combined-buttons toolbarbutton:not(:last-of-type):not(#appMenu-zoomEnlarge-button),
  #context-navigation menuitem:not(:last-of-type),
  .findbar-container toolbarbutton.findbar-find-previous,
  .findbar-button:not(:last-of-type),
  .search-panel-one-offs .searchbar-engine-one-off-item:not(:last-child) {
  	border-top-right-radius: 0 !important;
  	border-bottom-right-radius: 0 !important;
  	border-right-width: 0 !important;
  	margin-right: 0 !important;
  }

  #nav-bar .toolbaritem-combined-buttons:not(.unified-extensions-item) toolbarbutton:not(:first-of-type):not(#hack),
  #appMenu-popup .toolbaritem-combined-buttons toolbarbutton:not(:first-of-type):not(#appMenu-fullscreen-button),
  #context-navigation menuitem:not(:first-of-type),
  .findbar-container toolbarbutton.findbar-find-previous,
  .findbar-container toolbarbutton.findbar-find-next,
  .findbar-button:not(:first-of-type),
  .search-panel-one-offs .searchbar-engine-one-off-item:not(:first-child) {
  	border-top-left-radius: 0 !important;
  	border-bottom-left-radius: 0 !important;
  	margin-left: 0 !important;
  }

  #nav-bar .toolbaritem-combined-buttons {
  	margin-left: 0 !important;
  	margin-right: 0 !important;
  }

  /* Opaque buttons */
  #appMenu-popup .panel-banner-item[notificationid="update-restart"],
  button.popup-notification-primary-button,
  #editBookmarkPanelDoneButton,
  #tracking-action-block,
  .button.connect-device,
  #editBookmarkPanelRemoveButton,
  #PanelUI-panic-view-button {
  	color: white !important;
  	font-weight: bold !important;
  }

  /* Buttons with suggested action */
  #appMenu-popup .panel-banner-item[notificationid="update-restart"],
  button.popup-notification-primary-button:not(#hack),
  #editBookmarkPanelDoneButton,
  #tracking-action-block,
  .button.connect-device {
  	background-color: var(--gnome-button-suggested-action-background) !important;
  }

  /* Buttons with destructive action */
  #editBookmarkPanelRemoveButton,
  #PanelUI-panic-view-button {
  	background-color: var(--gnome-button-destructive-action-background) !important;
  }

  /* Opaque buttons hover */
  #appMenu-popup .panel-banner-item[notificationid="update-restart"]:hover,
  button.popup-notification-primary-button:hover,
  #editBookmarkPanelDoneButton:hover,
  #tracking-action-block:hover,
  .button.connect-device:hover,
  #editBookmarkPanelRemoveButton:hover,
  #PanelUI-
  /* Fix notification dropmarker */
  .popup-notification-dropmarker dropmarker {
  	display: none !important;
  }
  .popup-notification-dropmarker > .button-box > hbox {
  	display: -moz-box !important;
  }
  .panel-footer button.popup-notification-dropmarker {
  	padding: 0 1px 0 4px !important;
  }

  /* Fix hover background */
  .toolbarbutton-badge-stack:not(#hack), .toolbarbutton-icon:not(#hack), .toolbarbutton-text:not(#hack) {
  	background: transparent !important;
  }

  /* Fix button box */
  .panel-footer.panel-footer-menulike > button > .button-box {
  	display: -moz-box !important;
  }

  /* menulist */
  #label-box:not([native]) {
  	font-weight: 400 !important;
  }

  /* Overrides: Make the back button the same as other buttons */
  :root:not([uidensity=compact]) #back-button {
  	border-radius: var(--toolbarbutton-border-radius) !important;
  }
  :root:not([uidensity=compact]) #back-button > .toolbarbutton-icon {
  	background-color: unset !important;
  	border: unset !important;
  	width: calc(2 * var(--toolbarbutton-inner-padding) + 16px) !important;
  	height: calc(2 * var(--toolbarbutton-inner-padding) + 16px) !important;
  	padding: var(--toolbarbutton-inner-padding) !important;
  	border-radius: var(--toolbarbutton-border-radius);
  	box-shadow: none !important;
  }
  :root:not([uidensity=compact]) #back-button:not([disabled]):not([open]):hover > .toolbarbutton-icon {
  	background-color: var(--toolbarbutton-hover-background) !important;
  	box-shadow: unset;
  	border-color: unset;
  }
  :root:not([uidensity=compact]) #back-button[open] > .toolbarbutton-icon,
  :root:not([uidensity=compact]) #back-button:not([disabled]):hover:active > .toolbarbutton-icon {
  	background-color: var(--toolbarbutton-active-background) !important;
  	border-color: unset;
  }

  /* Remove the header bar buttons' hover styles */
  #nav-bar {
  	--toolbarbutton-active-background: transparent !important;
  	--toolbarbutton-hover-background: transparent !important;
  }

  /* Glitch customizing: Cut / Copy / Paste buttons' icons
   * :not(#hack) is there just to elevate rule priority */
  :root[customizing] #nav-bar > hbox toolbaritem toolbarbutton image:not(#hack) {
  	opacity: 1 !important;
  }
  /* Glitch customizing: Reload and Cut / Copy / Paste buttons */
  :root:-moz-window-inactive[customizing] #nav-bar #stop-reload-button toolbarbutton,
  :root:-moz-window-inactive[customizing] #nav-bar #edit-controls toolbarbutton {
  	background-image: var(--gnome-inactive-button-background);
  	box-shadow: var(--gnome-inactive-button-box-shadow);
  }
  /* Glitch customizing: Reload and Cut / Copy / Paste buttons' icons */
  :root:-moz-window-inactive[customizing] #nav-bar #stop-reload-button image.toolbarbutton-icon,
  :root:-moz-window-inactive[customizing] #nav-bar #edit-controls image.toolbarbutton-icon {
  	opacity: .7 !important;
  }

  /* Glitch: Overflow and Burger buttons
   * :not(#hack) is there just to elevate rule priority */
  :root[customizing] #nav-bar > toolbarbutton[disabled]:not(#hack),
  :root[customizing] #nav-bar > toolbaritem > toolbarbutton[disabled]:not(#hack) {
  	opacity: .5 !important;
  }
  /* Glitch: Overflow button's icon */
  :root[customizing] #nav-bar toolbarbutton:not(#urlbar-zoom-button)[disabled] image {
  	fill-opacity: var(--toolbarbutton-icon-fill-opacity) !important;
  }

  /* Bookmark buttons */
  #nav-bar toolbarbutton.bookmark-item {
  	width: auto !important;
  }
  #nav-bar toolbarbutton.bookmark-item .toolbarbutton-icon {
  	margin-left: 6px;
  }
  #nav-bar toolbarbutton.bookmark-item .toolbarbutton-text {
  	padding-right: 6px;
  }

  /* Remove Burger button's left separator */
  #PanelUI-button {
  	border: 0 !important;
  	margin: 0 !important;
  	padding-inline-start: 0 !important;
  }

  /* Space main menu button from other headerbar buttons
  #nav-bar #PanelUI-menu-button:not(#hack) {
  	margin-left: 10px !important;
  }*/

  /* Fix library animation */
  #library-animatable-box  {
  	--library-button-height: 46px !important;
  	--library-icon-x: 1716px !important;
  	/*--library-icon-x: 1715.9833984375px !important;*/
  }
  #library-button[animate] > .toolbarbutton-icon {
  	fill: transparent !important;
  }

  /* Fix toolbars close icons */
  .close-icon:not(.tab-close-button) .toolbarbutton-icon {
  	height: 16px !important;
  	width: 16px !important;
  	margin: 6px !important;
  	padding: 0 !important;
  }
  button.close {
  	margin: 0 !important;
  	fill: var(--gnome-toolbar-color) !important;
  }

  button.close.ghost-button {

  	background-repeat: no-repeat !important;
  	background-position: center !important;
  }

  /* */
  #appMenu-popup .panel-banner-item[notificationid="update-restart"]::after {
  	display: none !important;
  }

  /* Identity site popover buttons */
  .identity-popup-preferences-button:not(#hack) {
  	list-style-image: url("chrome://browser/skin/settings.svg") !important;
  }
  #tracking-protection-preferences-button > .toolbarbutton-text {
  	padding-inline-end: 0 !important;
  }
  .protections-popup-footer-button-label {
  	margin-inline-start: 3px !important;
  }

  /* Fix findbar buttons issues */
  .findbar-container .findbar-find-previous image,
  .findbar-container .findbar-find-next image {
  	margin: 6px !important;
  	opacity: 1 !important;
  }
  .findbar-container toolbarbutton:focus {
  	outline: 0 !important;
  }

  /* Sidebar header button reset font size */
  #sidebar-header {
  	font-size: 1em !important;
  }

  /* Sidebar header button arrow opacity */
  #sidebar-switcher-arrow {
  	opacity: 1 !important;
  }

  /* Sidebar history view */
  #viewButton {
  	margin: 0 !important;
  	margin-inline-start: 6px !important;
  }

  /* Menulist */
  #identity-popup-popup-menulist {
  	margin-right: 0 !important;
  }

  /* Auto complete popup button*/
  .autocomplete-richlistitem[type="loginsFooter"] {
  	margin: 4px 4px 0 4px !important;
  }

  /* Identity popup tracking protection button */
  .tracking-protection-button {
  	margin-inline-end: 0 !important;
  }

  /* Identity popup delete permission button */
  .identity-popup-permission-remove-button {
  	opacity: 1 !important;
  }

  /* Identity popup expander button */
  #identity-popup-security {
  	-moz-box-align: center;
  }
  #identity-popup-security-expander {
  	width: 34px !important;
  }
  #identity-popup-security-expander .button-icon {
  	margin: 0 !important;
  }

  /* Protections popup */
  #protections-popup-info-button {
  	margin: 0 !important;
  	margin-inline-end: 0 !important;
  }
  .protections-popup-footer-icon {
  	display: none !important;
  }
  .protections-popup-footer-button-label {
  	margin-inline-start: 0 !important;
  }
  #protections-popup-footer-protection-type-label {
  	margin-inline-end: 0 !important;
  	margin-block: 0 !important;
  }

  /* Close button */
  .close-icon:not(.tab-close-button) .toolbarbutton-icon {
  	outline:  0 !important;
  }

  /* Downloads button */
  #downloads-indicator-progress-inner {
  	background: conic-gradient(var(--gnome-toolbar-icon-fill) var(--download-progress-pcent), transparent var(--download-progress-pcent)) !important;
  }
  #downloads-indicator-progress-outer,
  #downloads-indicator-start-image,
  #downloads-indicator-finish-image {
  	border: 0 !important;
  	padding: 0 !important;
  	border-radius: 100% !important;
  }
  #downloads-indicator-progress-outer,
  #downloads-indicator-start-image {
  	background: var(--gnome-toolbar-border-color) !important;
  }
  #downloads-indicator-finish-image {
  	background: var(--gnome-toolbar-icon-fill) !important;
  }
  #downloads-button .toolbarbutton-animatable-box {
  	top: 8px !important;
  	left: 8px !important;
  }
  #downloads-button .toolbarbutton-animatable-box,
  #downloads-button .toolbarbutton-animatable-image,
  #downloads-indicator-progress-inner {
  	height: 16px !important;
  	width: 16px !important;
  }
  #downloads-button .toolbarbutton-animatable-image {
  	--anim-steps: 1 !important;
  	transform: none !important;
  	list-style-image: none !important;
  }

  /* Stop/Reload button */
  #stop-reload-button  .toolbarbutton-animatable-image:not(#hack) {
  	--anim-steps: 1 !important;
  	transform: none !important;
  	list-style-image: none !important;
  	display: none !important;
  }
  #stop-reload-button .toolbarbutton-icon {
  	margin-top: -2px !important;
  }

  /* Panel banner */
  #appMenu-popup .panel-banner-item {
  	margin: 0 0 6px !important;
  }
  #appMenu-popup .panel-banner-item > .toolbarbutton-text {
  	margin-inline: 0 !important;
  }

  /* User menu */
  #fxa-toolbar-menu-button .toolbarbutton-badge-stack {
  	padding: 0 !important;
  }
  #fxa-avatar-image {
  	min-height: 24px !important;
  	width: 24px !important;
  }
  /* Customization menu */
  button.customizationmode-button {
  	border: none !important;
  }
  .customization-uidensity-menuitem {
  	border: none !important;
  	margin: 3px 3px 0 !important;
  }
  .customization-uidensity-menuitem:last-of-type {
  	margin: 3px 3px !important;
  }
  panic-view-button:hover {
  	background-image: linear-gradient(rgba(255, 255, 255, .1), rgba(255, 255, 255, .1)) !important;
  }

  /* Opaque buttons active */
  #appMenu-popup .panel-banner-item[notificationid="update-restart"]:active,
  button.popup-notification-primary-button:active,
  #editBookmarkPanelDoneButton:active,
  #tracking-action-block:active,
  .button.connect-device:active,
  #editBookmarkPanelRemoveButton:active,
  #PanelUI-panic-view-button:active {
  	background-image: linear-gradient(rgba(0, 0, 0, .2), rgba(0, 0, 0, .2)) !important;
  }

  /* Entries */
  #urlbar,
  #searchbar,
  #search-box,
  .findbar-textbox,
  #loginTextbox,
  #password1Textbox,
  .tabsFilter,
  #editBMPanel_namePicker,
  #editBMPanel_tagsField {
  	-moz-appearance: none !important;
  	background: var(--gnome-entry-background) !important;
  	border: none !important;
  	border-radius: 8px !important;
  	box-shadow: none !important;
  	color: var(--gnome-entry-color) !important;
  	height: 34px !important;
  	max-height: 34px !important;
  	margin: 0 !important;
  	padding: 6px !important;
  	box-sizing: border-box;
  }

  /* Entries focused */
  #urlbar[breakout][breakout-extend],
  #urlbar[focused="true"]:not([suppress-focus-border]),
  #searchbar:focus-within,
  #search-box[focused],
  .findbar-textbox[focused],
  .findbar-textbox:focus,
  #loginTextbox:focus,
  #password1Textbox:focus,
  .tabsFilter[focused],
  #editBMPanel_namePicker:focus-visible,
  #editBMPanel_tagsField:focus-visible {
  	outline: 2px solid var(--gnome-focused-urlbar-border-color) !important;
  	outline-offset: -2px;
  	-moz-outline-radius: 8px;
  }

  /* Inactive window entries */
  #urlbar:-moz-window-inactive,
  #searchbar:-moz-window-inactive,
  #search-box:-moz-window-inactive,
  .findbar-textbox:-moz-window-inactive,
  #loginTextbox:-moz-window-inactive,
  #password1Textbox:-moz-window-inactive,
  .tabsFilter:-moz-window-inactive {
  	color: var(--gnome-inactive-entry-color) !important;
  }

  /* Entries combined */
  .findbar-textbox:not(.minimal) {
  	border-top-right-radius: 0 !important;
  	border-bottom-right-radius: 0 !important;
  	border-right-width: 0 !important;
  }
  .findbar-textbox:not(.minimal)[focused], .findbar-textbox:not(.minimal):focus {
  	-moz-outline-radius: 5px 0 0 5px !important;
  }

  /* Entry button */
  .identity-box-button,
  #tracking-protection-icon-container,
  #notification-popup-box,
  .urlbar-page-action,
  .urlbar-icon {
  	fill-opacity: 0.8 !important;
  }

  .identity-box-button:hover:not([open="true"]),
  #tracking-protection-icon-container:hover:not([open="true"]),
  #notification-popup-box:hover:not([open="true"]),
  .urlbar-page-action:hover:not([open="true"]),
  .urlbar-page-action:hover:not([open="true"]) .urlbar-icon,
  .urlbar-icon:not([disabled]):hover {
  	background: none !important;
  	fill-opacity: 1 !important;
  }

  .identity-box-button:hover:active,
  .identity-box-button[open=true],
  #tracking-protection-icon-container:hover:active,
  #tracking-protection-icon-container[open=true],
  #notification-popup-box:hover:active,
  #notification-popup-box[open=true],
  .urlbar-page-action:hover:active,
  .urlbar-page-action[open=true],
  .urlbar-page-action:hover:active .urlbar-icon,
  .urlbar-page-action[open=true] .urlbar-icon {
  	background: none !important;
  	fill-opacity: 1 !important;
  }

  /* Entries fixes */
  #urlbar-container, #search-container {
  	padding: 0 !important;
  	margin: 0 3px !important;
  }
  #urlbar-input-container {
  	background: transparent !important;
  	border: 0 !important;
  }
  #urlbar, #searchbar {
  	margin: 0 3px !important;
  	padding: 0 3px !important;
  }
  .searchbar-textbox {
  	border: 0 !important;
  	padding: 0 !important;
  	margin: 0 !important;
  	min-height: auto !important;
  }
  #searchbar > .searchbar-textbox[focused] .searchbar-search-button:not(#hack) {
  	margin: 0 !important;
  }
  #urlbar[focused="true"]:not([suppress-focus-border]) > #urlbar-background {
  	outline: 0 !important;
  }

  /* Switchers */
  .protections-popup-tp-switch-box {
  	padding: 0 !important;
  	-moz-box-pack: start !important;
  }
  #protections-popup-tp-switch:not([enabled])[showdotindicator]::after {
  	display: none !important;
  }
  #protections-popup-tp-switch {
  	background: var(--gnome-switch-background) !important;
  	border: 0 !important;
  	border-radius: 24px !important;
  	min-width: 48px !important;
  	width: 48px !important;
  	min-height: 26px !important;
  	padding: 0 !important;
  	position: relative !important;
  	display: block !important;
  	margin: 0 !important;
  }
  #protections-popup-tp-switch::before {
  	position: absolute !important;
  	top: 2px;
  	left: 2px;
  	background: var(--gnome-switch-slider-background) !important;
  	box-shadow: 0 2px 4px rgba(0, 0, 0, .2);
  	border: 0 !important;
  	border-radius: 24px !important;
  	height: 22px !important;
  	width: 22px !important;
  	transition: left .2s ease;
  	outline: 0 !important;
  }
  #protections-popup-tp-switch[enabled] {
  	background: var(--gnome-switch-active-background) !important;
  	padding-inline-start: 24px !important;
  }
  #protections-popup-tp-switch[enabled]::before {
  	background: var(--gnome-switch-active-slider-background) !important;
  	left: 24px;
  }

  /* Icons color */
  .toolbarbutton-icon,
  menuitem:not([class*='identity']) .menu-iconic-left .menu-iconic-icon,
  .urlbar-page-action:not([readeractive]),
  .button-icon:not(#hack),
  .bookmark-item[container],
  .notification-anchor-icon,
  .protections-popup-category::after,
  .protections-popup-footer-icon,
  #identity-popup-mainView .subviewbutton-nav::after,
  .widget-overflow-list .subviewbutton-nav::after,
  .PanelUI-subView .subviewbutton-nav::after,
  #identity-popup[connection^="secure"] .identity-popup-security-connection,
  .panel-info-button > image,
  .menu-right,
  .expander-down > .button-box,
  #sidebar-switcher-arrow,
  #sidebar-icon,
  #viewButton .button-menu-dropmarker,
  .menulist-label-box:after,
  .expander-up > .button-box,
  #urlbar:not(.searchButton) > #urlbar-input-container > #identity-box[pageproxystate="invalid"] > #identity-icon,
  .searchbar-search-icon,
  .textbox-search-sign,
  treechildren::-moz-tree-twisty,
  treechildren::-moz-tree-image,
  .item.client .item-twisty-container,
  menuitem[type="checkbox"],
  menuitem[type="checkbox"][checked="true"],
  menuitem[type="radio"],
  menuitem[type="radio"][checked="true"],
  .tab-icon-overlay,
  .tab-throbber::before,
  .tab-icon-stack::before,
  .tab-icon-image,
  .close-icon:not(.tab-close-button),
  button.close::before,
  #urlbar-search-mode-indicator-close,
  #tracking-protection-icon,
  #identity-icon,
  #permissions-granted-icon,
  #downloads-indicator-icon,
  .textbox-search-clear,
  :root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-close .toolbarbutton-icon,
  :root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-max .toolbarbutton-icon,
  :root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-restore .toolbarbutton-icon,
  :root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-min .toolbarbutton-icon,
  :root[tabsintitlebar][inFullscreen] #window-controls #restore-button .toolbarbutton-icon {
  	fill: var(--gnome-toolbar-icon-fill) !important;
  	-moz-context-properties: fill, fill-opacity;
  }
  .toolbarbutton-icon:-moz-window-inactive {
  	fill: var(--gnome-inactive-toolbar-icon-fill) !important;
  }

  .checkbox-check {
  	color: var(--gnome-inactive-toolbar-icon-fill) !important;
  	background-color: var(--gnome-toolbar-background) !important;
  	border: 1px solid var(--gnome-inactive-toolbar-icon-fill) !important;
  	border-radius: 3px !important;
  }

  .checkbox-check[checked] {
  	border-color: var(--gnome-accent) !important;
  	background-color: var(--gnome-accent) !important;
  	fill: white !important;
  	color: white !important;
  }

  /* Menu checkbox */
  menuitem[type="checkbox"] {
  	list-style-image: none !important;
  }

  menuitem[type="checkbox"][disabled="true"] .menu-iconic-icon {
  	opacity: 0.5;
  }

  /* Menu radio */
  menuitem[type="radio"] {
  	list-style-image: none !important;
  }

  menuitem[type="radio"] .menu-iconic-icon {
  	border-radius: 100%;
  	border: 1px solid var(--gnome-inactive-toolbar-icon-fill);
  }
  menuitem[type="radio"][disabled="true"] .menu-iconic-icon {
  	opacity: 0.5;
  }

  /* Window buttons */

  /* Reload */
  /* Cursors autoscroller fix */
  .autoscroller {
  	--panel-background: transparent !important;
  	--panel-border-color: transparent !important;
  	background-image: url("chrome://global/skin/icons/autoscroll.svg") !important;
  }

  /* Built-in firefox icons color */
  .toolbarbutton-icon,
  .protections-popup-category-icon,
  .protections-popup-footer-icon {
  	fill: var(--gnome-toolbar-color) !important;
  	fill-opacity: 1 !important;
  }

  /* Scroll icons */
  #scrollbutton-up {
  	list-style-image: var(--scrollbutton-icon-name) !important;
  }
  #scrollbutton-down {
  	list-style-image: var(--scrollbutton-icon-name) !important;
  }

  /* Popovers subview menu arrow */
  #identity-popup-mainView .subviewbutton-nav::after,
  .widget-overflow-list .subviewbutton-nav::after,
  .PanelUI-subView .subviewbutton-nav::after {
  	content: "" !important;	background-size: contain;
  	height: 16px;
  	width: 16px;
  	margin-top: -2px !important;
  }
  menu[disabled] > .menu-right {
  	opacity: 0.3;
  }

  /* Arrow down buttons */
  .expander-down > .button-box,
  #sidebar-switcher-arrow,
  #viewButton .button-menu-dropmarker,
  .popup-notification-dropmarker .button-icon {
  	-moz-appearance: none !important;
  	width: 16px !important;
  	height: 16px !important;
  }
  /* Arrow up buttons */
  .expander-up > .button-box {
  	-moz-appearance: none !important;
  	width: 16px !important;
  	height: 16px !important;
  }

  /* Search entries */
  #urlbar[pageproxystate="invalid"] > #identity-box > #identity-icon,
  #urlbar:not(.searchButton) > #urlbar-input-container > #identity-box[pageproxystate="invalid"] #identity-icon,
  .searchbar-search-icon,
  #search-box .textbox-search-sign {
  	opacity: 0.7 !important;
  }

  #search-box .textbox-search-sign {
  	width: 16px !important;
  	margin: 2px 0;
  }

  /* Tree views */
  treechildren::-moz-tree-twisty,
  .item.client .item-twisty-container {
  	width: 16px !important;
  	height: 16px !important;
  }
  #star-button[starred] {
  	fill: var(--gnome-accent) !important;
  }

  toolbar:not([brighttext]) .webextension-browser-action:-moz-lwtheme {
  	list-style-image: var(--webextension-toolbar-image-2x-dark, var(--gnome-toolbar-color)) !important;
  }

  #webrtc-sharing-icon[sharing]:not([paused]) {
  	-moz-context-properties: fill !important;
  	fill: rgb(224, 41, 29) !important;
  }


  /* Fix flat buttons icons aproach */
  button.close::before {
  	content: "";
  	display: block;
  	background-position: center center;
  	background-repeat: no-repeat;
  	height: 100%;
  	width: 100%;
  }

  /* Fix icons sizes */
  .permission-popup-permission-remove-button > .button-box > .button-icon,
  .menu-iconic-icon {
  	height: 16px !important;
  	width: 16px !important;
  }

  /* Fix icon color */
  #sidebar-icon {
  	opacity: 1 !important;
  }

  treechildren::-moz-tree-twisty,
  treechildren::-moz-tree-image {
  	fill-opacity: 1 !important;
  }

  /* Fix main menu zoom controls icons */
  #appMenu-zoom-controls2 .toolbarbutton-icon {
  	padding: 0 !important;
  	padding-block: 0 !important;
  	padding-inline: 0 !important;
  }

  /* Invert icons color in dark variant */
  @media (prefers-color-scheme: dark) {
  	.PanelUI-subView .subviewbutton-nav::after,
  	.protections-popup-category::after,
  	.identity-popup-content-blocking-category::after,
  	#identity-popup-security-expander .button-icon,
  	.subviewbutton-back .toolbarbutton-icon,
  	.menu-right,
  	#urlbar[pageproxystate="invalid"] > #identity-box > #identity-icon,
  	#urlbar:not(.searchButton) > #urlbar-input-container > #identity-box[pageproxystate="invalid"] #identity-icon,
  	.searchbar-search-icon,
  	#search-box .textbox-search-sign,
  	.menulist-label-box:after,
  	.expander-down image,
  	.expander-up image,
  	#sidebar-switcher-arrow,
  	#viewButton .button-menu-dropmarker,
  	menuitem[type="checkbox"] .menu-iconic-icon,
  	menuitem[type="radio"] .menu-iconic-icon,
  	.close-icon:not(.tab-close-button) image,
  	.identity-popup-permission-remove-button .button-icon,
  	:root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-close .toolbarbutton-icon,
  	:root[tabsintitlebar] #titlebar #titlebar-close .toolbarbutton-icon,
  	:root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-max .toolbarbutton-icon,
  	:root[tabsintitlebar] #titlebar #titlebar-max .toolbarbutton-icon,
  	:root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-min .toolbarbutton-icon,
  	:root[tabsintitlebar] #titlebar #titlebar-min .toolbarbutton-icon,
  	:root[tabsintitlebar][inFullscreen] #window-controls #restore-button .toolbarbutton-icon,

  	.popup-notification-icon[popupid="web-notifications"], .desktop-notification-icon,

  	#import-button .toolbarbutton-icon,
  	#panic-button .toolbarbutton-icon,
  	#open-file-button .toolbarbutton-icon,
  	#save-page-button .toolbarbutton-icon,
  	#characterencoding-button .toolbarbutton-icon,
  	#library-button .toolbarbutton-icon,
  	#privatebrowsing-button .toolbarbutton-icon,
  	#sidebar-button:-moz-locale-dir(ltr):not([positionend]) .toolbarbutton-icon,
  	#sidebar-button:-moz-locale-dir(rtl)[positionend] .toolbarbutton-icon,
  	#sidebar-button .toolbarbutton-icon,
  	#nav-bar #back-button .toolbarbutton-icon,
  	#context-back .menu-iconic-icon,
  	#nav-bar #forward-button .toolbarbutton-icon,
  	#context-forward .menu-iconic-icon,
  	#PanelUI-menu-button .toolbarbutton-icon,
  	#new-tab-button .toolbarbutton-icon,
  	.tabs-newtab-button .toolbarbutton-icon,
  	#tabs-newtab-button .toolbarbutton-icon,
  	#TabsToolbar .toolbarbutton-icon,
  	#home-button .toolbarbutton-icon,
  	#preferences-button .toolbarbutton-icon,
  	#fullscreen-button .toolbarbutton-icon,
  	#appMenu-fullscreen-button .toolbarbutton-icon,
  	#zoom-out-button .toolbarbutton-icon,
  	#appMenu-zoomReduce-button .toolbarbutton-icon,
  	#zoom-in-button .toolbarbutton-icon,
  	#appMenu-zoomEnlarge-button .toolbarbutton-icon,
  	#developer-button .toolbarbutton-icon,
  	#email-link-button .toolbarbutton-icon,
  	#print-button .toolbarbutton-icon,
  	#add-ons-button .toolbarbutton-icon,
  	#unified-extensions-button .toolbarbutton-icon,
  	#find-button .toolbarbutton-icon,
  	#bookmarks-menu-button .toolbarbutton-icon,
  	#history-panelmenu .toolbarbutton-icon,
  	#alltabs-button .toolbarbutton-icon,
  	#cut-button .toolbarbutton-icon,
  	#appMenu-cut-button .toolbarbutton-icon,
  	#copy-button .toolbarbutton-icon,
  	#appMenu-copy-button .toolbarbutton-icon,
  	#paste-button .toolbarbutton-icon,
  	#appMenu-paste-button .toolbarbutton-icon,
  	#nav-bar-overflow-button .toolbarbutton-icon,
  	#reload-button .toolbarbutton-icon,
  	.downloadIconRetry > .button-box > .button-icon,
  	#context-reload .menu-iconic-icon,
  	#stop-button .toolbarbutton-icon,
  	.downloadIconCancel > .button-box > .button-icon,
  	#context-stop,
  	#downloads-button .toolbarbutton-icon,
  	#sync-button .toolbarbutton-icon,
  	#new-window-button .toolbarbutton-icon,
  	#mozcn-mobile-bookmarks-button .toolbarbutton-icon,
  	#bookmarks-toolbar-button .toolbarbutton-icon,
  	#bookmarks-toolbar-placeholder .toolbarbutton-icon,
  	#screenshot-button .toolbarbutton-icon,
  	#tracking-protection-icon,
  	#pageActionButton,
  	#permissions-granted-icon,
  	#tracking-protection-icon-animatable-image,
  	#reader-mode-button > .urlbar-icon,
  	#star-button:not([starred]),
  	#context-bookmarkpage:not([starred]) .menu-iconic-icon,
  	#geo-sharing-icon[sharing], .geo-icon,
  	.blocked-permission-icon.popup-icon,
  	#webrtc-sharing-icon[sharing="screen"],
  	.screen-icon,
  	.screen-icon.blocked-permission-icon,
  	#webrtc-sharing-icon[sharing="microphone"],
  	.microphone-icon,
  	.plugin-icon, .autoplay-media-icon,
  	.popup-notification-icon[popupid="drmContentPlaying"], .drm-icon,
  	#identity-box[pageproxystate="valid"].verifiedDomain #identity-icon,
  	#identity-box[pageproxystate="valid"].mixedActiveBlocked #identity-icon,
  	#identity-box[pageproxystate="valid"].weakCipher #identity-icon,
  	#identity-box[pageproxystate="valid"].mixedDisplayContent #identity-icon,
  	#identity-box[pageproxystate="valid"].mixedDisplayContentLoadedActiveBlocked #identity-icon,
  	#identity-box[pageproxystate="valid"].certUserOverridden #identity-icon,
  	#identity-box[pageproxystate="valid"].certErrorPage #identity-icon,
  	#identity-box[pageproxystate="valid"].notSecure #identity-icon,
  	#identity-box[pageproxystate="valid"].mixedActiveContent #identity-icon,
  	#identity-box[pageproxystate="valid"].httpsOnlyErrorPage #identity-icon,
  	#identity-box[pageproxystate="valid"].localResource #identity-icon,
  	.bookmark-item[container] .toolbarbutton-icon,
  	.menu-iconic.bookmark-item[container] .menu-iconic-icon,
  	.panel-info-button > image {
  		filter: invert(60%) brightness(150%);
  	}

  	/* Fix for extensions icons */
  	.webextension-browser-action {
  		list-style-image: var(--webextension-menupanel-image-light, inherit) !important;
  	}
  }


  /* Style menus */
  menupopup {
  	-moz-appearance: none !important;
  	color: var(--gnome-toolbar-color) !important;
  	padding: 8px !important;
  	margin: -8px !important;
  }

  menupopup label {
  	color: var(--gnome-toolbar-color);
  }

  menu menupopup {
  	margin-top: -6px !important;
  }

  .menupopup-arrowscrollbox {
  	-moz-appearance: none !important;
  	background: var(--gnome-menu-background) !important;
  	border: 1px solid var(--gnome-menu-border-color) !important;
  	border-radius: 12px !important;
  	box-shadow: var(--gnome-menu-shadow) !important;
  	padding: 6px !important;
  	margin: 0 !important;
  }

  menuitem[type="checkbox"] image, menuitem[type="radio"] image {
  	visibility: visible !important;
  }

  menuitem[disabled="true"]:hover, menupopup menu[disabled="true"]:hover {
  	background: transparent !important;
  }

  /* Adjust popovers position */
  panel[type=arrow] {
  	margin-top: 3px !important;
  }

  /* Style popovers */
  panel:not([remote]) {
  	--arrowpanel-background: var(--gnome-menu-background) !important;
  	--panel-item-hover-bgcolor: var(--gnome-menu-button-hover-background) !important;
  }
  panel {
  	--arrowpanel-padding: 1px !important;
  	--arrowpanel-border-color: var(--gnome-menu-border-color) !important;
  	--arrowpanel-border-radius: 12px !important;
  	--gnome-menu-padding: 6px;
  }
  panelview {
  	border-radius: 12px !important;
  	box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.1) !important;
  }

  /* Padding rules */
  #sidebarMenu-popup {
  	--arrowpanel-padding: var(--gnome-menu-padding) !important;
  }
  #downloadsPanel-blockedSubview,
  #downloadsPanel-mainView {
  	padding:  var(--gnome-menu-padding) !important;
  }
  .panel-header, .panel-footer,
  .panel-subview-body,
  .protections-popup-section,
  #protections-popup-mainView-panel-header-section,
  .permission-popup-section,
  .identity-popup-section,
  .popup-notification-header-container,
  .popup-notification-body-container,
  .popup-notification-footer-container {
  	padding: 0 var(--gnome-menu-padding) var(--gnome-menu-padding) !important;
  }
  :is(
  	.panel-header, .panel-footer,
  	.panel-subview-body,
  	.protections-popup-section,
  	#protections-popup-mainView-panel-header-section,
  	.permission-popup-section,
  	.identity-popup-section,
  	.popup-notification-header-container,
  	.popup-notification-body-container,
  	.popup-notification-footer-container
  ):first-child:not(:empty) {
  	padding-top: var(--gnome-menu-padding) !important;
  }
  .panel-subview-body > .panel-subview-body {
  	padding: 0 !important;
  }
  /* Padding with margin */
  .subviewbutton.panel-subview-footer-button:not(#downloadsHistory) {
  	margin: var(--gnome-menu-padding) !important;
  }
  .subviewbutton.panel-subview-footer-button:not(:only-child, #downloadsHistory) {
  	margin: 0 var(--gnome-menu-padding) !important;
  }
  .subviewbutton.panel-subview-footer-button:not(:only-child, #downloadsHistory):last-child {
  	margin-bottom: var(--gnome-menu-padding) !important;
  }
  #identity-popup-security-button {
  	margin: 0 var(--gnome-menu-padding) !important;
  }

  /* No menu */
  #notification-popup,
  #permission-popup,
  #editBookmarkPanel,
  #downloadsPanel {
  	--gnome-menu-padding: 12px !important;
  }

  /* Panel arrow */
  .panel-arrowcontent {
  	background: var(--arrowpanel-background) !important;
  	border: 1px solid rgba(255, 255, 255, 0.1) !important;
  	border-radius: 12px !important;
  	color: var(--gnome-toolbar-color) !important;
  	box-shadow: 0 0 0 1px var(--gnome-menu-border-color)!important;
  }
  .panel-arrow {
  	fill: var(--arrowpanel-background) !important;
  	stroke: var(--gnome-menu-border-color) !important;
  	display: -moz-inline-box !important;
  }

  /* Panel header */
  .panel-header {
  	position: relative !important;
  }

  /* Panel footer */
  .panel-footer {
  	background-color: transparent !important;
  	margin: 0 !important;
  }
  .panel-subview-body .panel-footer {
  	padding: 0 !important;
  }
  .panel-footer.panel-footer-menulike {
  	border-top: 0 !important;
  	margin-top: 8px !important;
  }
  .panel-footer toolbarseparator {
  	display: none !important;
  }
  .proton-zap {
  	border-image: unset !important;
  }
  .panel-subview-footer {
  	margin-top: 10px !important;
  }

  /* Remove unwanted separators */
  .panel-header + toolbarseparator,
  #identity-popup-mainView-panel-header + toolbarseparator,
  #permission-popup-mainView-panel-header + toolbarseparator,
  #protections-popup-mainView-panel-header-section + toolbarseparator {
  	display: none !important;
  }

  /* Menu buttons */
  menuitem, menupopup menu,
  .subviewbutton:not(#appMenu-fxa-label2),
  .toolbarbutton-1,
  .protections-popup-footer-button,
  .protections-popup-category,
  .identity-popup-content-blocking-category,
  #downloadsPanel-mainView .download-state {
  	-moz-appearance: none !important;
  	border-radius: 6px !important;
  	color: var(--gnome-toolbar-color) !important;
  	font: menu !important;
  	padding: 4px 12px !important;
  	min-height: 32px !important;
  }

  #PlacesToolbar .bookmark-item {
  	-moz-appearance: none !important;
  	border-radius: 6px !important;
  	color: var(--gnome-toolbar-color) !important;
  	padding: 2px 8px !important;
  	min-height: 28px !important;
  }

  .subviewbutton,
  .protections-popup-footer-button,
  .protections-popup-category,
  .identity-popup-content-blocking-category,
  #PlacesToolbar menupopup[placespopup="true"] .bookmark-item,
  .openintabs-menuitem,
  .widget-overflow-list .toolbarbutton-1 {
  	margin: 0 !important;
  }

  .subviewbutton[shortcut]:after {
  	opacity: 0.5 !important;
  }

  .bookmark-item .menu-right {
  	fill-opacity: 1 !important;
  }

  /* Menu buttons disabled */
  menuitem[disabled="true"], menupopup menu[disabled="true"],
  .subviewbutton[disabled="true"], .toolbarbutton-1[disabled="true"],
  .protections-popup-category[disabled="true"],
  .identity-popup-content-blocking-category[disabled="true"] {
  	opacity: .5 !important;
  }
  menuitem[disabled="true"][_moz-menuactive], menupopup menu[disabled="true"][_moz-menuactive] {
  	background: transparent !important;
  }

  /* Menu buttons hover */
  menuitem:not([disabled="true"]):is(:hover, [_moz-menuactive]),
  menupopup menu:not([disabled="true"]):is(:hover, [_moz-menuactive]),
  .subviewbutton:not([disabled="true"], #appMenu-zoom-controls2, #appMenu-fxa-label2):hover,
  .protections-popup-footer-button:not([disabled="true"]):hover,
  #protections-popup-show-report-stack:hover .protections-popup-footer-button,
  .protections-popup-category:not([disabled="true"]):hover,
  .identity-popup-content-blocking-category:not([disabled="true"]):hover,
  #PlacesToolbar .bookmark-item:is(:hover, [open], [_moz-menuactive]),
  #downloadsPanel-mainView .download-state:hover {
  	background: var(--gnome-menu-button-hover-background) !important;
  }

  /* Menu buttons active */
  menuitem:not([disabled="true"]):is(:active, [_moz-menuactive]),
  menupopup menu:not([disabled="true"]):is(:active, [_moz-menuactive]),
  .subviewbutton:not([disabled="true"], #appMenu-zoom-controls2, #appMenu-fxa-label2):active,
  .protections-popup-footer-button:not([disabled="true"]):active,
  #protections-popup-show-report-stack:active .protections-popup-footer-button,
  .protections-popup-category:not([disabled="true"]):active,
  .identity-popup-content-blocking-category:not([disabled="true"]):active,
  #PlacesToolbar .bookmark-item:active,
  #downloadsPanel-mainView .download-state:active {
  	background: var(--gnome-button-flat-active-background) !important;
  	box-shadow: none !important;
  	border: none;
  }

  /* Menu buttons fix */
  #appMenu-fxa-label2 {
  	padding: 0 !important;
  }

  #appMenu-fxa-label2:hover {
  	background: transparent !important;
  }

  #appMenu-fxa-label2:active {
  	background: transparent !important;
  	box-shadow: none !important;
  	border: none;
  }

  /* Menu buttons back */
  .subviewbutton-back {
  	opacity: 1 !important;
  	width: 100%;
  	-moz-box-align: center !important;
  	-moz-box-pack: start !important;
  }
  .subviewbutton-back + h1 {
  	font-weight: bold !important;
  	left: 0 !important;
  	padding: 0 !important;
  	pointer-events: none;
  	position: absolute !important;
  	top: 8px !important;
  	width: 100%;
  }

  /* Menu headers */
  .subview-subheader {
  	font: menu !important;
  	font-weight: bold !important;
  	padding-block: 0 !important;
  	margin: 0 4px !important;
  }

  /* Style popover separators */
  toolbarseparator, menuseparator {
  	appearance: none !important;
  }

  #PlacesToolbar menupopup[placespopup="true"] menuseparator {
  	border-top: 1px solid var(--gnome-menu-separator-color) !important;
  	padding: 0 !important;
  	margin: 6px 0 !important;
  }

  #PlacesToolbar menupopup[placespopup="true"] menuseparator::before {
  	border: 0 !important;
  }

  toolbarbutton menupopup[placespopup] menuseparator {
  	padding-top: 0 !important;
  	padding-bottom: 0 !important;
  }

  toolbarbutton menupopup[placespopup] menuseparator::before {
  	border-top: 0 !important;
  }

  toolbarseparator:not([orient="vertical"]), menupopup menuseparator {
  	border-top: 1px solid var(--gnome-menu-separator-color) !important;
  	margin: 6px 0 !important;
  }
  toolbarseparator[orient="vertical"] {
  	margin: 0 6px !important;
  }

  .panel-subview-body + toolbarseparator:not([orient="vertical"]) {
  	margin: 0 0 6px !important;
  }
  panelview > toolbarseparator:not([orient="vertical"]),
  #identity-popup-clear-sitedata-footer toolbarseparator:not([orient="vertical"]),
  #identity-popup-more-info-footer toolbarseparator:not([orient="vertical"]){
  	margin: 6px !important;
  }
  #identity-popup-clear-sitedata-footer toolbarseparator:not([orient="vertical"]) {
  	margin-top: 0 !important;
  }

  /* Alltabs Popup Menu*/
  .all-tabs-item {
  	--arrowpanel-menuitem-margin-inline: 0 !important;
  	--arrowpanel-menuitem-border-radius: 6px !important;
  }

  .all-tabs-item:hover {
  	background-color: transparent !important;
  }

  .all-tabs-item:hover:active {
  	background-color: transparent !important;
  }

  .all-tabs-item image {
  	margin: 0 0 0 6px !important;
  }

  .all-tabs-item label {
  	margin: 0 6px 0 0 !important;
  }

  /* Main menu fxa */
  #appMenu-fxa-status[fxastatus="signedin"] > #appMenu-fxa-label {
  	padding-left: 22px !important;
  	margin-inline-start: -22px !important;
  }
  #appMenu-fxa-status[fxastatus="signedin"] > #appMenu-fxa-avatar {
  	margin-inline-start: 5px !important;
  }
  #appMenu-fxa-status2[fxastatus] > #appMenu-fxa-label2 > vbox > #appMenu-header-description, #appMenu-fxa-text {
  	font-weight: 400 !important;
  }

  /* Style main context menu & buttons */
  #context-navigation {
  	padding: 0;
  }
  #context-navigation > menuitem > .menu-iconic-left {
  	margin: auto !important;
  }
  #context-navigation menuitem {
  	--toolbarbutton-active-background: transparent !important;
  	--toolbarbutton-hover-background: transparent !important;
  }

  /* Main menu */
  #appMenu-popup .panel-banner-item:after {
  	-moz-box-ordinal-group: 0;
  	margin: 0 8px 0 0 !important;
  }
  #appMenu-popup .toolbaritem-combined-buttons {
  	margin-inline-end: 0 !important;
  }
  #appMenu-popup .toolbaritem-combined-buttons .before-label {
  	width: 32px !important;
  }
  .subviewbutton#appMenu-zoom-controls2 {
  	padding-right: 0 !important;
  	padding-top: 6px !important;
  }

  /* User sync account remove avatar */
  #fxa-menu-avatar {
  	display: none;
  }

  /* Add search engine button remove icon */
  #pageAction-panel-addSearchEngine .toolbarbutton-badge-stack {
  	display: none !important;
  }

  /* All tabs popover */
  .all-tabs-item[selected] {
  	border-left: 3px solid var(--gnome-tabbar-tab-active-border-bottom-color);
  	box-shadow: none !important;
  }

  .all-tabs-item > .all-tabs-secondary-button label {
  	margin: 0 !important;
  }

  /* Add bookmark */
  #editBookmarkPanelInfoArea {
  	padding: 0 !important;
  }
  #editBookmarkPanelRows,
  #editBookmarkPanelBottomContent {
  	padding: 0 !important;
  }
  #editBookmarkPanelBottomButtons {
  	margin: 0 !important;
  }
  #editBookmarkPanelBottomContent {
  	margin-bottom: 12px !important;
  }
  #editBookmarkPanelBottomContent,
  #editBookmarkPanelRows vbox {
  	margin: 6px 0;

  }

  /* Downloads popover */
  #downloadsPanel-mainView .download-state {
  	padding: 12px !important;
  	border: 0 !important;
  	display: flex;
  	align-items: center;
  	height: 64px !important;
  	margin: 0 !important;
  }

  #downloadsPanel-mainView .downloadMainArea {
  	flex: 1;
  	display: flex;
  }
  #downloadsPanel-mainView .downloadMainArea:hover {
  	background: transparent !important;
  }

  #downloadsPanel-mainView .downloadTypeIcon {
  	margin: 0 !important;
  	margin-right: 6px !important;
  }

  #downloadsPanel-mainView .downloadContainer {
  	margin-inline-end: 0 !important;
  	flex: 1;
  	display: flex;
  	flex-direction: column;
  }

  #downloadsPanel-mainView .download-state .downloadButton .button-box {
  	padding: 0 !important;
  	margin: 0 !important;
  }
  #downloadsPanel-mainView .download-state toolbarseparator {
  	display: none;
  }

  /* Customization overflow menu position */
  #customization-panel-container {
  	margin-top: 10px;
  	z-index: 10;
  }

  /* Confirmation Hint */
  #confirmation-hint .panel-arrowcontent {
  	background: var(--gnome-button-suggested-action-background) !important;
  	border-color: var(--gnome-button-suggested-action-border-color) !important;
  }
  #confirmation-hint .panel-arrow {
  	fill: var(--gnome-button-suggested-action-border-color) !important;
  	stroke: var(--gnome-button-suggested-action-border-color) !important;
  }
  #confirmation-hint-message {
  	color: white !important;
  }

  /* URLbar popups */
  #identity-popup-mainView,
  #permission-popup-mainView,
  #protections-popup-mainView,
  #identity-popup-mainView-panel-header {
  	max-width: calc(var(--popup-width) + (var(--gnome-menu-padding) * 2)) !important;
  	min-width: calc(var(--popup-width) + (var(--gnome-menu-padding) * 2)) !important;
  }

  /* Identity popup */
  #identity-popup-security,
  .identity-popup-section,
  #identity-popup-security-expander .button-box,
  .identity-popup-security-content {
  	border: 0 !important;
  }

  .identity-popup-security-content {
  	padding-inline-end: 0 !important;
  	padding-inline-start: 0 !important;
  }
  .identity-popup-security-content {
  	background-position: 0em 0.8em !important;
  	background-size: 24px auto;
  }
  .identity-popup-security-content .identity-popup-headline {
  	margin-left: 1.4em !important;
  }
  #identity-popup-security-button {
  	padding: 3px 0 !important;
  }
  .identity-popup-security-connection.identity-button:not(#hack)  {
  	width: calc(var(--popup-width) - 30px) !important;
  }

  /* Permission popup */
  #permission-popup-permissions-content {
  	padding: 0 !important;
  }
  #permission-popup-mainView {
  	min-width: unset !important;
  	max-width: unset !important;
  }

  .permission-popup-permission-item:first-child, #permission-popup-storage-access-permission-list-header {
  	margin-top: 0 !important;
  }
  .permission-popup-permission-remove-button {
  	opacity: 1 !important;
  }
  .permission-popup-permission-state-label {
  	display: none !important;
  }

  #permission-popup-permission-list-default-anchor:empty {
  	padding: 0 !important;
  	border: 0 !important;
  }
  .permission-popup-permission-list-anchor[anchorfor="3rdPartyStorage"] {
  	padding: 0 !important;
  }
  .permission-popup-permission-list-anchor[anchorfor="3rdPartyStorage"] > vbox:only-child {
  	display: block !important;
  	height: 0 !important;
  	overflow: hidden;
  	visibility: hidden;
  	margin: 0 !important;
  	margin-bottom: -1px !important;
  }
  .permission-popup-permission-item-3rdPartyStorage {
  	margin-right: 6px;
  	margin-bottom: 6px !important;
  }
  #permission-popup-storage-access-permission-list-header {
  	padding: 6px !important;
  }

  /* Protections popup */
  .protections-popup-section,
  #protections-popup-not-blocking-section-header {
  	border: 0 !important;
  }
  #protections-popup-mainView-panel-header-section {
  	background: transparent !important;
  }
  #protections-popup-mainView toolbarseparator {
  	display: none !important;
  }

  #protections-popup-mainView-panel-header {
  	color: var(--gnome-toolbar-color) !important;
  	padding: 0 !important;
  }
  #protections-popup[hasException] #protections-popup-mainView-panel-header {
  	background: none !important;
  }
  #protections-popup-main-header-label {
  	height: auto !important;
  	margin-inline-start: 6px !important;
  	text-align: left !important;
  }
  #protections-popup-mainView-panel-header-span {
  	margin: 0 !important;
  	margin-inline-start: 0 !important
  }
  #protections-popup[toast] #protections-popup-mainView-panel-header {
  	border-bottom-width: 1px !important;
  	border-radius: 5px !important;
  	padding: 0px !important;
  }
  #protections-popup-info-button {
  	margin: 0 !important;
  }

  #messaging-system-message-container {
  	height: 120px !important;
  	border: 0 !important;
  }
  #protections-popup #messaging-system-message-container[disabled] {
  	margin-bottom: -120px !important;
  }
  #protections-popup-message {
  	background: none !important;
  	border: 0 !important;
  	color: var(--gnome-toolbar-color) !important;
  	height: 100% !important;
  	margin: 0 !important;
  }
  #protections-popup-message .text-link {
  	color: var(--gnome-toolbar-color) !important;
  }

  #protections-popup-tp-switch-section {
  	background: var(--gnome-menu-background);
  	border: 1px solid var(--gnome-button-border-color) !important;
  	border-radius: 9px;
  	padding: 12px 16px !important;
  	margin: 0 !important;
  }

  #protections-popup[hasException] #protections-popup-tp-switch-section {
  	background: var(--gnome-menu-background) !important;
  }
  .protections-popup-tp-switch-label-box label {
  	margin-right: 12px !important;
  	font-weight: normal !important;
  }

  #protections-popup-no-trackers-found-description {
  	margin: 12px 12px 0 !important;
  	text-align: left !important;
  }

  #protections-popup-blocking-section-header,
  #protections-popup-not-found-section-header,
  #protections-popup-not-blocking-section-header{
  	padding: 0px 5px !important;
  	margin-top: 20px !important;
  	height: auto !important;
  }

  #protections-popup-category-list {
  	margin: 0 !important;
  }
  .protections-popup-category.notFound .protections-popup-category-label {
  	width: calc(var(--popup-width) - 70px) !important;
  }
  .protections-popup-category-label {
  	margin-inline-start: 6px !important;
  }
  .protections-popup-category-state-label {
  	opacity: 0.7;
  }

  #protections-popup-footer {
  	display: flex;
  	justify-content: flex-start;
  	flex-wrap: wrap;
  	margin-top: 12px;
  }
  #protections-popup-show-report-stack {
  	width: 100% !important;
  }
  #protections-popup-show-report-button {
  	height: 32px !important;
  }
  #protections-popup-trackers-blocked-counter-box,
  #protections-popup-footer-protection-type-label {
  	margin: 0 !important;
  	margin-inline: 0 !important;
  }
  .protections-popup-description {
  	border-bottom: 0 !important;
  }
  .protections-popup-description > description {
  	margin: 8px !important;
  }

  /* Feature recommendation notification, fix width */
  #contextual-feature-recommendation-notification {
  	width: auto !important;
  }

  /* Extensions sometimes assume a white background */
  .webextension-popup-browser {
  	background-color: #fff !important;
  }


  window {
  	padding: 0 !important;
  }

  /* Browser dialog prompts center */
  .dialogOverlay {
  	display: grid;
  	place-content: center;
  	 justify-content: center;
  	grid-auto-rows: min(90%, var(--doc-height-px));
  }
  .dialogOverlay[topmost="true"]:not(.dialogOverlay-window-modal-dialog-subdialog), #window-modal-dialog::backdrop {
  	background-color: rgba(0, 0, 0, .5) !important;
  }

  #window-modal-dialog {
  	margin-top: auto !important;
  	display: flex;
  	justify-content: center;
  	align-items: center;
  	height: 100vh;
  }

  /* Dialog */
  .dialogBox {
  	border-radius: 12px !important;
  	margin-top: 0 !important;
  }

  window[role="dialog"] {
  	background: var(--gnome-toolbar-background) !important;
  	border: 0 !important;
  	box-shadow: var(--gnome-menu-shadow) !important;
  	padding: 0 !important;
  	border-radius: 12px !important;
  }

  dialog {
  	padding: 0 !important;
  }

  /* Content */
  .dialog-content-box, #dialogGrid {
  	padding: 24px;
  	padding-bottom: 0;
  }
  #titleContainer {
  	padding: 6px !important;
  	margin-top: 6px !important;
  	justify-content: center !important;
  }
  .titleIcon {
  	background-color: transparent !important;
  }

  #commonDialog[subdialog] description, #commonDialog[subdialog] checkbox {
  	margin: 0 6px !important;
  }

  #bookmarkpropertiesdialog #editBookmarkPanelContent {
  	padding-inline: 6px !important;
  	margin-inline: 6px !important;
  }
  /* Buttons */
  .dialog-button-box {
  	padding: 3px;
  	display: flex !important;
  	border-top: 1px solid var(--gnome-toolbar-border-color) !important;
  }

  .dialog-button-box button:not(#hack) {
  	height: auto !important;
  	max-height: unset !important;
  	padding: 10px 14px !important;
  	margin: 3px !important;
  	border-radius: 6px !important;
  	flex: 1;
  	border: none !important;
  }

  /*.dialog-button-box button:not(:last-of-type) {*/
  /*	border-right: 1px solid var(--gnome-toolbar-border-color) !important;*/
  /*}*/

  /* Buttons borders - only suppor for cancel/ok */
  /*.dialog-button-box button[dlgtype="accept"] {*/
  /*	border-right: 0 !important;*/
  /*	border-left: 0 !important;*/
  /*}*/
  /*.dialog-button-box button[dlgtype="cancel"]:not(#hack) {*/
  /*	border-left: 0 !important;*/
  /*}*/

  /* Hadler dialog */
  #os-default-handler image {
  	display: none !important;
  }
  #os-default-handler .name {
  	font-weight: normal !important;
  }
  /* Overrides: Change the flash color */
  #tabbrowser-tabpanels,
  #tabbrowser-tabpanels[pendingpaint],
  browser {
  	background-color: var(--gnome-browser-before-load-background) !important;
  }

  /* Variables that start with --gnome- are added by me and are assigned
   * to elements somewhere in this code. The rest of the variables are
   * built-in in Firefox, so you need to add an !important if you wanna
   * override them. */

   :root {
  	/* Browser area before a page starts loading */
  	--gnome-browser-before-load-background: #F7F7F7;

  	/* Accent */
  	--gnome-accent-bg: ${blue};
  	--gnome-accent: ${blue-darker};

  	/* Toolbars */
  	--gnome-toolbar-background: #efefef;
  	--gnome-toolbar-color: rgb(46, 52, 54);
  	--gnome-toolbar-border-color: rgba(0, 0, 0, .15);
  	--gnome-toolbar-icon-fill: ${dimblack};
  	--gnome-inactive-toolbar-background: #fafafa;
  	--gnome-inactive-toolbar-color: #d5d0cc;
  	--gnome-inactive-toolbar-border-color: #DCDCDC;
  	--gnome-inactive-toolbar-icon-fill: #929595;

  	/* Sidebar */
  	--gnome-sidebar-background: var(--gnome-toolbar-background);
  	--gnome-inactive-sidebar-background: var(--gnome-sidebar-background);

  	/* Menu */
  	--gnome-menu-background: ${light-white};
  	--gnome-menu-border-color: rgba(0, 0, 0, .2);
  	--gnome-menu-shadow: 0 1px 5px 1px rgba(0,0,0, .09), 0 2px 14px 3px rgba(0,0,0, .05);
  	--gnome-menu-button-hover-background: var(--gnome-button-background);
  	--gnome-menu-separator-color: rgba(0, 0, 0, 0.1);

  	/* Header bar */
  	--gnome-headerbar-background: ${light-white};
  	--gnome-headerbar-border-color: var(--gnome-toolbar-border-color);
  	--gnome-inactive-headerbar-background: #fafafa;
  	--gnome-inactive-headerbar-border-color: var(--gnome-inactive-toolbar-border-color);

  	/* Buttons */
  	--gnome-button-background: rgba(0, 0, 0, .08);
  	--gnome-button-hover-background: rgba(0, 0, 0, .12);
  	--gnome-button-active-background: rgba(0, 0, 0, .24);
  	--gnome-button-flat-hover-background: rgba(0, 0, 0, .056);
  	--gnome-button-flat-active-background: rgba(0, 0, 0, .128);
  	--gnome-button-suggested-action-background: var(--gnome-accent-bg);
  	--gnome-button-destructive-action-background: #e01b24;

  	--gnome-button-close-background: var(--gnome-button-flat-hover-background);
  	--gnome-button-hover-close-background:var(--gnome-button-hover-background);
  	--gnome-button-active-close-background: var(--gnome-button-active-background);

  	/* TitleButtons */
  	--gnome-titlebutton-min-background: ${yellow};
  	--gnome-titlebutton-max-background: ${green};
  	--gnome-titlebutton-close-background: ${red};
  	--gnome-titlebutton-min-hover-background: ${yellow};
  	--gnome-titlebutton-max-hover-background: ${green};
  	--gnome-titlebutton-close-hover-background: ${red};
  	--gnome-titlebutton-min-active-background: ${yellow-darker};
  	--gnome-titlebutton-max-active-background: ${green-darker};
  	--gnome-titlebutton-close-active-background: ${red-darker};

  	/* Entries */
  	--gnome-entry-background: rgba(0, 0, 0, .08);
  	--gnome-entry-color: ${bg-contrast};
  	--gnome-inactive-entry-color: ${bg-contrast};
  	--gnome-focused-urlbar-border-color: rgba(28, 113, 216, .5);
  	--gnome-urlbarView-shadow: 0 1px 5px 1px rgba(0,0,0, .15),
  	                           0 2px 14px 3px rgba(0,0,0, .1),
  	                           0 0 0 1px rgba(0,0,0, .08);

  	/* Switch */
  	--gnome-switch-background: rgba(0, 0, 0, .12);
  	--gnome-switch-slider-background: ${light-white};
  	--gnome-switch-active-background: var(--gnome-accent-bg);
  	--gnome-switch-active-slider-background: ${light-white};

  	/* Tabs */
  	--gnome-tabbar-tab-background: #efefef;
  	--gnome-tabbar-tab-border-color: var(--gnome-toolbar-border-color);
  	--gnome-tabbar-tab-hover-background: #dedede;
  	--gnome-tabbar-tab-active-background: ${light-white};
  	--gnome-tabbar-tab-active-background-contrast: #FAFAFA;
  	--gnome-tabbar-tab-active-hover-background: #fafafa;
  	--gnome-inactive-tabbar-tab-background: #f0f0f0;
  	--gnome-inactive-tabbar-tab-active-background: #FAFAFA;
  	--gnome-tab-button-background: rgba(255, 255, 255, .5);
  	--gnome-tab-button-hover-background: rgba(255, 255, 255, .6);
  	--gnome-tabbar-tab-identity-base-opacity: .1;
  }

  /* Private window colors */
  :root {
  	--gnome-private-accent: ${bg};;

  	/* Toolbars */
  	--gnome-private-toolbar-background: #EAF0F7;
  	--gnome-private-inactive-toolbar-background: var(--gnome-private-toolbar-background);
  	/* Menus */
  	--gnome-private-menu-background: #D7E3F0;
  	/* Header bar */
  	--gnome-private-headerbar-background: #D7E3F0;
  	--gnome-private-inactive-headerbar-background: var(--gnome-private-toolbar-background);

  	/* Text color for Firefox Logo in new private tab */
  	--gnome-private-wordmark: ${dimblack};

  	/* New private tab background */
  	--gnome-private-in-content-page-background: #EAF0F7;

  	/* Private browsing info box */
  	--gnome-private-text-primary-color: ${bg-darker};
  }

  /* Variables that start with --gnome- are added by me and are assigned
   * to elements somewhere in this code. The rest of the variables are
   * built-in in Firefox, so you need to add an !important if you wanna
   * override them. */
   @media (prefers-color-scheme: dark) {
  	:root {
  		/* Browser area before a page starts loading */
  		--gnome-browser-before-load-background: ${bg};

  		/* Accent */
  		--gnome-accent-bg: ${grey};
  		--gnome-accent: ${light-black};

  		/* Toolbars */
  		--gnome-toolbar-background: ${black};
  		--gnome-toolbar-color: ${fg};
  		--gnome-toolbar-border-color: rgba(255, 255, 255, .15);
  		--gnome-toolbar-icon-fill: ${white};
  		--gnome-inactive-toolbar-color: ${grey-lighter};
  		--gnome-inactive-toolbar-background: var(--gnome-toolbar-background);
  		--gnome-inactive-toolbar-border-color: ${bg-contrast};
  		--gnome-inactive-toolbar-icon-fill: ${grey};

  		/* Sidebar */
  		--gnome-sidebar-background: var(--gnome-toolbar-background);
  		--gnome-inactive-sidebar-background: var(--gnome-sidebar-background);

  		/* Menus */
  		--gnome-menu-background: ${bg-lighter};
  		--gnome-menu-border-color: rgba(0, 0, 0, .65);
  		--gnome-menu-shadow: 0 1px 5px 1px rgba(0,0,0, .09),
  		                     0 2px 14px 3px rgba(0,0,0, .05),
  		                     inset 0 0 0 1px rgba(255, 255, 255, 0.1);
  		--gnome-menu-button-hover-background: var(--gnome-button-background);
  		--gnome-menu-separator-color: rgba(255, 255, 255, .1);

  		/* Header bar */
  		--gnome-headerbar-background: ${black};
  		--gnome-headerbar-border-color: var(--gnome-toolbar-border-color);
  		--gnome-inactive-headerbar-background: ${dimblack};
  		--gnome-inactive-headerbar-border-color: var(--gnome-inactive-toolbar-border-color);

  		/* Buttons */
  		--gnome-button-background: rgba(255, 255, 255, .1);
  		--gnome-button-hover-background: rgba(255, 255, 255, .15);
  		--gnome-button-active-background: rgba(255, 255, 255, .3);
  		--gnome-button-flat-hover-background: rgba(255, 255, 255, .07);
  		--gnome-button-flat-active-background: rgba(255, 255, 255, .1);
  		--gnome-button-suggested-action-background: var(--gnome-accent-bg);
  		--gnome-button-destructive-action-background: ${red};

  		--gnome-button-close-background: var(--gnome-button-flat-hover-background);
  		--gnome-button-hover-close-background:var(--gnome-button-hover-background);
  		--gnome-button-active-close-background: var(--gnome-button-active-background);

  		/* TitleButtons */
  		--gnome-titlebutton-min-background: ${yellow};
  		--gnome-titlebutton-max-background: ${green};
  		--gnome-titlebutton-close-background: ${red};
  		--gnome-titlebutton-min-hover-background: ${yellow-darker};
  		--gnome-titlebutton-max-hover-background: ${green-darker};
  		--gnome-titlebutton-close-hover-background: ${red-darker};
  		--gnome-titlebutton-min-active-background: ${yellow};
  		--gnome-titlebutton-max-active-background: ${green};
  		--gnome-titlebutton-close-active-background: ${red};

  		/* Entries */
  		--gnome-entry-background: rgba(255, 255, 255, .08);
  		--gnome-entry-color: ${light-white};
  		--gnome-inactive-entry-color: ${fg};
  		--gnome-focused-urlbar-border-color: rgba(120, 120, 120, .5); /* Same as --gnome-accent but with opacity*/
  		--gnome-urlbarView-shadow: 0 1px 5px 1px rgba(0,0,0, .2),
  		                           0 2px 14px 3px rgba(0,0,0, .15),
  		                           0 0 0 1px rgba(0, 0, 0, 0.75);

  		/* Switch */
  		--gnome-switch-background: rgba(255, 255, 255, .15);
  		--gnome-switch-slider-background: #d2d2d2;
  		--gnome-switch-active-background: var(--gnome-accent-bg);
  		--gnome-switch-active-slider-background: ${light-white};

  		/* Tabs */
  		--gnome-tabbar-tab-background: ${black};
  		--gnome-tabbar-tab-border-color: var(--gnome-toolbar-border-color);
  		--gnome-tabbar-tab-hover-background: ${dimblack};
  		--gnome-tabbar-tab-active-background: ${light-black};
  		--gnome-tabbar-tab-active-background-contrast: ${dimgrey};
  		--gnome-tabbar-tab-active-hover-background: ${dark-grey};
  		--gnome-inactive-tabbar-tab-background: ${black};
  		--gnome-inactive-tabbar-tab-active-background: ${bg-lighter};
  		--gnome-tab-button-background: rgba(0, 0, 0, .5);
  		--gnome-tab-button-hover-background: rgba(0, 0, 0, .6);
  		--gnome-tabbar-tab-identity-base-opacity: 0;
  	}

  	/* Private window colors */
  	:root {
  		--gnome-private-accent: ${dark-grey};;

  		/* Toolbars */
  		--gnome-private-toolbar-background: ${bg-darker};
  		--gnome-private-inactive-toolbar-background: var(--gnome-private-toolbar-background);
  		/* Menus */
  		--gnome-private-menu-background: ${bg-contrast};
  		/* Header bar */
  		--gnome-private-headerbar-background: ${bg-contrast};
  		--gnome-private-inactive-headerbar-background: var(--gnome-private-toolbar-background);

  		/* Text color for Firefox Logo in new private tab */
  		--gnome-private-wordmark: ${light-white};

  		/* New private tab background */
  		--gnome-private-in-content-page-background: ${bg-darker};

  		/* Private browsing info box */
  		--gnome-private-text-primary-color: ${light-white};
  	}
  }

  /* Icons light/dark fix coloring hack filters */
  :root {
  	--gnome-icons-hack-filter: filter: brightness(0) saturate(100%) invert(37%) sepia(8%) saturate(683%) hue-rotate(183deg) brightness(95%) contrast(84%);
  	--gnome-window-icons-hack-filter: filter: brightness(0) saturate(100%) invert(37%) sepia(8%) saturate(683%) hue-rotate(183deg) brightness(95%) contrast(84%);
  }
  @media (prefers-color-scheme: dark) {
  	:root {
  		--gnome-icons-hack-filter: brightness(0) saturate(100%) invert(94%) sepia(11%) saturate(362%) hue-rotate(184deg) brightness(95%) contrast(87%);
  		--gnome-window-icons-hack-filter: brightness(0) saturate(100%) invert(94%) sepia(11%) saturate(362%) hue-rotate(184deg) brightness(95%) contrast(87%);
  	}
  }

  /* OPTIONAL: Use system theme icons instead of Adwaita icons included by theme */
  @supports -moz-bool-pref("gnomeTheme.systemIcons") {
  	/* Window buttons */
  	:root[tabsintitlebar] #titlebar .titlebar-button .toolbarbutton-icon,
  	:root[tabsintitlebar][inFullscreen] #window-controls toolbarbutton .toolbarbutton-icon {
  		filter: var(--gnome-window-icons-hack-filter) !important;
  		width: 16px;
  	}
  	:root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-close .toolbarbutton-icon,
  	:root[tabsintitlebar] #titlebar #titlebar-close .toolbarbutton-icon {
  		list-style-image: url("moz-icon://stock/window-close-symbolic?size=dialog") !important;
  	}
  	:root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-max .toolbarbutton-icon,
  	:root[tabsintitlebar] #titlebar #titlebar-max .toolbarbutton-icon {
  		list-style-image: url("moz-icon://stock/window-maximize-symbolic?size=dialog") !important;
  	}
  	:root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-restore .toolbarbutton-icon {
  		list-style-image: url("moz-icon://stock/window-restore-symbolic?size=dialog") !important;
  	}
  	:root[tabsintitlebar] #titlebar .titlebar-buttonbox .titlebar-min .toolbarbutton-icon,
  	:root[tabsintitlebar] #titlebar #titlebar-min .toolbarbutton-icon {
  		list-style-image: url("moz-icon://stock/window-minimize-symbolic?size=dialog") !important;
  	}
  	:root[tabsintitlebar][inFullscreen] #window-controls #restore-button .toolbarbutton-icon {
  		list-style-image: url("moz-icon://stock/view-restore-symbolic?size=dialog") !important;
  	}

  	/* Toolbars close button */
  	.close-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/window-close-symbolic?size=dialog") !important;
  	}

  	/* Navbar icons */

  	/* Back button */
  	#nav-bar #back-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/go-previous-symbolic?size=dialog") !important;
  	}
  	/* Forward button */
  	#nav-bar #forward-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/go-next-symbolic?size=dialog") !important;
  	}
  	/* Menu button */
  	#PanelUI-menu-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/open-menu-symbolic?size=dialog") !important;
  	}
  	/* New tab button */
  	#new-tab-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/tab-new-symbolic?size=dialog") !important;
  	}
  	/* Home button */
  	#home-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/user-home-symbolic?size=dialog") !important;
  	}
  	/* Preferences button */
  	#preferences-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/preferences-system-symbolic?size=dialog") !important;
  	}
  	/* Fullscreen button */
  	#fullscreen-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/view-fullscreen-symbolic?size=dialog") !important;
  	}
  	/* Zoom out button */
  	#zoom-out-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/zoom-out-symbolic?size=dialog") !important;
  	}
  	/* Zoom in button */
  	#zoom-in-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/zoom-in-symbolic?size=dialog") !important;
  	}
  	/* Developer button */
  	#developer-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/applications-engineering-symbolic?size=dialog") !important;
  	}
  	/* Email link button */
  	#email-link-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/mail-unread-symbolic?size=dialog") !important;
  	}
  	/* Print button */
  	#print-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/printer-symbolic?size=dialog") !important;
  	}
  	/* Addons button */
  	#add-ons-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/application-x-addon-symbolic?size=dialog") !important;
  	}
  	/* Find button */
  	#find-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/edit-find-symbolic?size=dialog") !important;
  	}
  	/* New window button */
  	#new-window-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/window-new-symbolic?size=dialog") !important;
  	}
  	/* Bookmarks menu button */
  	#bookmarks-menu-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/starred-symbolic?size=dialog") !important;
  	}
  	/* History button */
  	#history-panelmenu .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/preferences-system-time-symbolic?size=dialog") !important;
  	}
  	/* All tabs button */
  	#alltabs-button {
  		list-style-image: url("moz-icon://stock/pan-down-symbolic?size=dialog") !important;
  	}
  	#alltabs-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  	}
  	/* Cut button */
  	#cut-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/edit-cut-symbolic?size=dialog") !important;
  	}
  	/* Copy button */
  	#copy-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/edit-copy-symbolic?size=dialog") !important;
  	}
  	/* Paste button */
  	#paste-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/edit-paste-symbolic?size=dialog") !important;
  	}

  	/* Reload */
  	#reload-button,
  	#context-reload .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/view-refresh-symbolic?size=dialog") !important;
  	}
  	/* Stop */
  	#stop-button,
  	#context-stop .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/process-stop-symbolic?size=dialog") !important;
  	}
  	/* Downlaod */
  	#downloads-button,
  	#downloads-indicator-icon .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/folder-download-symbolic?size=dialog") !important;
  	}

  	/* Navbar overflow button */
  	#nav-bar-overflow-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/pan-down-symbolic?size=dialog") !important;
  	}

  	/* Context back button */
  	#context-back .menu-iconic-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/go-previous-symbolic?size=dialog") !important;
  	}
  	/* Context forward button */
  	#context-forward .menu-iconic-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/go-next-symbolic?size=dialog") !important;
  	}

  	/* Main menu buttons icons */
  	#appMenu-zoomReduce-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/zoom-out-symbolic?size=dialog") !important;
  	}
  	#appMenu-zoomEnlarge-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/zoom-in-symbolic?size=dialog") !important;
  	}
  	#appMenu-fullscreen-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/view-fullscreen-symbolic?size=dialog") !important;
  	}
  	#appMenu-cut-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/edit-cut-symbolic?size=dialog") !important;
  	}
  	#appMenu-copy-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/edit-copy-symbolic?size=dialog") !important;
  	}
  	#appMenu-paste-button .toolbarbutton-icon {
  		filter: var(--gnome-icons-hack-filter);
  		list-style-image: url("moz-icon://stock/edit-paste-symbolic?size=dialog") !important;
  	}
  }


  /* Icons light/dark fix coloring hack filters */
  :root {
  	--gnome-convert-icon-to-symbolic-hack-filter: invert(100%) sepia(100%) grayscale(100%) brightness(200%) brightness(85%) invert(100%);
  }
  @media (prefers-color-scheme: dark) {
  	:root {
  		--gnome-convert-icon-to-symbolic-hack-filter: invert(100%) sepia(100%) grayscale(100%) brightness(200%) brightness(85%);
  	}
  }

  /* OPTIONAL: Make all tab icons look kinda like symbolic icons */
  @supports -moz-bool-pref("gnomeTheme.symbolicTabIcons") {
  	tab .tab-icon-image {
  		filter: var(--gnome-convert-icon-to-symbolic-hack-filter);
  	}
  }
  /* GPL-3.9 Copyright (C) 2007 Timvde/UserChrome-Tweaks; Code pulled from https://github.com/Timvde/UserChrome-Tweaks */
  /*
   * Only show close buttons on background tabs when hovering with the mouse
   *
   * Contributor(s): Timvde
   */

  .tabbrowser-tab:not([selected]):not([pinned]) .tab-close-button {
    display: none !important;
  }

  .tabbrowser-tab:not([selected]):not([pinned]):hover .tab-close-button {
    display: -moz-box !important;
  }
  /* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_main_toolbar.css made available under Mozilla Public License v. 2.0
  See the above repository for updates as well as full license text. */

  /* This style hides the main toolbar and shows it when the cursor is over the tabs toolbar as well as whenever the focus is inside nav-bar, such as when urlbar is focused. */

  :root{ --uc-navbar-transform: -40px }
  :root[uidensity="compact"]{ --uc-navbar-transform: -34px }

  #navigator-toolbox > div{ display: contents; }
  :root[sessionrestored] :where(#nav-bar,#PersonalToolbar,#tab-notification-deck,.global-notificationbox){
    transform: translateY(var(--uc-navbar-transform))
  }
  :root:is([customizing],[chromehidden*="toolbar"]) :where(#nav-bar,#PersonalToolbar,#tab-notification-deck,.global-notificationbox){
    transform: none !important;
    opacity: 1 !important;
  }

  #nav-bar:not([customizing]){
    opacity: 0;
    transition:  transform 400ms ease 1.8s, opacity 400ms ease 1.8s !important;
    position: relative;
    z-index: 2;
  }
  #TabsToolbar{ position: relative; z-index: 3 }

  /* Show when toolbox is focused, like when urlbar has received focus */
  #navigator-toolbox:focus-within > .browser-toolbar{
    transform: translateY(0);
    opacity: 1;
    transition-duration: 250ms, 100ms !important;
    transition-delay: 0s !important;
  }
  /* Show when toolbox is hovered */
  #titlebar:hover ~ .browser-toolbar,
  #nav-bar:hover,
  #nav-bar:hover + #PersonalToolbar{
    transform: translateY(0);
    opacity: 1;
    transition-duration: 250ms, 100ms !important;
    transition-delay: 0s !important;
  }

  /* Bookmarks toolbar needs so extra rules */
  #PersonalToolbar{ transition: transform 400ms ease 1.8s !important; position: relative; z-index: 1 }

  /* Move up the content view */
  :root[sessionrestored]:not([inFullscreen]) > body > #browser{ margin-top: var(--uc-navbar-transform); }

  //
  /* -------------------------------------------------------------------------- */
  // https://github.com/Sanatana-Linux/nixos-config/blob/e81d597048f00188400349f4557d0c647fce4feb/settings/home/programs/firefox/userContent-css.nix

  /* Line up tabs with urlbar configured with back/next/reload on compact uidensity: */
  .titlebar-spacer[type="pre-tabs"] {
      width: 21px !important;
  }

  /* Moooar tab space at right */
  .titlebar-spacer[type="post-tabs"] {
      width: 13px !important;
  }

  /* Shorten gap between pinned tabs and normal */
  #tabbrowser-tabs[haspinnedtabs]:not([positionpinnedtabs]) > #tabbrowser-arrowscrollbox > .tabbrowser-tab[first-visible-unpinned-tab] {
      margin-inline-start: 5px !important;
  }

  /* Fixes the gap between tab rows */
  #tabbrowser-tabs .tabbrowser-tab {
      height:34px !important;
  }
  #TabsToolbar {
      padding-bottom:1px
  }

  /* Fix close button right alignment */
  .tabbrowser-tab .tab-close-button {
      transform: translate(1px,0) !important;
      height:20px !important;
      margin-inline-end:0px !important;
      padding:5px !important;
      width:20px !important;
  }

  /* gap above tabs */
  #tabbrowser-tabs {
      padding-top:2px !important;
  }

  /* alignment fix */
  .tabbrowser-tab[first-visible-tab=true] {
      padding-left:2px !important
  }

  /* alignment fix */
  .tab-label-container .tab-text {
      transform:translate(0,-1px)
  }

  /* Removes the side borders from active and inactive tabs. */
  .tabbrowser-tab::after,
  .tabbrowser-tab::before {
      border-left: none !important; /* Remove borders from inactive tabs */
  }

  /* Show X on hover tab in multiline */
  .tabbrowser-tab:not([selected]):not([pinned]):hover .tab-close-button {
  	display: -moz-box !important;
  }

  /* Align new tab button */
  #TabsToolbar .toolbarbutton-1 > .toolbarbutton-icon {
      height:26px !important;
      width:26px !important
  }

  /* Compact tabs */
  .tab-content {
      padding-left:5px !important;
      padding-right:5px !important;
  }

  :root[uidensity="compact"] {
      --tab-min-height:20px;
      --inline-tab-padding:4px
  }

  .tabbrowser-tab {
      --tab-min-height:20px;
  }
  /* -------------------------------------------------------------------------- */

  https://www.reddit.com/r/FirefoxCSS/comments/s4wsww/show_the_number_of_open_tabs_on_the_list_all_tabs/
  /* show tab manager button even when tabs aren't overflowing -
     can instead use browser.tabs.tabmanager.enabled;true as well
     or skip this part if you want to retain the default behaviour */
  #alltabs-button {
      display: -moz-box !important;
  }

  /* tab counter */
  #TabsToolbar-customization-target {
      counter-reset: tabCount;
  }
  .tabbrowser-tab {
      counter-increment: tabCount;
  }
  #alltabs-button > .toolbarbutton-badge-stack > .toolbarbutton-icon {
      visibility: collapse !important;
  }
  #alltabs-button > .toolbarbutton-badge-stack {
      position: relative !important;
  }
  #alltabs-button > .toolbarbutton-badge-stack::before {
      content: counter(tabCount);
      border-bottom: 1px solid var(--toolbarbutton-icon-fill);
      color: var(--toolbarbutton-icon-fill);
      opacity: var(--toolbarbutton-icon-fill-opacity);
      position: absolute;
      bottom: var(--toolbarbutton-inner-padding);
      left: 50%;
      transform: translateX(-50%);
      padding: 0 3px;
  }
  .tabbrowser-tab[fadein]:not([pinned]){
    max-width: 180px !important;
    }
    .tabbrowser-tabs{
      display: inline-flex !important;
        justify-items: start !important;
        justify-content: start !important;
        align-items: left;
      }
''
