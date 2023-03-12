{ colors, ... }:

with colors; ''
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar toolbaritem#PanelUI-button toolbarbutton#PanelUI-menu-button.toolbarbutton-1:hover {
  background-color: #292929!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar toolbaritem#PanelUI-button toolbarbutton#PanelUI-menu-button.toolbarbutton-1[active=true] {
  background-color: #555!important
}
#main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button:hover:not(:active):not([open]) {
  border: 0 solid #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  background-image: none!important
}
#main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button {
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: 0 solid #282828!important;
  background-clip: padding-box!important;
  padding: 0!important;
  -moz-padding-start: 0px!important;
  -moz-padding-end: 0px!important;
  height: 28px!important;
  border-radius: 0!important;
  margin-top: 1px!important;
  margin-left: -5px!important;
  list-style-image: unset!important;
  -moz-image-region: unset!important
}
#main-window[tabsintitlebar] #PanelUI-menu-button::after {
  content: "Firefox"!important;
  font-size: 16px!important
}
#main-window[tabsintitlebar] #PanelUI-menu-button:open::after {
  fill: #e9e9e9!important;
  color: #e9e9e9!important
}
#main-window[tabsintitlebar] #PanelUI-menu-button:hover::after {
  content: "Menu"!important;
  -moz-padding-start: 0px!important;
  -moz-padding-end: 0px!important
}
#main-window[tabsintitlebar] #toolbar-menubar {
  -moz-margin-start: 5px!important
}
#main-window[tabsintitlebar][sizemode=maximized] #toolbar-menubar {
  -moz-margin-start: 5px!important;
  -moz-margin-start: 5px!important
}
#main-window[uidensity=compact][tabsintitlebar] #toolbar-menubar {
  -moz-margin-start: 0px!important
}
#main-window[uidensity=compact][tabsintitlebar][sizemode=maximized] #toolbar-menubar {
  -moz-margin-start: 5px!important
}
#main-window[uidensity=touch][tabsintitlebar] #toolbar-menubar {
  -moz-margin-start 12px!important
}
#main-window[uidensity=touch][tabsintitlebar][sizemode=maximized] #toolbar-menubar {
  -moz-margin-start: 12px!important
}
#main-window[tabsintitlebar] #toolbar-menubar[autohide=true][inactive=true] ~ #TabsToolbar,
#main-window[tabsintitlebar][sizemode=maximized] #toolbar-menubar[autohide=true][inactive=true] ~ #TabsToolbar {
  -moz-padding-start: 00px!important
}
#main-window[uidensity=compact][tabsintitlebar] #toolbar-menubar[autohide=true][inactive=true] ~ #TabsToolbar {
  -moz-padding-start: 0px!important
}
#main-window[uidensity=compact][tabsintitlebar][sizemode=maximized] #toolbar-menubar[autohide=true][inactive=true] ~ #TabsToolbar {
  -moz-padding-start: 00px!important
}
#main-window[uidensity=touch][tabsintitlebar] #toolbar-menubar[autohide=true][inactive=true] ~ #TabsToolbar {
  -moz-padding-start: 0px!important
}
#main-window[uidensity=touch][tabsintitlebar][sizemode=maximized] #toolbar-menubar[autohide=true][inactive=true] ~ #TabsToolbar {
  -moz-padding-start: 0px!important
}
#main-window[tabsintitlebar][sizemode=fullscreen] #TabsToolbar {
  -moz-padding-start: 0px!important
}
#main-window[tabsintitlebar] #toolbar-menubar[autohide=false] ~ #TabsToolbar,
#main-window[tabsintitlebar] #toolbar-menubar[autohide=true]:not([inactive=true]) ~ #TabsToolbar {
  margin-top: 4px!important
}
#main-window[tabsintitlebar] #PanelUI-button {
  -moz-appearance: none!important;
  -moz-box-ordinal-group: 0!important;
  position: fixed!important;
  display: flex!important;
  height: 22px!important;
  margin: 0!important;
  -moz-margin-start: 1px!important;
  border: unset!important;
  box-shadow: unset!important;
  padding-left: 0!important;
  padding-right: 0!important
}
#main-window[tabsintitlebar][sizemode=maximized] #PanelUI-button {
  -moz-margin-start: 0px!important
}
#main-window[tabsintitlebar][sizemode=maximized] #PanelUI-button,
#main-window[tabsintitlebar][sizemode=normal] #PanelUI-button {
  top: 0!important
}
@media (min-resolution:110dpi) {
  #main-window[tabsintitlebar][sizemode=maximized] #PanelUI-button {
    top: 6px!important
  }
}
@media (min-resolution:120dpi) {
  #main-window[tabsintitlebar][sizemode=maximized] #PanelUI-button {
    top: 5px!important
  }
}
@media (min-resolution:140dpi) {
  #main-window[tabsintitlebar][sizemode=normal] #PanelUI-button {
    top: 0!important
  }
  #main-window[tabsintitlebar][sizemode=maximized] #PanelUI-button {
    top: 4px!important
  }
}
@media (min-resolution:160dpi) {
  #main-window[tabsintitlebar][sizemode=maximized] #PanelUI-button {
    top: 2px!important
  }
}
@media (-moz-windows-classic) {
  #main-window[tabsintitlebar][sizemode=maximized] #PanelUI-button {
    top: 2px!important
  }
}
#main-window[tabsintitlebar][sizemode=fullscreen] #PanelUI-button {
  top: 1px!important
}
@media not all and (-moz-os-version:windows-win7) {
  @media not all and (-moz-os-version:windows-win8) {
    @media not all and (-moz-os-version:windows-win10) {
      #main-window[tabsintitlebar][sizemode=maximized] #PanelUI-button {
        top: 0!important
      }
      #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button {
        max-width: 26px!important
      }
    }
  }
}
#main-window[tabsintitlebar][sizemode=fullscreen] #navigator-toolbox[style*="margin-top: -"] #PanelUI-button {
  visibility: collapse!important
}
#main-window[tabsintitlebar] :-moz-any(#PanelUI-button,#PanelUI-menu-button):not([checked]):not([open]):not(:active) > .toolbarbutton-badge-stack,
#main-window[tabsintitlebar] :-moz-any(#PanelUI-button,#PanelUI-menu-button):not([disabled=true]):-moz-any([open],[checked],:hover:active) > .toolbarbutton-badge-stack,
#main-window[tabsintitlebar] :-moz-any(#PanelUI-button,#PanelUI-menu-button):not([disabled=true]):not([checked]):not([open]):not(:active):hover > .toolbarbutton-badge-stack {
  background: unset!important;
  border: 0!important;
  box-shadow: unset!important
}
#main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button .toolbarbutton-badge-stack .toolbarbutton-badge {
  -moz-margin-end: 2px!important;
  margin-top: 0!important;
  -moz-margin-start: -30px!important
}
#main-window[tabsintitlebar]:not([uidensity=compact]):not([uidensity=touch]) #PanelUI-menu-button .toolbarbutton-badge-stack,
#main-window[tabsintitlebar][uidensity=compact] #PanelUI-menu-button .toolbarbutton-badge-stack,
#main-window[tabsintitlebar][uidensity=touch] #PanelUI-menu-button .toolbarbutton-badge-stack {
  padding-top: 0!important;
  padding-bottom: 0!important;
  width: unset!important;
  height: 22px!important
}
#main-window[tabsintitlebar]:not([uidensity=compact]):not([uidensity=touch]) #PanelUI-menu-button .toolbarbutton-icon,
#main-window[tabsintitlebar][uidensity=compact] #PanelUI-menu-button .toolbarbutton-icon,
#main-window[tabsintitlebar][uidensity=touch] #PanelUI-menu-button .toolbarbutton-icon {
  padding: 0!important;
  width: 16px!important;
  height: 16px!important
}
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) #PanelUI-menu-button,
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) .toolbarbutton-1[type=menu-button] #PanelUI-menu-button,
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) toolbaritem #PanelUI-menu-button {
  -moz-appearance: unset!important
}
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) #PanelUI-menu-button:not([type=menu-button]) .toolbarbutton-text,
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) .toolbarbutton-1[type=menu-button] #PanelUI-menu-button .toolbarbutton-text,
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) toolbaritem #PanelUI-menu-button .toolbarbutton-text {
  display: none!important
}
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) #PanelUI-menu-button:not([type=menu-button]),
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) .toolbarbutton-1[type=menu-button] #PanelUI-menu-button,
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) toolbaritem #PanelUI-menu-button:not([type=menu-button]) {
  -moz-box-orient: unset!important;
  min-width: unset!important
}
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) #PanelUI-menu-button:not([type=menu-button]):not(#nav-bar-overflow-button):not(#PlacesChevron) > :-moz-any(.toolbarbutton-icon,.toolbarbutton-badge-stack),
#main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) toolbaritem #PanelUI-menu-button:not(#nav-bar-overflow-button):not(#PlacesChevron) > :-moz-any(.toolbarbutton-icon,.toolbarbutton-badge-stack) {
  opacity: 1!important;
  margin-bottom: unset!important
}
#main-window[tabsintitlebar]::after {
  -moz-margin-start: 5px!important
}
#PanelUI-button #whats-new-menu-button,
#main-window[tabsintitlebar] #PanelUI-button > :not(#PanelUI-menu-button) {
  display: none!important
}
#main-window[tabsintitlebar]:not([uidensity=compact]):not([uidensity=touch]) #PanelUI-menu-button .toolbarbutton-badge-stack,
#main-window[tabsintitlebar]:not([uidensity=compact]):not([uidensity=touch]) #PanelUI-menu-button .toolbarbutton-icon,
#main-window[tabsintitlebar][uidensity=compact] #PanelUI-menu-button .toolbarbutton-badge-stack,
#main-window[tabsintitlebar][uidensity=compact] #PanelUI-menu-button .toolbarbutton-icon,
#main-window[tabsintitlebar][uidensity=touch] #PanelUI-menu-button .toolbarbutton-badge-stack,
#main-window[tabsintitlebar][uidensity=touch] #PanelUI-menu-button .toolbarbutton-icon {
  height: unset!important
}
.tab-icon-overlay[activemedia-blocked]:not([crashed]) {
  border: 1px solid transparent!important
}
#PlacesToolbar,
#PlacesToolbarItems,
#personal-bookmarks {
  -moz-box-pack: center!important;
  padding-left: 3px!important;
  margin-left: -1px!important
}
#tabbrowser-arrowscrollbox {
  --uc-scrollbox-pack: start;
  background: #222 !important;
}
#tabbrowser-arrowscrollbox[overflowing] {
  --uc-scrollbox-pack: start;
  background: #222 !important;
}
scrollbox[orient=horizontal] {
  -moz-box-pack: var(--uc-scrollbox-pack,initial)!important;
  height: 30px!important;
  background: #222 !important;
}
.tab-label-container {
  display: grid;
  justify-content: safe center;
  align-items: safe center;
  display: none!important;
}
.tab-secondary-label {
  -moz-box-pack: center;
  display: none!important;
}
.tab-label,
.tab-secondary-label {
  overflow: hidden;
  display: none!important;
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar toolbarbutton#OtherBookmarks.bookmark-item menupopup#OtherBookmarksPopup menuitem.menuitem-iconic.bookmark-item.menuitem-with-favicon {
  margin: 4px 5px 3px!important;
  padding: 5px 10px 5px 8px!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar toolbarbutton#OtherBookmarks.bookmark-item {
  margin-bottom: -4px!important;
  margin-left: -10px!important;
  margin-right: 3px!important;
  padding: 3px 20px 12px 12px!important
}
.container.infobar::before {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.search-setting-button {
  margin: 0 7px 6px 4px!important;
  border-radius: 1px!important;
  appearance: none!important;
  min-height: 16px!important;
  background-color: #262626!important;
  border: 0 solid #303030!important;
  padding: 3px 6px 2px!important;
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-inline-end: 4px!important
}
.search-setting-button:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container hbox#page-action-buttons hbox#star-button-box.urlbar-page-action {
  margin-bottom: 1px!important
}
* {
  --panel-item-hover-bgcolor: #242424!important;
  --panel-item-active-bgcolor: #242424!important;
  --lwt-toolbar-field-focus: #262626!important;
  --zoom-controls-bgcolor: #222!important;
  --toolbar-color: #222;
  font-size: 12px!important;
  font-family: Oxanium!important;
  font-weight: 400;
  --lwt-toolbar-field-background-color: #232323!important;
  --toolbarbutton-hover-background: transparent!important;
  --in-content-page-background: #202020!important;
  --in-content-text-color: White!important;
  --toolbar-non-lwt-bgcolor: #252525!important;
  --button-bgcolor: #242424;
  --arrowpanel-border-color: #222!important;
  --in-content-text-color: var(--in-content-page-color);
  --in-content-accent-color: #d1d1d1!important;
  --in-content-accent-color-active: #d1d1d1!important;
  --in-content-primary-button-background: #d1d1d1!important;
  --in-content-primary-button-background-hover: #666666!important;
  --in-content-primary-button-background-active: #d1d1d1!important;
  --checkbox-unchecked-bgcolor: #313131!important;
  --checkbox-unchecked-hover-bgcolor: #4d4d4d!important;
  --checkbox-unchecked-active-bgcolor: #9d9d9d!important;
  --checkbox-checked-bgcolor: #d1d1d1!important;
  --checkbox-checked-color: #282828!important;
  --checkbox-checked-border-color: transparent!important;
  --checkbox-checked-hover-bgcolor: #666666!important;
  --checkbox-checked-active-bgcolor: #666666!important;
  --checkbox-border-color: #202020!important;
  --in-content-button-background: #282828!important;
  --in-content-button-background-hover: #313131!important;
  --in-content-deemphasized-text: #f1f1f1!important;
  --in-content-page-color: #bfbfbf!important;
  --in-content-primary-button-text-color: #282828!important;
  --toolbar-non-lwt-bgimage: none!important;
  scrollbar-color: #313131 #121212!important;
  scrollbar-width: thin!important
}
:root:not([uidensity=compact]) .urlbarView-row-inner {
  min-height: 25px!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar vbox.urlbarView div.urlbarView-body-outer div.urlbarView-body-inner div#urlbar-results.urlbarView-results div#urlbarView.urlbarView-row span#urlbarView-inner.urlbarView-row-inner span.urlbarView-no-wrap span.urlbarView-action {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#main-window[sizemode=normal] .urlbarView-row[dynamicType=onboardTabToSearch] > .urlbarView-row-inner {
  width: 97.5%!important
}
#main-window:not([sizemode=normal]) .urlbarView-row[dynamicType=onboardTabToSearch] > .urlbarView-row-inner {
  width: 98.3%!important
}
.permission-popup-permission-icon,
.protections-popup-category-icon {
  width: 23px;
  height: 23px
}
#blocked-permissions-container > .blocked-permission-icon:hover,
#identity-icon:hover,
#permissions-granted-icon:hover,
#tracking-protection-icon:hover,
.sharing-icon:hover {
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
#protections-popup-info-button:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#protections-popup-info-button {
  border: 1px solid #181818!important
}
.panel-info-button > image {
  scale: 125%!important
}
.permission-popup-permission-remove-button:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#tracking-protection-icon-box:hover {
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
.permission-popup-permission-remove-button {
  border: 1px solid #181818!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#star-button {
  scale: 153%!important;
  background: 0 0!important;
  padding-right: 1px!important
}
#star-button:hover {
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#urlbar-go-button:hover,
.search-go-button:hover,
.urlbar-page-action:not([disabled]):hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  border-radius: 1px!important
}
#urlbar-go-button,
.search-go-button,
.urlbar-page-action:not([disabled]) {
  border: 1px solid transparent!important
}
.panel-footer > button:not([disabled])[default] {
  background-color: #d1d1d1!important;
  border: 1px solid #555!important;
  color: #bbb!important
}
.panel-footer > button:not([disabled])[default]:hover {
  background-color: #777!important;
  color: #e9e9e9!important
}
.desktop-notification-icon,
popup-notification-icon[popupid=web-notifications] {
  padding: 1px!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#downloads-button.toolbarbutton-1.chromeclass-toolbar-additional stack.toolbarbutton-badge-stack,
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox.panel-view-body-unscrollable richlistbox#downloadsListBox richlistitem.download-state button.downloadButton.downloadIconShow {
  border: 1px solid #181818!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox.panel-view-body-unscrollable richlistbox#downloadsListBox richlistitem.download-state button.downloadButton:hover.downloadIconShow {
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#downloads-button:hover.toolbarbutton-1.chromeclass-toolbar-additional stack.toolbarbutton-badge-stack {
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#downloads-button.toolbarbutton-1.chromeclass-toolbar-additional stack.toolbarbutton-badge-stack {
  border-radius: 2px!important
}
#tabbrowser-tabs[secondarytext-unsupported] .tab-icon-stack[indicator-replaces-favicon] > :not(.tab-icon-overlay),
:root:not([uidensity=compact]) #tabbrowser-tabs:not([secondarytext-unsupported]) .tabbrowser-tab .tab-icon-stack[indicator-replaces-favicon] > :not(.tab-icon-overlay),
:root:not([uidensity=compact]) #tabbrowser-tabs:not([secondarytext-unsupported]) .tabbrowser-tab:hover .tab-icon-stack[indicator-replaces-favicon] > :not(.tab-icon-overlay),
root[uidensity=compact] .tab-icon-stack[indicator-replaces-favicon] > :not(.tab-icon-overlay) {
  opacity: 1!important
}
.all-tabs-secondary-button[soundplaying][toggle-mute]:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#222,#222),linear-gradient(#202020,#202020),var(--lwt-header-image,none)!important
}
toolbarbutton#scrollbutton-up {
  margin-left: 1px!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target tabs#tabbrowser-tabs arrowscrollbox#tabbrowser-arrowscrollbox tab.tabbrowser-tab stack.tab-stack hbox.tab-content vbox.tab-label-container {
  margin-inline-start: 2px!important;
  display: none!important;
  background: #222 !important;
}
#TabsToolbar:hover #new-tab-button:hover,
#tabs-newtab-button:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[soundplaying]:hover,
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[toggle-mute] {
  scale: 100%!important;
  margin-top: 0!important;
  padding-right: 9px!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important;
  fill: white!important;
  background-size: 20px!important;
  padding-left: 2px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item toolbarbutton.all-tabs-secondary-button[toggle-mute]:hover.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -2px!important;
  padding: 5px!important;
  margin-left: -4px!important;
  fill: white!important;
  list-style-image: url(chrome://global/skin/media/audio.svg)!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important;
  border: 1px solid #d1d1d1!important;
  background-size: 22px!important;
  border-radius: 1px!important;
  background: #222 !important;
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item toolbarbutton.all-tabs-secondary-button[toggle-mute].subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -2px!important;
  padding: 5px!important;
  margin-left: -4px!important;
  fill: white!important;
  list-style-image: url(chrome://global/skin/media/audio-muted.svg)!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important;
  border: 1px solid #555!important;
  background-size: 22px!important;
  border-radius: 1px!important;
  background: #222 !important;
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item toolbarbutton.all-tabs-secondary-button[soundplaying][toggle-mute]:hover.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -2px!important;
  padding: 5px!important;
  margin-left: -4px!important;
  fill: white!important;
  list-style-image: url(chrome://global/skin/media/audio-muted.svg)!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important;
  border: 1px solid #555!important;
  background-size: 22px!important;
  border-radius: 1px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item toolbarbutton.all-tabs-secondary-button[soundplaying].subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -2px!important;
  padding: 5px!important;
  margin-left: -4px!important;
  fill: white!important;
  list-style-image: url(chrome://global/skin/media/audio.svg)!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important;
  border: 1px solid #555!important;
  border-radius: 1px!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[close-button] {
  max-width: 24px!important;
  max-height: 24px!important;
  border: 1px solid #181818!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[close-button]:hover {
  list-style-image: url("Close.png")!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[mute-button] {
  margin-top: -12px!important;
  padding: 5px;
  margin-left: -11px!important;
  scale: 100%!important;
  fill: white!important;
  list-style-image: url(chrome://global/skin/media/audio.svg)!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
.all-tabs-secondary-button[soundplaying] {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.all-tabs-secondary-button[soundplaying]:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important;
  list-style-image: url(chrome://global/skin/media/audio-muted.svg)!important;
  background-color: transparent!important
}
.all-tabs-secondary-button[muted]:hover {
  list-style-image: url(chrome://global/skin/media/audio.svg)!important;
  background-color: transparent!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
#allTabsMenu-allTabsView-tabs {
  padding-bottom: 7px!important
}
#vertical-tabs-pane:not([unpinned]) {
  min-width: 59px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane:not([unpinned]).chromeclass-extrachrome vbox#vertical-tabs-inner-box,
html#main-window body hbox#browser vbox#vertical-tabs-pane[unpinned]:not([hidden]).chromeclass-extrachrome vbox#vertical-tabs-inner-box {
  overflow-y: scroll!important;
  margin-right: -3px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane[unpinned]:not([expanded]).chromeclass-extrachrome vbox#vertical-tabs-inner-box {
  overflow-y: hidden!important;
  margin-right: 2px!important
}
#vertical-tabs-pin-button {
  height: 30px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list {
  margin-top: 4px!important
}
#PanelUI-button > toolbarbutton > stack,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-icon,
.findbar-button {
  border-radius: 2px!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#stop-reload-button.chromeclass-toolbar-additional toolbarbutton#stop-button.toolbarbutton-1 image.toolbarbutton-icon {
  border: 1px solid #181818!important;
  background-image: none!important;
  outline: 0!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#stop-reload-button.chromeclass-toolbar-additional toolbarbutton#stop-button.toolbarbutton-1:hover image.toolbarbutton-icon {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#stop-reload-button.chromeclass-toolbar-additional toolbarbutton#reload-button.toolbarbutton-1 image.toolbarbutton-icon {
  border: 1px solid #181818!important;
  background-image: none!important;
  outline: 0!important
}
#PanelUI-button > toolbarbutton > stack,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional:hover > .toolbarbutton-icon,
.findbar-button,
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#stop-reload-button.chromeclass-toolbar-additional toolbarbutton#reload-button.toolbarbutton-1:hover image.toolbarbutton-icon {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#PanelUI-button > toolbarbutton > stack,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-icon,
.findbar-button {
  border: 1px solid #181818!important
}
#PanelUI-button > toolbarbutton > stack,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional:active > .toolbarbutton-icon,
.findbar-button {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#PanelUI-button > toolbarbutton > stack,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional:not([disabled=true]):is([open],[checked]) > .toolbarbutton-icon,
.findbar-button {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
:is(#screenshot-button,#import-button,#sync-button,#panic-button,#save-page-button,#find-button,#fullscreen-button,#new-window-button,#save-to-pocket-button,#stop-button,#back-button,#forward-button,#webide-button,#PanelUI-menu-button,#nav-bar-overflow-button,#bookmarks-menu-button,#bookmarks-button,#developer-button,#preferences-button,#characterencoding-button,#add-ons-button,#search-go-button,.search-go-button,#urlbar-go-button,.urlbar-go-button,#paste-button,#email-link-button,#reload-button,#sidebar-button,#downloads-button,#open-file-button,#home-button,#feed-button,#history-button,#history-panelmenu,#library-button,#privatebrowsing-button,#print-button,#fxa-toolbar-menu-button)[open=true] {
  fill: #e9e9e9!important
}
#tabbrowser-arrowscrollbox,
#tabbrowser-tabs,
#tabbrowser-tabs[positionpinnedtabs] > #tabbrowser-arrowscrollbox > .tabbrowser-tab[pinned] {
  margin-inline-start: -1px!important
}
#TabsToolbar #firefox-view-button[open]:not(:focus-visible) > .toolbarbutton-icon:-moz-lwtheme,
.tab-background[selected]:not([multiselected=true]):-moz-lwtheme {
  outline: #d1d1d1 solid 0!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#firefox-view-button[open]:not(:focus-visible).toolbarbutton-1.chromeclass-toolbar-additional image.toolbarbutton-icon {
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#firefox-view-button:hover.toolbarbutton-1.chromeclass-toolbar-additional image.toolbarbutton-icon {
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#firefox-view-button.toolbarbutton-1.chromeclass-toolbar-additional image.toolbarbutton-icon {
  outline: #d1d1d1 solid 0!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000080,0 0 0 1px #4040405c inset!important;
  border-radius: 1px!important;
  margin-left: -1px!important;
  padding: 2px!important;
  scale: 118%!important
}
.search-panel-header > label {
  color: #e9e9e9!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#firefox-view-button.toolbarbutton-1.chromeclass-toolbar-additional {
  padding-right: 0!important;
  padding-left: 5px!important
}
#firefox-view-button {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#vertical-tabs-pane[unpinned]:not([hidden]) {
  height: auto!important
}
#tabbrowser-tabs {
  margin-inline-start: 2px!important;
  min-width:90% !important;
  width:99.5% !important;
}
#TabsToolbar{
  margin-left: 0 !important;
  padding-left: 0 !important;
  width:99.5% !important;
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar {
  height: 22px!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#firefox-view-button.toolbarbutton-1.chromeclass-toolbar-additional image.toolbarbutton-icon:hover {
  background-color: #383838!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#firefox-view-button.toolbarbutton-1.chromeclass-toolbar-additional:focus-visible image.toolbarbutton-icon {
  background-color: #353535!important
}
:root:not([privatebrowsingmode=temporary]):not([firefoxviewhidden]) :is(#firefox-view-button,#wrapper-firefox-view-button) + #tabbrowser-tabs {
  border-inline-start: 0px solid color-mix(in srgb,currentColor 25%,transparent)!important
}
#save-to-pocket-button {
  margin-right: 3px!important
}
#sidebar-switcher-target.active,
#sidebar-switcher-target:hover:active {
  background-color: #262626!important
}
#sidebar-switcher-target.active,
#sidebar-switcher-target:hover {
  background-color: #242424!important
}
html#main-window body hbox#browser vbox#sidebar-box.chromeclass-extrachrome box#sidebar-header toolbarbutton#sidebar-switcher-target.tabbable image#sidebar-switcher-arrow {
  margin-right: 2px!important;
  margin-left: -2px!important;
  margin-top: 2px!important
}
html#main-window body hbox#browser vbox#sidebar-box.chromeclass-extrachrome box#sidebar-header toolbarbutton#sidebar-switcher-target.tabbable label#sidebar-title {
  margin-top: 3px!important;
  margin-right: 3px!important;
  margin-left: -5px!important
}
html#main-window body hbox#browser vbox#sidebar-box.chromeclass-extrachrome box#sidebar-header spacer {
  box-shadow: none!important
}
html#main-window body hbox#browser vbox#sidebar-box.chromeclass-extrachrome box#sidebar-header toolbarbutton#sidebar-switcher-target.tabbable image#sidebar-icon {
  width: 18px!important;
  height: 18px!important;
  margin-bottom: -2px!important
}
toolbarbutton#scrollbutton-down,
toolbarbutton#scrollbutton-up {
  margin-bottom: 2px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.tab-background,
.tab-stack {
  margin-top: -2px!important
}
window#places toolbox#placesToolbox toolbar#placesToolbar.chromeclass-toolbar search-textbox#searchFilter:focus {
  outline: 0!important
}
div.container.infobar span.content.notification-content span.notification-button-container button.notification-button.small-button {
  border: none!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar toolbaritem#PanelUI-button toolbarbutton#PanelUI-menu-button.toolbarbutton-1 {
  margin-right: -2px!important;
  margin-left: -5px!important
}
div.container.infobar button.close.ghost-button.notification-close {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-right: 9px!important
}
#reader-mode-button:hover > .urlbar-icon {
  color: #e9e9e9!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_tagsSelectorRow richlistbox#editBMPanel_tagsSelector {
  padding-left: 18px!important;
  padding-top: 18px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_tagsRow hbox button#editBMPanel_tagsSelectorExpander.expander-down.panel-button,
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_tagsRow hbox button#editBMPanel_tagsSelectorExpander.panel-button.expander-up {
  margin-top: 8px!important;
  margin-bottom: -1px!important
}
window#places hbox#placesView vbox#contentView vbox#placesViewsBox richlistbox#downloadsListBox.allDownloadsListBox richlistitem.download.download-state button.downloadButton.downloadIconShow {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox.panel-view-body-unscrollable richlistbox#downloadsListBox richlistitem.download-state button.downloadButton.downloadIconShow {
  margin-right: 10px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.downloadMainArea {
  padding-block: 2px!important
}
html#main-window body popupset#mainPopupSet panel#editBookmarkPanel.panel-no-padding box.panel-header {
  margin-left: -26px!important;
  margin-right: 7px!important
}
#editBookmarkPanel .expander-down,
#editBookmarkPanel .expander-up {
  border: none!important
}
image.textbox-search-sign {
  margin-inline-end: 0!important;
  scale: 130%!important;
  margin-inline-start: 5px!important;
  margin-inline-end: 8px!important
}
#placesToolbar > #back-button:hover > .toolbarbutton-icon,
#placesToolbar > #forward-button:hover > .toolbarbutton-icon {
  fill: white!important;
  background-color: #292929!important
}
window#places toolbox#placesToolbox toolbar#placesToolbar.chromeclass-toolbar toolbarbutton#back-button:hover,
window#places toolbox#placesToolbox toolbar#placesToolbar.chromeclass-toolbar toolbarbutton#forward-button:hover {
  background-color: #292929!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 3px!important
}
.downloadDetails {
  margin-top: 7px!important;
  margin-bottom: -3px!important;
  opacity: 1!important;
  color: #ccc!important
}
window#places hbox#placesView vbox#contentView vbox#placesViewsBox richlistbox#downloadsListBox.allDownloadsListBox richlistitem.download.download-state {
  border-radius: 2px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin: 2px 4px!important
}
#downloadsListBox {
  padding-top: 2px!important
}
window#places hbox#placesView vbox#contentView vbox#placesViewsBox richlistbox#downloadsListBox.allDownloadsListBox {
  border: none!important;
  background-color: #202020!important
}
#PanelUI-menu-button[badge-status=addon-alert] > .toolbarbutton-badge-stack > .toolbarbutton-badge,
#PanelUI-menu-button[badge-status=fxa-needs-authentication] > .toolbarbutton-badge-stack > .toolbarbutton-badge,
#fxa-toolbar-menu-button[badge-status=login_failed] > .toolbarbutton-badge-stack > .toolbarbutton-badge {
  fill: #777777!important;
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.addon-banner-item > .toolbarbutton-text,
.panel-banner-item > .toolbarbutton-text {
  margin-top: 6px!important;
  margin-bottom: 7px!important
}
.addon-banner-item::after {
  margin-top: 12px!important;
  fill: #777777!important
}
.addon-banner-item,
.panel-banner-item {
  background-color: #262626!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 3px!important
}
.addon-banner-item:hover,
.panel-banner-item:hover {
  background-color: #303030!important
}
html#main-window body popupset#mainPopupSet panel#appMenu-popup.cui-widget-panel.panel-no-padding panelmultiview#appMenu-multiView box.panel-viewcontainer box.panel-viewstack panelview#appMenu-protonMainView.PanelUI-subView vbox.panel-subview-body vbox#appMenu-proton-addon-banners toolbarbutton.addon-banner-item {
  margin-top: 15px!important
}
#PlacesChevron {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding-left: 13px!important;
  padding-right: 13px!important;
  margin-right: 9px!important;
  background-color: #282828!important;
  border-radius: 1px!important
}
#tabbrowser-tabs:not([secondarytext-unsupported]) .tab-label-container {
  height: 1.8em!important;
  display: none !important;
}
.notification-button:first-of-type {
  color: #ccc!important
}
.container.infobar::before {
  background-image: linear-gradient(0,#d1d1d10%,#d1d1d152.08%,#d1d1d1100%)!important;
  width: 5px!important
}
.notification-button {
  box-shadow: 0 1px 3px rgba(0,0,0,.23),0 0 0 1px #4848484a inset!important;
  background-color: #353535!important
}
.notification-button:hover {
  color: #e9e9e9!important
}
.notificationbox-stack {
  background-color: #242424!important;
  box-shadow: 0 1px 3px rgba(0,0,0,.23),0 0 0 1px #4848484a inset!important
}
.container.infobar {
  background: #313131!important;
  box-shadow: 0 1px 3px rgba(0,0,0,.23),0 0 0 1px #4848484a inset!important
}
#nav-bar-customization-target > :is(toolbarbutton,toolbaritem):first-child,
#nav-bar-customization-target > toolbarpaletteitem:first-child > :is(toolbarbutton,toolbaritem) {
  padding-inline-start: 0px!important;
  margin-inline-start: -2px!important
}
.titlebar-buttonbox-container {
  padding-right: 0!important;
  padding-left: 28px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-left: -38px!important
}
#identity-box[pageproxystate=valid].chromeUI > .identity-box-button,
#identity-box[pageproxystate=valid].extensionPage > .identity-box-button,
#identity-box[pageproxystate=valid].notSecureText > .identity-box-button,
#urlbar-label-box {
  padding-bottom: 4px!important;
  padding-top: 4px!important;
  margin: -1px -4px!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#identity-box.chromeUI box#identity-icon-box.identity-box-button {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#urlbar-input,
.searchbar-textbox {
  margin-top: 3px!important
}
.titlebar-button > .toolbarbutton-icon {
  scale: 202%!important
}
.titlebar-min {
  margin: 0 12px 0 -4px!important;
  padding-bottom: 8px!important
}
.titlebar-max {
  margin: 0 12px 0 -7px!important;
  padding-left: 0!important;
  padding-right: 0!important;
  padding-bottom: 8px!important
}
.titlebar-restore {
  margin: 0 12px 0 -7px!important;
  padding-left: 0!important;
  padding-right: 0!important;
  padding-bottom: 8px!important
}
.titlebar-close {
  margin: 0 0 0 18px!important
}
.titlebar-close:hover {
  background-color: #d1d1d1!important
}
.search-panel-tree > .autocomplete-richlistitem {
  background-color: #222!important
}
:is(menupopup,panel)[type=arrow] {
  --panel-border-radius: 0px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-top: 2px!important
}
html#main-window body hbox#browser vbox#appcontent tabbox#tabbrowser-tabbox tabpanels#tabbrowser-tabpanels.plain hbox#panel-1-1.browserSidebarContainer vbox.browserContainer findbar hbox.findbar-container {
  min-width: 100px!important;
  max-width: none !important;
}
.sidebar{
    min-width: 100px!important;
    max-width: none !important;
}
#reader-mode-button {
  padding-right: 0!important
}
#PlacesToolbar menupopup[placespopup=true] menuseparator::before {
  border-top: 0 solid #282828!important
}
#urlbar-go-button:hover:active,
.search-go-button:hover:active,
.urlbar-page-action:not([disabled]):hover:active,
.urlbar-page-action:not([disabled])[open] {
  background-color: #383838!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#urlbar-go-button:active,
.search-go-button:active,
.urlbar-page-action:not([disabled]):active,
.urlbar-page-action:not([disabled])[open] {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#findbar-close-container {
  background-color: #222!important
}
.close-icon.findbar-closebutton {
  background-color: #282828!important;
  color: #e9e9e9!important
}
:root:not([lwtheme-image]) .browserContainer > findbar:-moz-lwtheme,
:root:not([lwtheme-image]) .browserContainer > findbar:-moz-lwtheme > #findbar-close-container {
  background-image: none!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button {
  max-width: 22px!important;
  max-height: 22px!important;
  margin-inline-end: 8.5px!important
}
#vertical-tabs-list .all-tabs-item:hover .all-tabs-secondary-button[close-button] {
  opacity: 1!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[toggle-mute][hidden] {
  margin-inline-start: -26px!important;
  transform: translateX(14px);
  opacity: 0!important
}
.login-icon,
.popup-notification-icon[popupid=password] {
  scale: 124%!important
}
.popup-notification-primary-button {
  color: #ccc!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.popup-notification-primary-button:hover {
  color: #e9e9e9!important
}
.popup-notification-body input {
  background-color: #282828!important
}
.protections-popup-tp-switch::before {
  background: #222!important;
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #222!important;
  outline: rgba(0,0,0,.15) solid 1px!important
}
.protections-popup-tp-switch[enabled] {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.protections-popup-tp-switch[enabled]:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
.protections-popup-tp-switch:not([enabled]) {
  background-color: #343434!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: 0 solid #222!important
}
.protections-popup-tp-switch:not([enabled]):hover {
  background-color: #404040!important
}
toolbarpaletteitem[place=toolbar] > toolbarspring {
  outline: #555555 dashed 1px!important;
  outline-offset: -2px!important;
  opacity: .8!important
}
#PersonalToolbar[customizing] {
  outline-offset: -1px!important;
  opacity: .8!important;
  outline: #555555 dashed 1px!important
}
#customization-panelWrapper > .panel-arrowbox > .panel-arrow[side=top] {
  fill: #d1d1d1!important;
  stroke: #d1d1d1!important;
  stroke: #4f4f52!important
}
.urlbarView-row:is([type=switchtab],[type=remotetab]) > .urlbarView-row-inner > .urlbarView-no-wrap > .urlbarView-action {
  color: #e9e9e9!important;
  background-color: #282828!important;
  border-radius: 2px!important;
  padding: 0 7px!important
}
#editBookmarkPanelBottomButtons > button {
  padding: 5px 31px 3px 33px!important;
  border-radius: 3px!important
}
#tracking-protection-icon-container:hover:not([open=true]),
.identity-box-button:hover:not([open=true]) {
  fill: #e9e9e9!important;
  color: #e9e9e9!important;
  background-color: transparent!important
}
.titlebar-buttonbox {
  background-color: #242424!important;
  padding-left: 1px!important;
  margin-left: -29px!important;
  margin-bottom: 1px!important
}
menupopup,
panel {
  --windows-panel-box-shadow: 0px 0px 3px hsla(0,0%,0%,0.6)!important
}
#alltabs-button {
  margin-bottom: 0!important;
  background-color: #242424!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-left: 2px!important;
  border: 1px solid #181818!important
}
#alltabs-button[open] {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#alltabs-button:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  margin-bottom: 0!important
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#alltabs-button.toolbarbutton-1.chromeclass-toolbar-additional.tabs-alltabs-button stack.toolbarbutton-badge-stack {
  scale: 152%!important;
  background-color: transparent!important
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#new-tab-button.toolbarbutton-1.chromeclass-toolbar-additional image.toolbarbutton-icon {
  scale: 138%!important;
  background-color: transparent!important
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#new-tab-button.toolbarbutton-1.chromeclass-toolbar-additional image.toolbarbutton-icon[active=true] {
  background-color: transparent!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox#downloadsFooter stack vbox#downloadsFooterButtons button#downloadsHistory.downloadsPanelFooterButton.subviewbutton.panel-subview-footer-button.toolbarbutton-1 {
  padding: 10px 15px 8px!important;
  margin: 1px -6px -4px!important;
  border-radius: 1px!important
}
#urlbar-input::placeholder,
.searchbar-textbox::placeholder {
  opacity: 1!important
}
:root[tabsintitlebar] #toolbar-menubar[autohide=true]:not([inactive=true]) {
  height: 30px!important
}
.tab-icon-image {
  margin-left: 3px!important;
  margin-inline-start: -2px!important
}
.popup-notification-panel {
  margin-top: 4em!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 4px!important
}
#organizeButton {
  margin-top: 10px!important;
  margin-bottom: 5px!important;
  margin-left: 10px!important;
  padding-left: 10px!important
}
.close-icon:hover {
  background-color: color-mix(in srgb,currentColor 5%,transparent)!important
}
.panel-subview-footer-button {
  padding: 3px 0 1px 9px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box hbox#vertical-tabs-buttons-row toolbarbutton#vertical-tabs-new-tab-button.subviewbutton.subviewbutton-iconic label.toolbarbutton-text {
  text-align: center!important;
  margin-left: 36px!important;
  display: hidden!important;
}
.tab-text {
  margin-top: 2px!important;
  display: hidden!important;
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic label.toolbarbutton-text {
  text-align: center!important
}
#editBookmarkPanelRows .expander-down > .button-box,
#editBookmarkPanelRows .expander-up > .button-box {
  padding: 5px!important
}
#editBookmarkPanelRows .expander-down:hover,
#editBookmarkPanelRows .expander-up:hover {
  background-color: #242424!important
}
#placesMenu > menu {
  border-radius: 6px!important
}
panelmultiview {
  padding: 4px 4px 2px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
:root {
  --default-focusring: var(--default-focusring-width)!important;
  --default-focusring-width: 5px!important;
  --arrowpanel-border-radius: 0px!important;
  --panel-separator-zap-gradient: linear-gradient(90deg, #282828 0%, #282828 52.08%, #282828 100%)!important;
  --panel-subview-body-padding: 0px 0!important
}
#identity-popup-mainView .subviewbutton-nav::after,
#protections-popup-mainView .subviewbutton-nav:not(.notFound)::after,
.PanelUI-subView .subviewbutton-nav::after,
.widget-overflow-list .subviewbutton-nav::after {
  margin-right: 1px!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[activemedia-blocked] {
  list-style-image: none!important;
  background-repeat: no-repeat!important;
  background-size: 15px!important;
  background-position: 4.5px center!important;
  transform: none!important;
  opacity: 1!important;
  margin-inline-start: -2px!important;
  scale: 100%!important;
  padding-left: 7px!important;
  padding-right: 9px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
html#main-window body popupset#mainPopupSet panel#editBookmarkPanel.panel-no-padding vbox.panel-subview-body vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_folderRow hbox menulist#editBMPanel_folderMenuList.folder-icon menupopup.in-menulist menuitem {
  padding-top: 1px!important;
  padding-bottom: 1px!important;
  border: 0 solid #282828!important
}
arrowscrollbox.menupopup-arrowscrollbox {
  background-image: none!important;
  background-color: #222!important
}
#ContentSelectDropdown > menupopup {
  background-image: none!important
}
html#main-window body popupset#mainPopupSet panel#permission-popup.panel-no-padding panelmultiview#permission-popup-multiView box.panel-viewcontainer box.panel-viewstack panelview#permission-popup-mainView hbox.permission-popup-section vbox#permission-popup-permissions-content vbox#permission-popup-permission-list vbox#permission-popup-permission-list-default-anchor.permission-popup-permission-list-anchor vbox#permission-popup-container.permission-popup-permission-item-container hbox.permission-popup-permission-item.permission-popup-permission-item-autoplay-media menulist#permission-popup-menulist menupopup.in-menulist menuitem {
  color: #e9e9e9!important;
  -moz-appearance: none!important;
  margin: 2px 4px!important;
  padding: 5px 10px 5px 1px!important
}
.identity-popup-security-connection.identity-button {
  padding: 1px!important;
  background-position-x: 4px!important;
  margin-inline-end: 5px!important;
  background-position-y: 0px!important
}
.protections-popup-category,
.protections-popup-footer-button {
  min-height: 24px!important
}
#protections-popup-blocking-section-header,
#protections-popup-not-blocking-section-header,
#protections-popup-not-found-section-header,
#protections-popup-tp-switch-section,
.protections-popup-category,
.protections-popup-footer-button {
  padding: 0 6px!important;
  margin: 4px 0!important
}
.urlbarView {
  margin-inline: calc(2px + var(--urlbar-container-padding))!important;
  border-inline: 0px solid transparent!important;
  width: calc(100% - 2 * (2px + var(--urlbar-container-padding)))!important
}
:root[tabsintitlebar][sizemode=normal] #toolbar-menubar[autohide=true][inactive=true] {
  height: 0!important
}
:root[tabsintitlebar][sizemode=normal] #toolbar-menubar[autohide=true] {
  height: 30px!important
}
#main-menubar > menu {
  margin-right: 2px!important;
  margin-top: 7px!important;
  margin-left: 2px!important;
  padding: 3px 20px 2px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#toolbar-menubar.browser-toolbar.chromeclass-menubar.titlebar-color.customization-target spacer {
  box-shadow: none!important;
  margin-right: 45px!important;
  margin-left: 7px!important;
  background-color: #202020!important
}
#navigator-toolbox,
.browser-toolbar {
  background-color: #202020!important
}
#navigator-toolbox:-moz-window-inactive:-moz-lwtheme {
  background-color: #202020!important
}
#TabsToolbar {
  margin-inline-start: 103px!important
  width:90% !important;
}
#appMenu-popup {
  margin-top: 94px!important;
  transition: .2s ease-in-out!important;
  margin-inline: -262px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar vbox.urlbarView div.urlbarView-body-outer div.urlbarView-body-inner div#urlbar-results.urlbarView-results div.urlbarView-row:hover {
  color: #e9e9e9!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar vbox.urlbarView div.urlbarView-body-outer div.urlbarView-body-inner div#urlbar-results.urlbarView-results div.urlbarView-row .urlbarView-action {
  color: #e9e9e9!important;
  border-radius: 2px!important;
  margin-left: -7px!important;
  padding: 5px 7px 1px!important
}
.urlbarView-row:not([type=tip],[type=dynamic]) {
  min-height: 28px!important
}
#PopupAutoCompleteRichResult .autocomplete-richlistitem:not([actiontype=searchengine]):hover .ac-title,
.urlbarView-row:not([type=search]):hover .urlbarView-title,
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar vbox.urlbarView div.urlbarView-body-outer div.urlbarView-body-inner div#urlbar-results.urlbarView-results .urlbarView-row:hover .urlbarView-row-inner span.urlbarView-url {
  color: #e9e9e9!important;
  font-weight: 400!important
}
.urlbarView-row-inner {
  padding-block: 4px!important;
  margin-left: 2px!important;
  margin-right: 2px!important
}
.urlbarView-row[selected] > .urlbarView-row-inner:hover {
  background-color: #2b2b2b!important
}
.urlbarView-row[selected] > .urlbarView-row-inner {
  border-radius: 0!important;
  padding-block: 4px!important;
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: 0 solid #282828!important
}
#PopupAutoCompleteRichResult .autocomplete-richlistitem:not([actiontype=searchengine]) .ac-title,
.urlbarView-row:not([type=search]) .urlbarView-title {
  color: #e9e9e9!important;
  margin-top: -1px!important;
  margin-bottom: -1px!important;
  padding: 3px 0 2px 3px!important;
  font-weight: 400!important
}
.urlbarView-row:hover > .urlbarView-row-inner {
  background-color: #2b2b2b!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 0!important
}
.widget-overflow-list .toolbarbutton-1 {
  padding: 0 8px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox toolbarbutton#OtherBookmarks.bookmark-item menupopup#OtherBookmarksPopup menuitem.menuitem-iconic.bookmark-item.menuitem-with-favicon {
  margin: 3px 4px!important;
  padding: 1px 10px 1px 1px!important
}
.search-panel-current-engine {
  text-align: left!important
}
window dialog#handling vbox#chooser richlistbox#items richlistitem#item-choose button {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: 0 solid #282828!important;
  background-color: #222!important
}
window dialog#handling vbox#chooser richlistbox#items richlistitem#item-choose button:hover {
  background-color: #282828!important
}
toolbarbutton:focus-visible {
  outline: dotted 0;
  outline-offset: -2px
}
#urlbar #urlbar-input {
  font-weight: 300!important;
  text-align: center!important;
  padding-left: 5px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#itemsCountBox spacer {
  box-shadow: none!important
}
#placesMenu menupopup menu,
#placesMenu menupopup menuitem {
  margin: 2px 6px!important;
  padding: 5px 9px!important;
  border-radius: 0!important
}
.PanelUI-subView .subviewbutton-nav::after,
.subviewbutton[shortcut]::after,
.widget-overflow-list .subviewbutton-nav::after {
  margin-inline-start: -8px!important
}
#appMenu-zoom-controls2 > .subviewbutton:hover {
  background-color: #282828!important
}
#PanelUI-historyItems > toolbarbutton,
.PanelUI-remotetabs-clientcontainer > toolbarbutton[itemtype=tab] {
  padding-top: 5px!important;
  padding-bottom: 5px!important
}
#blocked-permissions-container > .blocked-permission-icon {
  padding: 0 2px!important;
  scale: 123%!important;
  margin: 3px 2px 3px 5px!important
}
#BMB_bookmarksPopup menupopup[placespopup=true] {
  margin-top: 0;
  border: 0 solid #282828!important
}
menu:hover,
menuitem:hover {
  background-color: #282828!important;
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 0!important
}
menu[_moz-menuactive=true],
menuitem[_moz-menuactive=true] {
  background-color: #282828!important;
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 1px!important
}
menupopup {
  -moz-appearance: none!important;
  background-color: #222!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding-top: 2px!important;
  padding-bottom: 2px!important;
  border: 0 solid #282828!important
}
menuseparator {
  -moz-appearance: none!important;
  max-height: 1px!important;
  border: none!important;
  padding: .5px 0!important;
  margin: 0 5px!important;
  background-color: #262626!important
}
menu,
menuitem {
  color: #e9e9e9!important;
  -moz-appearance: none!important;
  margin: 2px 4px 2px 2px!important;
  padding: 5px 10px 5px 1px!important
}
html#main-window body popupset#mainPopupSet menulist#ContentSelectDropdown menupopup.in-menulist menuitem {
  color: #e9e9e9!important;
  -moz-appearance: none!important;
  margin: 2px 4px!important;
  padding: 2px 10px!important
}
menuitem {
  border-radius: 0!important
}
#context-navigation > .menuitem-iconic {
  border-radius: 0!important;
  margin: 5px!important;
  padding: 0!important
}
menugroup {
  padding: 0!important;
  background-color: transparent!important
}
.menu-right {
  -moz-appearance: none!important;
  margin-right: 0!important;
  margin-left: 0!important;
  color: #e9e9e9!important
}
#bookmarkpropertiesdialog .expander-down,
#bookmarkpropertiesdialog .expander-up {
  border-radius: 3px!important;
  margin-top: 8px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-left: 8px!important;
  padding-right: 18px!important;
  padding-left: 18px!important;
  min-height: 24px;
  height: 10px!important
}
hbox.dialog-button-box spacer.button-spacer {
  box-shadow: none!important
}
#urlbar-input-container[pageproxystate=valid] > #tracking-protection-icon-container > #tracking-protection-icon-box > #tracking-protection-icon {
  fill: white!important;
  margin-top: 1px!important;
  margin-bottom: 1px!important;
  padding: 0!important;
  width: 22px!important
}
#identity-box,
#tracking-protection-icon-container {
  margin-right: 2px!important;
  margin-left: -1px!important;
  padding-left: 2px!important;
  padding-right: 2px!important
}
#reader-mode-button > .urlbar-icon {
  margin-right: 6px!important;
  scale: 151%!important;
  padding-right: 2px!important;
  padding-bottom: 1px!important
}
.popup-notification-closebutton:hover {
  background-color: #282828!important
}
#identity-icon {
  scale: 100%!important
}
.identity-box-button {
  fill: #e9e9e9!important;
  padding-left: 1px!important;
  padding-right: 1px!important
}
#reader-mode-button[readeractive] > .urlbar-icon {
  fill: #666666!important
}
#reader-mode-button {
  border-radius: 0!important
}
.blocked-permission-icon:focus-visible,
.notification-anchor-icon:focus-visible {
  outline: 0!important;
  box-shadow: none!important
}
#identity-permission-box {
  margin-left: 4px!important
}
.desktop-notification-icon,
.popup-notification-icon[popupid=web-notifications] {
  padding: 0 5px!important;
  scale: 118%!important;
  margin: 4px 2px 4px 8px!important
}
.desktop-notification-icon:hover,
popup-notification-icon[popupid=web-notifications] {
  background: 0 0!important;
  color: #555!important;
  outline-offset: 1px!important;
  outline: transparent 1px!important
}
#blocked-permissions-container > .blocked-permission-icon,
#identity-icon,
#permissions-granted-icon,
#tracking-protection-icon,
.sharing-icon {
  width: 20px!important;
  height: 20px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#identity-box.chromeUI box#identity-icon-box.identity-box-button image#identity-icon {
  width: 17px!important;
  height: 20px!important;
  scale: 127%!important
}
#tracking-protection-icon-box {
  width: 22px!important;
  height: 22px!important
}
.searchbar-textbox {
  margin-top: 3px!important;
  text-align: center!important
}
.searchbar-search-button:not([addengines=true]):hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
.searchbar-search-button:not([addengines=true]) {
  scale: 99%!important;
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #444444!important
}
#identity-box {
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#tracking-protection-icon-container:hover:active,
#tracking-protection-icon-container[open=true],
.identity-box-button:hover:active,
.identity-box-button[open=true] {
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important
}
#vertical-tabs-pane {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding-inline: 9px!important;
  background-color: #202020!important;
  color: #e9e9e9!important;
  font-weight: 400!important;
  --vertical-tabs-padding: 13px!important;
  border-inline-width: 0px 0!important;
  --collapsed-pane-width: 58px!important;
  padding-right: 8px!important;
  padding-left: 15px!important;
  margin-inline-end: -4px!important
}
.popup-notification-button {
  color: #e9e9e9
}
html#main-window body box#customization-container box#customization-content-container box#customization-palette-container spacer#customization-spacer,
html#main-window body box#customization-container hbox#customization-footer spacer#customization-footer-spacer {
  box-shadow: none!important
}
#appMenu-fxa-status2[fxastatus] > #appMenu-fxa-label2 {
  -moz-box-flex: 1;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-right: 6px!important;
  margin-left: 6px!important;
  padding-left: 13px!important;
  padding-top: 10px!important;
  padding-bottom: 10px!important;
  border-radius: 3px!important;
  text-align: center!important
}
.dialog-button-box > button {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#allTabsMenu-allTabsView {
  padding: 0!important;
  margin: -3px!important
}
.urlbarView-tail-prefix > .urlbarView-tail-prefix-string {
  visibility: show!important
}
#customizationui-widget-multiview panelview:not([extension]) {
  max-width: 30em!important
}
#allTabsMenu-allTabsViewTabs > .all-tabs-item {
  filter: grayscale(100%)!important;
  margin: 3px!important;
  padding-right: 0!important;
  padding-bottom: 0!important;
  padding-left: 0!important
}
#customizationui-widget-panel {
  margin-top: 0!important
}
#allTabsMenu-allTabsViewTabs {
  padding-bottom: 0!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#appMenu-libraryView.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body toolbarbutton#appMenu-library-bookmarks-button.subviewbutton.subviewbutton-nav,
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#appMenu-libraryView.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body toolbarbutton#appMenu-library-downloads-button.subviewbutton,
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#appMenu-libraryView.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body toolbarbutton#appMenu-library-history-button.subviewbutton.subviewbutton-nav {
  padding: 0 6px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#allTabsMenu-allTabsView.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body toolbarbutton#allTabsMenu-searchTabs.subviewbutton {
  padding-left: 10px!important;
  padding-top: 3px!important;
  padding-bottom: 0!important;
  margin-top: 7px!important;
  margin-left: 5px!important;
  margin-right: 5px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#allTabsMenu-allTabsView.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body vbox#allTabsMenu-allTabsViewTabs.panel-subview-body toolbaritem.all-tabs-item toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic {
  padding: 0 6px!important;
  margin: -3px 0 2px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#allTabsMenu-allTabsView.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body vbox#allTabsMenu-allTabsViewTabs.panel-subview-body toolbaritem.all-tabs-item toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic:hover {
  color: #e9e9e9!important
}
tml#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#allTabsMenu-allTabsView.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body {
  background-color: #222!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#allTabsMenu-allTabsView.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body vbox#allTabsMenu-allTabsViewTabs.panel-subview-body toolbaritem.all-tabs-item toolbarbutton.all-tabs-secondary-button.subviewbutton.subviewbutton-iconic {
  padding-inline-start: 19px!important;
  padding-inline-end: 1px!important;
  scale: 86%!important;
  margin-top: -6px!important
}
#main-window[inFullscreen=true] #vertical-tabs-pane {
  display: none!important;
  width: 0!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[soundplaying][toggle-mute]:is(:hover,:focus-within) {
  list-style-image: none!important;
  background-size: 14px!important;
  background-repeat: no-repeat!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[soundplaying] {
  transform: none!important;
  opacity: 1!important;
  margin-inline-start: -2px!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[muted] {
  list-style-image: none!important;
  background-repeat: no-repeat!important;
  transform: none!important;
  opacity: 1!important;
  margin-inline-start: -2px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#vertical-tabs-list > .all-tabs-item:not(:hover,:focus-within) .all-tabs-secondary-button[pictureinpicture] {
  list-style-image: none!important;
  background-repeat: no-repeat!important;
  border-radius: 1px!important
}
#PanelUI-fxa,
#appMenu-popup panelview {
  padding-left: 5px!important;
  padding-right: 5px!important;
  margin: -8px -9px 0 -6px!important;
  border-radius: 4px!important;
}
html#main-window body popupset#mainPopupSet panel#appMenu-popup.cui-widget-panel.panel-no-padding panelmultiview#appMenu-multiView box.panel-viewcontainer box.panel-viewstack panelview#appMenu-protonMainView.PanelUI-subView vbox.panel-subview-body toolbarbutton {
  margin: 2px 5px 2px 2px!important;
  padding: 2px 7px 0!important;
  border-radius: 1px!important
}
.browserContainer > findbar {
  margin-bottom: -4px!important;
  padding-top: 3px!important
}
.findbar-textbox {
  margin: 3px 2px 4px!important
}
.findbar-find-next,
.findbar-find-previous {
  scale: 85%!important
}
.urlbarView-results {
  color: #e9e9e9!important
}
#TabsToolbar .toolbarbutton-1 {
  padding-left: 5px!important;
  padding-right: 5px!important;
  margin-top: 0!important;
  margin-right: 0!important;
  margin-bottom: 2px!important
}
#ContentSelectDropdown > menupopup > menucaption,
#ContentSelectDropdown > menupopup > menuitem {
  background-color: #222!important;
  color: #e9e9e9!important
}
tooltip {
  color: #e9e9e9!important;
  background-color: #222!important;
  border: none!important;
  font-size: 10px!important;
  opacity: 1!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  fill: #e9e9e9!important;
  margin: 4px!important;
  -moz-appearance: none!important
}
treechildren::-moz-tree-row(selected,current) {
  border: 0 dotted #d1d1d1!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
treechildren::-moz-tree-row(selected,current,focus) {
  border: 0 dotted #d1d1d1!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#sidebarMenu-popup .subviewbutton {
  min-width: 190px;
  BORDER-RADIUS: 1px!important;
  padding: 1px 8px
}
.tabbrowser-tab[selected=true] .tab-text {
  margin-top: 2px!important;
  display: hidden!important;
}
spacer {
  width: 8px;
  background-image: none!important;
  background-repeat: no-repeat;
  background-position: -3px;
  border-left: #282828!important;
  pointer-events: none;
  position: relative;
  z-index: 3;
  border-bottom: .5px solid transparent;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.subviewbutton,
.widget-overflow-list .toolbarbutton-1 {
  margin: 2px!important
}
menu[_moz-menuactive=true][disabled=true],
menu[disabled=true]:hover,
menuitem[_moz-menuactive=true][disabled=true],
menuitem[disabled=true]:hover {
  background-color: #202020!important
}
menu[_moz-menuactive=true][disabled=true],
menu[disabled=true],
menuitem[_moz-menuactive=true][disabled=true],
menuitem[disabled=true] {
  opacity: .4!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#bookmarks-menu-button.toolbarbutton-1.chromeclass-toolbar-additional.subviewbutton-nav menupopup#BMB_bookmarksPopup.cui-widget-panel.cui-widget-panelview.cui-widget-panelWithFooter.PanelUI-subView menu.menu-iconic.bookmark-item.subviewbutton menupopup menuitem.menuitem-iconic.bookmark-item.menuitem-with-favicon.subviewbutton {
  text-align: center!important;
  margin-right: 0px!important
}
#BMB_bookmarksPopup menupopup {
  padding: var(--panel-subview-body-padding);
  background-color: #222!important;
  border: 1px solid #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 0!important;
  margin-top: 3px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox toolbarbutton#OtherBookmarks.bookmark-item {
  max-height: 4px!important;
  border-radius: 2px!important;
  margin-left: -2px!important;
  padding: 1px 6px 1px 10px!important;
  margin-right: 3px!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  max-width: 1em!important
}
toolbarbutton.bookmark-item:not(.subviewbutton) {
  -moz-context-properties: fill;
  fill: currentColor;
  background-color: #2b2b2b!important;
  max-height: 4px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 1px!important;
  margin-left: -2px!important;
  padding: 9px 20px 6px!important;
  margin-bottom: 5px!important;
  border: 1px solid #181818!important
}
toolbarbutton.bookmark-item:not(.subviewbutton):hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
toolbarbutton.bookmark-item {
  box-shadow: none!important;
  margin: 2px 3px 2px 0!important;
  background-color: #222!important;
  filter: grayscale(100%)!important;
  border-radius: 2px!important;
  padding: 3px 10px 3px 18px!important;
  filter: grayscale(0%)!important
}
#BMB_bookmarksPopup {
  box-shadow: none!important
}
@-moz-document url("chrome://browser/content/places/places.xhtml") {
  #editBMPanel_tagsSelectorRow > richlistbox > .expander-up,
  .expander-down {
    border: 0 solid #282828!important;
    margin: 3px 6px -5px 7px!important;
    padding: 3px 7px 3px 20px!important;
    -moz-context-properties: fill!important;
    fill: #e9e9e9!important;
    box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
    -moz-appearance: none!important;
    background-color: #222!important;
    border-radius: 0!important
  }
  #editBMPanel_tagsSelectorRow > richlistbox > .expander-down,
  .expander-up {
    border: 0 solid #282828!important;
    margin: 3px 6px -6px 7px!important;
    padding: 4px 7px 4px 20px!important;
    fill: #e9e9e9!important;
    -moz-context-properties: fill!important;
    fill: #e9e9e9!important;
    box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
    -moz-appearance: none!important;
    background-color: #222!important;
    border-radius: 0!important
  }
  treechildren::-moz-tree-row(selected,current) {
    border-color: #222!important
  }
  treechildren::-moz-tree-row(selected,current,focus) {
    border-color: #222!important
  }
}
#placesMenu > menu {
  padding: 3px 3px 3px 10px!important;
  color: #e9e9e9!important;
  background-color: #242424!important;
  -moz-appearance: none!important
}
#placesMenu > menu:hover {
  color: #d1d1d1!important;
  background-color: #282828!important
}
#bookmarksPanel,
#history-panel {
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.customization-lwtheme-menu-theme,
.customization-uidensity-menuitem:hover {
  border: 0 solid #282828!important;
  border-radius: 2px!important
}
.customization-lwtheme-menu-theme:hover,
.customization-uidensity-menuitem:hover {
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  color: #e9e9e9!important;
  border: 0 solid #282828!important;
  border-radius: 2px!important
}
.customization-lwtheme-menu-theme:is(:hover:active,[active=true]),
.customization-uidensity-menuitem:is(:hover:active,[active=true]) {
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  color: #e9e9e9!important;
  border: 0 solid #282828!important;
  border-radius: 2px!important
}
button.downloadButton:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  border-radius: 3px!important
}
button.downloadButton {
  border: 1px solid #181818!important
}
#downloads-button[attention=success]:hover > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-icon {
  fill: #e9e9e9!important;
  fill-opacity: 1
}
#downloads-indicator-finish-image {
  fill: #d1d1d1!important;
  fill-opacity: 1!important;
  stroke: #d1d1d1!important
}
#downloads-indicator-finish-image:hover {
  fill: #e9e9e9!important;
  fill-opacity: 1!important;
  stroke: #e9e9e9!important
}
#downloads-button[open]:hover > .toolbarbutton-badge-stack > #downloads-indicator-finish-box > #downloads-indicator-finish-image {
  stroke: #e9e9e9!important;
  fill: #e9e9e9!important
}
#customization-panelDescription {
  padding: 14px 12px 10px!important;
  text-align: center!important
}
#customization-palette:not([hidden]) {
  margin-left: 21px!important;
  margin-right: 21px!important
}
#downloads-button:hover {
  fill: #282828!important
}
#placesMenu > menu[open] {
  -moz-appearance: none!important;
  background-color: #222!important;
  color: #e9e9e9!important;
  fill: #e9e9e9!important;
  border-radius: 0!important
}
window#places toolbox#placesToolbox toolbar#placesToolbar.chromeclass-toolbar {
  border: 1px solid #202020!important;
  padding-bottom: 5px!important;
  padding-inline-end: 6px;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
window#places toolbox#placesToolbox toolbar#placesToolbar.chromeclass-toolbar search-textbox#searchFilter {
  text-align: center!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-right: 12px!important;
  padding: 5px!important;
  border-radius: 3px!important;
  margin-top: 2px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_tagsRow hbox input#editBMPanel_tagsField {
  padding-left: 8px!important;
  margin-left: 10px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_locationRow input#editBMPanel_locationField.uri-element {
  padding-left: 8px!important;
  margin-left: -5px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_tagsRow div#tags-field-info.caption-label {
  margin: 9px 12px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_nameRow label,
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_tagsRow label {
  margin-top: 10px!important;
  margin-bottom: -5px!important;
  margin-left: 12px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_locationRow label {
  margin-top: 10px!important;
  margin-bottom: -5px!important;
  margin-left: -1px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_nameRow input#editBMPanel_namePicker {
  margin-left: 7px!important;
  margin-right: 7px!important;
  padding-left: 7px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_locationRow {
  margin-left: 7px!important;
  margin-right: 7px!important;
  padding-left: 7px!important;
  box-shadow: none!important
}
window#places toolbox#placesToolbox toolbar#placesToolbar.chromeclass-toolbar toolbarbutton#back-button,
window#places toolbox#placesToolbox toolbar#placesToolbar.chromeclass-toolbar toolbarbutton#forward-button {
  margin-left: 5px!important;
  padding: 5px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane {
  background-color: #222!important;
  color: #e9e9e9!important
}
#editBookmarkPanelContent label[control] {
  margin-inline-start: 7px
}
#editBookmarkPanelImage {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#editBookmarkPanel .expander-down,
#editBookmarkPanel .expander-up {
  appearance: none!important;
  -moz-context-properties: fill!important;
  fill: Currentcolor!important;
  margin-top: 8px!important;
  margin-inline-start: 5px!important;
  color: #e9e9e9!important;
  background-color: #222!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding-top: 0!important;
  padding-bottom: 0!important;
  height: 23px!important;
  width: 52px!important;
  min-height: 24px!important;
  border-radius: 2px!important
}
#editBookmarkPanel .expander-down:hover,
#editBookmarkPanel .expander-up:hover {
  -moz-context-properties: fill!important;
  fill: #e9e9e9!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
html#main-window body popupset#mainPopupSet panel#editBookmarkPanel.panel-no-padding vbox.panel-subview-body vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_folderTreeRow hbox#editBMPanel_newFolderBox button#editBMPanel_newFolderButton {
  background-color: #242424!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  -moz-appearance: none!important;
  border-radius: 3px!important;
  padding: 3px 5px 2px!important;
  margin-top: 4px!important;
  border: 1px solid #181818!important
}
html#main-window body popupset#mainPopupSet panel#editBookmarkPanel.panel-no-padding vbox.panel-subview-body vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_folderTreeRow hbox#editBMPanel_newFolderBox button#editBMPanel_newFolderButton:hover {
  background-color: #d1d1d1!important;
  border: 1px solid #555!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
html#main-window body popupset#mainPopupSet panel#editBookmarkPanel.panel-no-padding vbox.panel-subview-body vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_folderRow hbox menulist#editBMPanel_folderMenuList {
  background-color: #222!important;
  fill: #d1d1d1!important;
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding-top: 4px!important;
  padding-bottom: 3px!important;
  margin-top: 9px!important;
  border-radius: 2px!important
}
#editBMPanel_keywordField,
#editBMPanel_locationField,
#editBMPanel_namePicker,
#editBMPanel_tagsField,
#editBMPanel_tagsSelector {
  border: 0!important;
  outline: transparent 0!important;
  background-color: #222!important;
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: none!important;
  padding-top: 5px!important;
  padding-bottom: 3px!important;
  border-radius: 2px!important;
  margin: 9px 0 0!important
}
#editBookmarkPanelTitle {
  margin-inline-start: 32px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding-top: 9px!important;
  padding-bottom: 9px!important;
  border-radius: 2px!important
}
html#main-window body popupset#mainPopupSet panel#editBookmarkPanel.panel-no-padding vbox.panel-subview-body div#editBookmarkPanelInfoArea div#editBookmarkPanelFaviconContainer img#editBookmarkPanelFavicon {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  width: 24px!important;
  height: 24px!important;
  background-color: #222!important
}
#urlbar[open] > .urlbarView > .urlbarView-body-outer > .urlbarView-body-inner {
  border-top: 1px solid #282828!important
}
.urlbarView-row:is([type=switchtab],[type=remotetab]) > .urlbarView-row-inner > .urlbarView-no-wrap > .urlbarView-action {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#protections-popup-milestones-content {
  margin-left: 0!important;
  border-radius: 5px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  background-color: #242424!important
}
#protections-popup-milestones {
  background-color: #222!important;
  border-radius: 3px!important;
  margin: 25px!important
}
#protections-popup-main-header-label {
  margin-left: 12px;
  margin-bottom: -6px!important;
  margin-top: -2px!important;
  text-align: center!important
}
#protections-popup-siteNotWorkingView-body,
.protections-popup-tp-switch-box,
.protections-popup-tp-switch-label-box {
  min-height: 25px!important;
  -moz-box-pack: center;
  position: relative;
  margin-right: 2px!important;
  margin-left: 2px!important
}
#protections-popup-info-button {
  margin-right: 4px!important;
  scale: 80%!important;
  padding: 3px!important;
  margin-left: 5px!important;
  margin-top: 4px!important
}
#protections-popup-info-button:hover {
  background-color: #262626!important
}
#protections-popup-show-report-stack:hover > .protections-popup-footer-button,
.protections-popup-category:hover,
.protections-popup-footer-button:hover {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 1px!important
}
#protections-popup-not-blocking-section-why {
  margin: 0;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding: 7px 10px 4px!important;
  border-radius: 2px!important
}
#protections-popup-not-blocking-section-why:hover {
  background-color: #262626!important
}
#identity-box,
#tracking-protection-icon-container[checked=true] {
  fill: #242424!important
}
#notification-popup-box:hover:active,
#notification-popup-box[open] {
  background-color: transparent!important
}
.notification-anchor-icon {
  padding: 1px!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  margin-left: 2px!important
}
#reader-mode-button[readeractive] {
  fill: #d1d1d1!important;
  background-color: #313131!important
}
#notification-popup-box:hover {
  background-color: transparent!important
}
.panel-footer.panel-footer-menulike {
  border-top: 1px solid #282828!important
}
.popup-notification-closebutton {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  scale: 85%!important
}
.panel-footer > button {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#bookmarks-menu-button.toolbarbutton-1.chromeclass-toolbar-additional.subviewbutton-nav menupopup#BMB_bookmarksPopup.cui-widget-panel.cui-widget-panelview.cui-widget-panelWithFooter.PanelUI-subView menu.menu-iconic.bookmark-item.subviewbutton menupopup menuitem.openintabs-menuitem.subviewbutton {
  text-align: center!important;
  margin-left: -12px!important;
  margin-right: 3px!important
}
#vertical-tabs-list .all-tabs-item[pending] > .all-tabs-button {
  opacity: 1!important
}
html#main-window body hbox#browser splitter#sidebar-splitter.chromeclass-extrachrome.sidebar-splitter {
  background-color: #222!important
}
.sidebar-splitter {
  width: 5px!important;
  box-shadow: 0 0 1px rgba(0,0,0,.3),0 0 0 1px #3939395c inset!important;
  border: 2px solid #202020!important
}
.close-icon.findbar-closebutton {
  scale: 85%!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.panel-footer.panel-footer-menulike > button {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  text-align: center!important
}
.titlebar-buttonbox {
  appearance: auto;
  -moz-default-appearance: -moz-window-button-box;
  position: relative
}
#PersonalToolbar,
#nav-bar {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#downloads-button.toolbarbutton-1.chromeclass-toolbar-additional:hover {
  fill: #282828!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox.panel-view-body-unscrollable richlistbox#downloadsListBox {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  background-color: #262626!important;
  border-radius: 5px!important;
  margin-left: 3px!important;
  margin-right: 3px!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_nameRow {
  padding-bottom: 5px!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox.panel-view-body-unscrollable richlistbox#downloadsListBox richlistitem.download-state:hover {
  background-color: #282828!important;
  border-radius: 5px!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox.panel-view-body-unscrollable richlistbox#downloadsListBox richlistitem.download-state {
  background-color: #262626!important;
  border-radius: 5px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin: 2px 4px 4px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#downloads-button.toolbarbutton-1.chromeclass-toolbar-additional {
  box-shadow: none!important
}
#maintenanceButton,
#organizeButton,
#viewMenu {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  background-color: #262626!important
}
#maintenanceButton:hover,
#organizeButton:hover,
#viewMenu:hover {
  background-color: #282828!important;
  color: #e9e9e9!important
}
#clearDownloadsButton {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-top: 4px!important;
  margin-left: 5px!important;
  border: 0 solid #202020!important;
  border-radius: 0!important;
  padding: 6px 5px 4px!important
}
.downloadTypeIcon {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.search-panel-header > label {
  margin-left: 11px!important;
  margin-top: 5px!important;
  margin-bottom: 6px!important;
  opacity: .6!important;
  padding-top: 6px!important;
  font-weight: 300!important
}
.search-setting-button:hover,
html#main-window body popupset#mainPopupSet panel#PopupSearchAutoComplete hbox.search-one-offs vbox.search-add-engines stack.toolbarbutton-badge-stack {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.addengine-item {
  padding: 0 5px;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.addengine-item:hover {
  background-color: #282828!important;
  color: #e9e9e9!important
}
#nav-bar-customization-target > toolbarspring {
  max-width: none!important
}
#urlbar[focused=true] > #urlbar-background {
  box-shadow: none!important
}
#tracking-protection-icon-container {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.panel-arrowcontent {
  box-shadow: 0 0 2px rgba(0,0,0,.4),0 0 0 1px #2d2d2d inset!important;
  margin: 6px 2px 6px 6px!important
}
#tracking-protection-icon-container,
#urlbar[breakout][breakout-extend] > #urlbar-background {
  box-shadow: 0 1px 3px rgba(0,0,0,.23),0 0 0 1px var(--toolbar-field-focus-border-color) inset!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar[breakout=true][focused=true] {
  box-shadow: transparent!important;
  border: 0 solid #282828!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#identity-box.localResource {
  box-shadow: none!important;
  border: 1px solid #555!important;
  background: 0 0!important;
  margin-left: 0!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.menu-right {
  appearance: none!important;
  padding: 0!important;
  margin-right: var(--menu-right-margin)!important;
  min-width: 0!important;
  width: var(--menu-right-size)!important;
  height: var(--menu-right-size)!important;
  fill: currentColor!important;
  -moz-context-properties: fill,fill-opacity,stroke,stroke-opacity!important;
  fill-opacity: 0.6!important;
  background-size: 10px 10px!important;
  background-position: center!important;
  background-repeat: no-repeat!important
}
html#main-window body popupset#mainPopupSet panel#editBookmarkPanel.panel-no-padding vbox.panel-subview-body vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_folderTreeRow tree#editBMPanel_folderTree.placesTree treechildren[_moz-menuactive=true] {
  background-color: #d1d1d1!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container hbox#page-action-buttons toolbarbutton#urlbar-zoom-button {
  background-color: #313131!important;
  color: #e9e9e9!important;
  margin-top: 5px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding-top: 5px!important;
  opacity: 1!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container hbox#page-action-buttons toolbarbutton#urlbar-zoom-button:hover {
  background-color: #353535!important;
  color: #e9e9e9!important
}
#searchbar {
  box-shadow: 0 1px 3px rgba(0,0,0,.23),0 0 0 1px #4848484a inset!important
}
html#main-window body hbox#browser vbox#sidebar-box.chromeclass-extrachrome box#sidebar-header toolbarbutton#sidebar-close.close-icon.tabbable {
  scale: 80%!important;
  background-color: #303030!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-right: 0px!important;
  display: hidden !important;
}
html#main-window body hbox#browser vbox#sidebar-box.chromeclass-extrachrome box#sidebar-header toolbarbutton#sidebar-close.close-icon.tabbable:hover {
  background-color: #404040!important
}
.browser-toolbar:not(.titlebar-color) {
  border-top: 1px solid #292929!important;
  border-bottom: 1px solid #292929!important
}
#urlbar-background {
  border: 0 solid #212121!important;
  border-radius: 3px!important
}
#search-container,
urlbar-container {
  padding-block: 5px!important
}
#urlbar-input-container:not(breakout) {
  border-radius: 1px!important;
  background-color: #2d2d2d!important;
  border: 1px solid #181818!important;
  box-shadow: 0 1px 3px rgba(0,0,0,.23),0 0 0 1px #4848484a inset!important
}
#urlbar[open] #urlbar-input-container {
  border: none!important;
  background-color: #242424!important;
  box-shadow: none!important
}
#urlbar[breakout][breakout-extend] > #urlbar-background {
  background-color: #242424!important
}
.tabbrowser-tab:not([selected]):not([pinned]) .tab-close-button {
  display: none!important
  # display: -moz-box!important;
}
.tab-close-button {
  opacity: .8!important;
  margin-top: 0!important;
  margin-inline-end: calc(var(--inline-tab-padding)/ -1)!important;
  border-radius: 1px!important;
  display: none!important
}
.tab-close-button:hover {
  transform: rotate(180deg)!important;
  transition: transform .3s ease-in-out!important;
  # display: -moz-box!important;
  color: #d1d1d1!important;
  fill-opacity: 0.8!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
:is(#back-button[disabled=true],#forward-button[disabled=true]):hover {
  fill: #6d6d6d!important
}
:is(#back-button[disabled=true],#forward-button[disabled=true]) {
  fill: #7d7d7d!important
}
:is(#screenshot-button,#import-button,#sync-button,#panic-button,#save-page-button,#find-button,#fullscreen-button,#new-window-button,#save-to-pocket-button,#stop-button,#back-button,#forward-button,#webide-button,#PanelUI-menu-button,#nav-bar-overflow-button,#bookmarks-menu-button,#bookmarks-button,#developer-button,#preferences-button,#characterencoding-button,#add-ons-button,#search-go-button,.search-go-button,#urlbar-go-button,.urlbar-go-button,#paste-button,#email-link-button,#reload-button,#sidebar-button,#downloads-button,#open-file-button,#home-button,#feed-button,#history-button,#history-panelmenu,#library-button,#privatebrowsing-button,#print-button,#fxa-toolbar-menu-button) {
  fill: #e9e9e9!important
}
:is(#screenshot-button,#import-button,#sync-button,#panic-button,#save-page-button,#find-button,#fullscreen-button,#new-window-button,#save-to-pocket-button,#stop-button,#back-button,#forward-button,#webide-button,#PanelUI-menu-button,#nav-bar-overflow-button,#bookmarks-menu-button,#bookmarks-button,#developer-button,#preferences-button,#characterencoding-button,#add-ons-button,#search-go-button,.search-go-button,#urlbar-go-button,.urlbar-go-button,#paste-button,#email-link-button,#reload-button,#sidebar-button,#downloads-button,#open-file-button,#home-button,#feed-button,#history-button,#history-panelmenu,#library-button,#privatebrowsing-button,#print-button,#fxa-toolbar-menu-button):hover {
  fill: #e9e9e9!important
}
#downloads-button:hover > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-icon,
#downloads-button:hover > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-progress-outer {
  fill: #e9e9e9!important
}
#downloads-button[attention=success] > #downloads-indicator-anchor > #downloads-indicator-icon,
#downloads-button[attention=success] > #downloads-indicator-anchor > #downloads-indicator-progress-outer {
  fill: #e9e9e9!important;
  border: 1px solid transparent!important
}
#downloads-button[open=true]:hover > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-icon,
#downloads-button[open=true]:hover > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-progress-outer {
  fill: #e9e9e9!important
}
:root {
  --bookmark-block-padding: 0px!important;
  --uc-toolbarbutton-vertical-padding: calc(var(--toolbarbutton-inner-padding) + 1px);
  --uc-toolbarbutton-horizontal-padding: calc(var(--toolbarbutton-inner-padding) + 2px);
  --toolbarbutton-border-radius: 3px!important
}
:root[uidensity] {
  --uc-toolbarbutton-vertical-padding: calc(var(--toolbarbutton-inner-padding) - 1px);
  --uc-toolbarbutton-horizontal-padding: calc(var(--toolbarbutton-inner-padding) + 1px)
}
#navigator-toolbox > toolbar {
  --lwt-toolbarbutton-icon-fill: var(--lwt-toolbar-field-color, black)
}
:root:not([uidensity=compact]) #nav-bar {
  padding-inline-start: 5px
}
#PanelUI-button > toolbarbutton > stack,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > stack,
.findbar-button {
  background-color: var(--lwt-toolbar-field-background-color,hsla(0,0%,100%,.8));
  width: calc(2* var(--uc-toolbarbutton-horizontal-padding) + 16px)!important;
  height: calc(2* var(--uc-toolbarbutton-vertical-padding) + 16px)!important;
  fill-opacity: 1;
  margin-inline: 2px
}
.findbar-button {
  width: auto!important
}
#PanelUI-button > toolbarbutton > stack,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > stack,
.findbar-button {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#PersonalToolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#back-button > .toolbarbutton-icon,
#navigator-toolbox > toolbar .chromeclass-toolbar-additional > .toolbarbutton-icon,
#navigator-toolbox > toolbar .toolbarbutton-1 > stack {
  padding: var(--uc-toolbarbutton-vertical-padding) var(--uc-toolbarbutton-horizontal-padding)!important
}
#back-button {
  border-radius: 0!important;
  padding: initial!important;
  border: none!important
}
#back-button > .toolbarbutton-icon {
  border-radius: var(--toolbarbutton-border-radius)!important
}
#PersonalToolbar .chromeclass-toolbar-additional > .toolbarbutton-1 > .toolbarbutton-icon,
#PersonalToolbar .chromeclass-toolbar-additional > .toolbarbutton-icon,
#PersonalToolbar .chromeclass-toolbar-additional > stack,
#back-button > .toolbarbutton-icon {
  background-color: var(--lwt-toolbar-field-background-color,hsla(0,0%,100%,.8))!important
}
#PersonalToolbar .chromeclass-toolbar-additional > .toolbarbutton-1:not([disabled]):hover > .toolbarbutton-icon,
#PersonalToolbar .chromeclass-toolbar-additional:not([disabled]):hover > .toolbarbutton-icon,
#PersonalToolbar .chromeclass-toolbar-additional:not([disabled]):hover > stack,
#back-button:not([disabled]):hover > .toolbarbutton-icon {
  background-color: var(--toolbarbutton-hover-background,hsla(0,20%,10%,.1))!important;
  color: var(--lwt-toolbar-field-background-color)!important
}
#PersonalToolbar .chromeclass-toolbar-additional,
#PersonalToolbar .chromeclass-toolbar-additional > .toolbarbutton-1 {
  padding: initial!important;
  background: 0 0!important
}
#TabsToolbar #new-tab-button,
#tabs-newtab-button {
  fill-opacity: 1!important;
  border: 1px solid #181818!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-left: 1px!important
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target tabs#tabbrowser-tabs arrowscrollbox#tabbrowser-arrowscrollbox toolbarbutton#tabs-newtab-button.toolbarbutton-1 image.toolbarbutton-icon {
  scale: 154%!important;
  background-color: transparent!important
}
#TabsToolbar:hover #new-tab-button:active,
#tabs-newtab-button:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#vertical-tabs-list .all-tabs-item:hover .all-tabs-button {
  box-shadow: none!important;
  background-color: transparent!important
}
#vertical-tabs-list .all-tabs-item:hover {
  background-color: transparent!important;
  color: #e9e9e9!important;
  filter: grayscale(0%)!important;
  font-weight: 400!important
}
#vertical-tabs-list .all-tabs-item,
#vertical-tabs-list .all-tabs-item:hover,
#vertical-tabs-list .all-tabs-item[selected=true] {
  opacity: 1!important
}
#vertical-tabs-new-tab-button:hover {
  background-color: transparent!important;
  color: #e9e9e9!important;
  font-weight: 400!important;
  opacity: 1!important
}
#vertical-tabs-new-tab-button {
  color: #e9e9e9!important;
  opacity: 1!important;
  margin-top: 7px!important;
  box-shadow: none!important
}
#vertical-tabs-inner-box {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 2px!important;
  margin: -5px 2px -5px -9px!important;
  padding-left: 3px!important;
  padding-right: 3px!important
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#vertical-tabs-button.toolbarbutton-1.chromeclass-toolbar-additional image.toolbarbutton-icon {
  scale: 138%!important;
  transform: scaleX(1)!important;
  background-color: transparent!important
}
#vertical-tabs-button:active,
#vertical-tabs-button:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-button {
  filter: grayscale(1) brightness(1) contrast(1.2)!important;
  min-height: 34px!important;
  color: #e9e9e9!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-button[label^="New Tab"] {
  filter: grayscale(1) brightness(1.5) contrast(1)!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-button:hover,
#vertical-tabs-list .all-tabs-item[selected=true] .all-tabs-button {
  filter: grayscale(0%)!important
}
#vertical-tabs-list .all-tabs-item:not[selected=true] .all-tabs-button {
  opacity: .5!important
}
#vertical-tabs-button {
  border: 1px solid #181818!important;
  margin-left: 2px!important;
  box-shadow: 0 1px 3px rgba(0,0,0,.55),0 0 0 1px #4040405c inset!important
}
#vertical-tabs-button[checked=true] {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
html#main-window body hbox#browser splitter#vertical-tabs-splitter.chromeclass-extrachrome.sidebar-splitter {
  color: transparent!important;
  background-color: transparent!important;
  box-shadow: none!important;
  border: none!important
}
#vertical-tabs-list .all-tabs-item .all-tabs-secondary-button[close-button] {
  box-shadow: 0 1px 3px rgba(0,0,0,.55),0 0 0 1px #4040405c inset!important;
  border-radius: 1px!important;
  margin-top: 0!important;
  scale: 75%!important;
  padding: 12px 5px 8px 2px!important
}
html#main-window body popupset#mainPopupSet panel#appMenu-popup.cui-widget-panel.panel-no-padding panelmultiview#appMenu-multiView box.panel-viewcontainer box.panel-viewstack panelview#appMenu-protonMainView.PanelUI-subView vbox.panel-subview-body toolbaritem#appMenu-fxa-status2.subviewbutton toolbarbutton#appMenu-fxa-label2.subviewbutton.subviewbutton-nav {
  padding-top: 10px!important;
  padding-bottom: 10px!important;
  border-radius: 3px!important
}
html#main-window body popupset#mainPopupSet panel#appMenu-popup.cui-widget-panel.panel-no-padding panelmultiview#appMenu-multiView box.panel-viewcontainer box.panel-viewstack panelview#appMenu-protonMainView.PanelUI-subView vbox.panel-subview-body toolbaritem#appMenu-fxa-status2.subviewbutton {
  padding-top: 6px!important;
  padding-bottom: 0!important
}
html#main-window body popupset#mainPopupSet panel#appMenu-popup.cui-widget-panel.panel-no-padding panelmultiview#appMenu-multiView box.panel-viewcontainer box.panel-viewstack panelview#appMenu-protonMainView.PanelUI-subView vbox.panel-subview-body toolbaritem#appMenu-zoom-controls2.subviewbutton.toolbaritem-combined-buttons toolbarbutton#appMenu-fullscreen-button2.subviewbutton.subviewbutton-iconic {
  border-radius: 3px!important;
  margin-right: -1px!important;
  padding: 0 5px!important
}
html#main-window body popupset#mainPopupSet panel#appMenu-popup.cui-widget-panel.panel-no-padding panelmultiview#appMenu-multiView box.panel-viewcontainer box.panel-viewstack panelview#appMenu-protonMainView.PanelUI-subView vbox.panel-subview-body toolbaritem#appMenu-zoom-controls2.subviewbutton.toolbaritem-combined-buttons toolbarbutton#appMenu-zoomReset-button2.subviewbutton {
  margin-right: 2px!important;
  border-radius: 3px!important;
  padding: 4px 11px 1px!important
}
html#main-window body popupset#mainPopupSet panel#appMenu-popup.cui-widget-panel.panel-no-padding panelmultiview#appMenu-multiView box.panel-viewcontainer box.panel-viewstack panelview#appMenu-protonMainView.PanelUI-subView vbox.panel-subview-body toolbaritem#appMenu-zoom-controls2.subviewbutton.toolbaritem-combined-buttons toolbarbutton#appMenu-zoomEnlarge-button2.subviewbutton.subviewbutton-iconic,
html#main-window body popupset#mainPopupSet panel#appMenu-popup.cui-widget-panel.panel-no-padding panelmultiview#appMenu-multiView box.panel-viewcontainer box.panel-viewstack panelview#appMenu-protonMainView.PanelUI-subView vbox.panel-subview-body toolbaritem#appMenu-zoom-controls2.subviewbutton.toolbaritem-combined-buttons toolbarbutton#appMenu-zoomReduce-button2.subviewbutton.subviewbutton-iconic {
  border-radius: 3px!important;
  margin-right: 2px!important;
  padding: 0 5px!important
}
#vertical-tabs-pin-button {
  border-radius: 3px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin: 6px 3px 5px 2px!important;
  padding: 4px 3px 0 6px!important
}
#vertical-tabs-close-button {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin: 6px 6px 5px 2px!important;
  padding: 3px 4px 0 6px!important;
  border-radius: 3px!important;
  border: 1px solid #181818!important
}
#vertical-tabs-close-button:hover {
  border-radius: 1px!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box hbox#vertical-tabs-buttons-row toolbarbutton#vertical-tabs-pin-button.subviewbutton.subviewbutton-iconic.no-label {
  padding-left: 6px!important
}
#vertical-tabs-pane toolbarseparator {
  border-top: 1px solid #282828!important;
  border-bottom: none;
  margin: 1px!important
}
window#bookmarkproperties dialog#bookmarkpropertiesdialog vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_folderTreeRow tree#editBMPanel_folderTree.placesTree treechildren {
  background-color: #282828!important;
  color: #e9e9e9!important;
  -moz-appearance: none!important
}
window#bookmarkproperties dialog#bookmarkpropertiesdialog vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_folderTreeRow tree#editBMPanel_folderTree.placesTree treechildren[_moz-menuactive=true] {
  background-color: #282828!important;
  color: #e9e9e9!important
}
#app-picker,
window#bookmarkproperties dialog#bookmarkpropertiesdialog {
  background-color: #222!important;
  color: #e9e9e9!important
}
window dialog#app-picker richlistbox#app-picker-listbox {
  background-color: #222!important;
  color: #e9e9e9!important;
  -moz-appearance: none!important;
  border: 1px solid #282828!important
}
window dialog#app-picker richlistbox#app-picker-listbox richlistitem:hover {
  background-color: #282828!important;
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
window dialog#app-picker richlistbox#app-picker-listbox richlistitem {
  background-color: #222!important;
  color: #e9e9e9!important;
  font-weight: 400!important
}
window dialog#app-picker richlistbox#app-picker-listbox richlistitem[selected=true] {
  background-color: #292929!important;
  color: #e9e9e9!important;
  font-weight: 400!important
}
window#unknownContentTypeWindow dialog#unknownContentType vbox#container vbox#normalBox radiogroup#mode.small-indent hbox deck#modeDeck hbox#openHandlerBox menulist#openHandler menupopup#openHandlerPopup.in-menulist menuseparator {
  display: none!important
}
window#unknownContentTypeWindow dialog#unknownContentType {
  color: #e9e9e9!important;
  background-color: #222!important
}
window#unknownContentTypeWindow dialog#unknownContentType vbox#container vbox#normalBox radiogroup#mode.small-indent hbox deck#modeDeck hbox#openHandlerBox menulist#openHandler {
  -moz-appearance: none!important;
  color: #e9e9e9!important;
  background-color: #303030!important;
  border-radius: 3px!important;
  border: 1px solid #262626!important;
  padding: 2px 2px 2px 5px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
hbox.dialog-button-box button {
  padding-top: 3px!important;
  padding-bottom: 0!important;
  background: #282828!important;
  color: #e9e9e9!important;
  -moz-appearance: none!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 3px!important;
  border: 0 solid #282828!important
}
hbox.dialog-button-box button:hover {
  -moz-appearance: none;
  background-color: #d1d1d1!important;
  color: #282828!important;
  border-radius: 3px!important;
  border: 0 solid #262626!important
}
#maintenanceButton,
#viewMenu {
  margin-top: 10px!important;
  margin-bottom: 5px!important
}
#ContentSelectDropdown > menupopup > :not([_moz-menuactive=true]) {
  color: #e9e9e9!important;
  background-color: #222!important
}
.popup-notification-learnmore-link {
  color: #d1d1d1!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar vbox.urlbarView div.urlbarView-body-outer div.urlbarView-body-inner div#urlbar-results.urlbarView-results span.urlbarView-no-wrap span.urlbarView-title-separator {
  opacity: 0!important
}
#identity-box:focus,
#tracking-protection-icon-container:focus {
  background-color: #e9e9e9!important
}
#downloadsListBox > richlistitem {
  color: #e9e9e9!important;
  background-color: #222!important
}
#downloadsListBox > richlistitem:hover {
  color: #e9e9e9!important;
  background-color: #282828!important
}
#downloadsSummaryDescription,
.downloadTarget {
  color: #e9e9e9!important
}
#downloadsRichListBox > richlistitem {
  margin-top: 1px!important;
  margin-bottom: 1px!important
}
window#places hbox#placesView vbox#contentView vbox#placesViewsBox richlistbox#downloadsRichListBox richlistitem.download.download-state button.downloadButton.downloadIconShow {
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin: 6px 12px!important;
  padding: 0 12px 0 10px!important
}
window#places hbox#placesView vbox#contentView vbox#placesViewsBox richlistbox#downloadsRichListBox richlistitem.download.download-state button.downloadButton.downloadIconShow:hover {
  background-color: #282828!important;
  color: #d1d1d1!important;
  margin: 6px 12px!important;
  padding: 0 12px 0 10px!important
}
window#places hbox#placesView vbox#contentView vbox#placesViewsBox richlistbox#downloadsRichListBox richlistitem.download.download-state button.downloadButton.downloadIconRetry {
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin: 6px 12px!important;
  padding: 0 12px 0 10px!important
}
window#places hbox#placesView vbox#contentView vbox#placesViewsBox richlistbox#downloadsRichListBox richlistitem.download.download-state button.downloadButton.downloadIconRetry:hover {
  background-color: #282828!important;
  color: #d1d1d1!important;
  margin-top: 6px!important;
  margin-bottom: 6px!important;
  padding: 0 12px 0 10px!important
}
window#places hbox#placesView vbox#contentView vbox#placesViewsBox richlistbox#downloadsRichListBox richlistitem.download.download-state:hover {
  background-color: #202020!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
:host([type=info]) .icon {
  color: #777!important
}
richlistbox {
  color: #e9e9e9!important;
  background-color: #4c4c4f!important;
  border-color: #282828!important;
  -moz-user-focus: inherit!important
}
.tabbrowser-tab:not([selected]) .tab-icon-image {
  filter: grayscale(1) brightness(1.4) contrast(1)!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox#downloadsFooter stack hbox#downloadsFooterButtons.panel-footer.panel-footer-menulike button#downloadsHistory.downloadsPanelFooterButton {
  color: #e9e9e9!important;
  border: 0 solid #282828!important;
  padding: 7px!important;
  border-radius: 3px!important;
  margin: 9px -5px -4px -4px!important
}
.browser-toolbar:not(.titlebar-color) {
  color: #e9e9e9!important;
  background-color: #252525!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox scrollbox#PlacesToolbarItems toolbarbutton.bookmark-item {
  border: 1px solid #181818!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox scrollbox#PlacesToolbarItems toolbarbutton.bookmark-item:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  color: #e9e9e9!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox toolbarbutton#OtherBookmarks.bookmark-item:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important;
  fill: white!important
}
findbar hbox.findbar-container hbox input.findbar-textbox {
  outline: #202020 solid 0!important;
  outline-offset: 0px;
  color: #5d5d5d!important;
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
findbar hbox.findbar-container hbox input.findbar-textbox:focus {
  outline: #191919 solid 0!important;
  outline-offset: 0px;
  color: #6d6d6d!important;
  background-color: #282828!important
}
.findbar-find-next,
findbar-find-previous {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.browserContainer > findbar {
  background-color: #222!important;
  border-color: #191919!important;
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  background-image: none!important
}
.findbar-textbox {
  border: none!important;
  outline: 0!important;
  caret-color: #d1d1d1!important
}
hbox arrowscrollbox.menupopup-arrowscrollbox {
  margin: 0!important;
  border: 1px #202020!important;
  border-radius: 5px!important;
  background-color: #222!important
}
.navigable.subviewbutton:not([disabled],[open],:active):is(:hover),
.toolbaritem-combined-buttons:is(:not([cui-areatype=toolbar]),[overflowedItem=true]) > toolbarbutton:not([disabled],[open],:active):is(:hover),
.widget-overflow-list .toolbarbutton-1:not([disabled],[open],:active):is(:hover),
menu.subviewbutton:not([disabled],:active)[_moz-menuactive],
menuitem.subviewbutton:not([disabled],:active)[_moz-menuactive],
panelview .toolbarbutton-1:not([disabled],[open],:active):is(:hover),
toolbarbutton.subviewbutton:not([disabled],[open],:active):is(:hover) {
  color: #e9e9e9!important;
  background-color: #282828!important
}
#PopupSearchAutoComplete:-moz-lwtheme {
  -moz-align: center!important;
  text-align: center!important;
  color: #e9e9e9!important
}
#PopupSearchAutoComplete {
  --panel-background: #222!important;
  border-radius: 2px!important;
  -moz-window-shadow: cliprounded!important;
  background-color: transparent!important;
  color: #e9e9e9!important;
  border: 0 solid #282828!important
}
html#main-window body popupset#mainPopupSet panel#identity-popup.panel-no-padding panelmultiview#identity-popup-multiView box.panel-viewcontainer box.panel-viewstack panelview#identity-popup-mainView vbox#identity-popup-clear-sitedata-footer.panel-footer.panel-footer-menulike button#identity-popup-clear-sitedata-button {
  color: #e9e9e9!important;
  padding: 7px!important;
  margin: 4px -5px -4px!important
}
#identity-popup-security-button {
  padding: 5px!important
}
html#main-window body popupset#mainPopupSet panel#permission-popup.panel-no-padding panelmultiview#permission-popup-multiView box.panel-viewcontainer box.panel-viewstack panelview#permission-popup-mainView hbox.permission-popup-section vbox#permission-popup-permissions-content vbox#permission-popup-permission-list vbox#permission-popup-permission-list-default-anchor.permission-popup-permission-list-anchor vbox#permission-popup-container.permission-popup-permission-item-container hbox.permission-popup-permission-item.permission-popup-permission-item-autoplay-media menulist#permission-popup-menulist {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#identity-box[pageproxystate=valid].chromeUI > .identity-box-button,
#identity-box[pageproxystate=valid].extensionPage > .identity-box-button,
#identity-box[pageproxystate=valid].notSecureText > .identity-box-button,
#urlbar-label-box {
  padding-left: 7px!important;
  padding-right: 4px!important;
  border-radius: 0!important;
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #575757!important;
  background: linear-gradient(.45turn,#464646b8,#313131a1)!important
}
#identity-box:hover[pageproxystate=valid].extensionPage > .identity-box-button:hover,
#identity-box[pageproxystate=valid].chromeUI > .identity-box-button:hover,
#identity-box[pageproxystate=valid].notSecureText > .identity-box-button,
#urlbar-label-box:hover {
  background-color: #383838!important;
  color: #9d9d9d!important
}
#identity-icon-label {
  padding-inline-start: 10px!important;
  color: #e9e9e9!important;
  margin-top: 3px!important;
  padding-right: 12px!important
}
#BMB_bookmarksShowAll,
#BMB_bookmarksShowAllTop,
#BMB_bookmarksShowAllTop + menuseparator,
#BMB_bookmarksToolbar,
#BMB_mobileBookmarks,
#BMB_mobileBookmarks + menuseparator,
#BMB_viewBookmarksSidebar,
#bookmarks-menu-button .menu-iconic[label="Recent Tags"],
#bookmarks-menu-button .menu-iconic[label="Recent Tags"] + menuseparator {
  display: none!important
}
.bookmark-item {
  -moz-context-properties: fill!important;
  fill: #555555!important
}
.bookmark-item:hover {
  -moz-context-properties: fill!important;
  fill: white!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#bookmarks-menu-button.toolbarbutton-1.chromeclass-toolbar-additional.subviewbutton-nav menupopup#BMB_bookmarksPopup.cui-widget-panel.cui-widget-panelview.cui-widget-panelWithFooter.PanelUI-subView menuseparator.small-separator {
  display: none!important
}
#BMB_bookmarksPopup .subviewbutton {
  padding-left: 6px!important
}
#urlbar .search-one-offs:not([hidden]) {
  display: none!important
}
.urlbarView:not([noresults]) > .search-one-offs:not([hidden]) {
  border-top: 0!important
}
#appMenu-zoom-controls2 > .subviewbutton {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-left: 0!important;
  margin-right: 0!important
}
appMenu-zoom-controls2 {
  margin-inline-start: -4px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 3px!important;
  margin: 2px 6px 4px!important;
  padding: 5px 7px 5px 12px!important;
  background-color: #222!important
}
#appMenu-zoomEnlarge-button2 {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding: 7px!important;
  border-radius: 3px!important;
  margin-left: 0!important;
  margin-right: 0!important;
  background-color: #222!important
}
#appMenu-zoomReduce-button2 {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-right: 0!important;
  padding: 7px!important;
  border-radius: 3px!important;
  margin-left: 0!important
}
.subviewbutton,
.widget-overflow-list .toolbarbutton-1,
panelview .toolbarbutton-1 {
  border-radius: 1px!important
}
.searchbar-engine-image {
  margin-bottom: -5px!important;
  filter: grayscale(100%)!important;
  margin-left: 3px!important
}
.searchbar-engine-one-off-item {
  margin: 0 7px 6px 4px!important;
  border-radius: 2px!important
}
.searchbar-engine-one-off-item:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
html#main-window body popupset#mainPopupSet panel#editBookmarkPanel.panel-no-padding vbox.panel-subview-body vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_folderTreeRow tree#editBMPanel_folderTree.placesTree treechildren {
  background-color: #222!important;
  color: #e9e9e9!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox#downloadsFooter stack hbox#downloadsFooterButtons.panel-footer.panel-footer-menulike button#downloadsHistory.downloadsPanelFooterButton:hover {
  background-color: #282828!important;
  color: #e9e9e9!important
}
.titleIcon {
  background-color: #222!important
}
button,
html|button[autofocus],
html|button[type=submit],
xul|button[default] {
  background-color: #282828!important;
  color: #e9e9e9!important
}
button:hover,
html|button[autofocus],
html|button[type=submit],
xul|button[default] {
  background-color: #e9e9e9!important;
  color: #282828!important
}
.popup-notification-body input {
  padding: 4px!important;
  outline: 0 solid var(--input-border-color,ThreeDShadow)!important;
  color: #ccc!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
:root:not(:-moz-lwtheme) {
  --button-color: #e9e9e9!important;
  --button-hover-bgcolor: #303030!important;
  --button-primary-bgcolor: #d1d1d1!important;
  --button-primary-hover-bgcolor: #666666!important;
  --button-primary-active-bgcolor: #d1d1d1!important;
  --input-color: #ccc!important;
  --input-bgcolor: #222!important;
  --button-primary-bgcolor: #222!important;
  --autocomplete-popup-highlight-color: #e9e9e9!important;
  --selected-text-row: #e9e9e9!important;
  --hover-bg-row: #282828!important;
  --selected-bg-row: #d1d1d1!important;
  --arrowpanel-border-color: #222!important;
  --autocomplete-popup-separator-color: #212121!important;
  --chrome-content-separator-color: #202020!important;
  --panel-shortcut-color: #f0f0f0!important;
  --buttons-primary-button-bgcolor: #d1d1d1!important;
  --buttons-primary-button-hover-bgcolor: white!important;
  --buttons-primary-button-active-bgcolor: #5d5d5d!important;
  --checkbox-border-color: #282828!important;
  --checkbox-unchecked-bgcolor: #3d3d3d!important;
  --checkbox-unchecked-hover-bgcolor: #4d4d4d!important;
  --checkbox-unchecked-active-bgcolor: #d1d1d1!important;
  --checkbox-checked-bgcolor: #d1d1d1!important;
  --checkbox-checked-color: #282828!important;
  --checkbox-checked-hover-bgcolor: #666666!important;
  --checkbox-checked-active-bgcolor: #666666!important;
  --checkbox-checked-border-color: #d1d1d1!important;
  --button-bgcolor: #282828!important;
  --in-content-page-color: #e9e9e9!important;
  --toolbarbutton-icon-fill-attention: #282828!important
}
.search-panel-tree > .autocomplete-richlistitem:hover {
  background-color: #d1d1d1!important;
  color: #282828!important
}
.search-panel-tree > .autocomplete-richlistitem {
  padding: 7px 3px!important;
  font-weight: 300!important
}
#urlbar-container {
  -moz-box-pack: center!important
}
.urlbarView:not(.megabar) {
  --item-padding-start: 900px!important
}
#nav-bar {
  --toolbar-field-focus-border-color: #2c2c2c!important
}
#searchbar,
#urlbar,
.urlbarView-action,
.urlbarView-url {
  color: #e9e9e9!important
}
::-moz-selection {
  color: #e9e9e9!important;
  background-color: #d1d1d1!important
}
#PanelUI-menu-button[disabled=true],
#nav-bar-overflow-button[disabled=true],
#tabbrowser-arrowscrollbox[scrolledtoend=true]::part(scrollbutton-down),
#tabbrowser-arrowscrollbox[scrolledtostart=true]::part(scrollbutton-up),
:root:not([customizing]) .toolbarbutton-1[disabled=true] {
  opacity: 1!important;
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target toolbarbutton#new-tab-button.toolbarbutton-1.chromeclass-toolbar-additional:hover {
  fill: #e9e9e9!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#bookmarks-menu-button.toolbarbutton-1.chromeclass-toolbar-additional.subviewbutton-nav menupopup#BMB_bookmarksPopup.cui-widget-panel.cui-widget-panelview.cui-widget-panelWithFooter.PanelUI-subView,
vbox.panel-arrowcontainer {
  border: none!important;
  background-color: transparent!important
}
html#main-window body box#customization-container box#customization-content-container vbox#customization-panel-container vbox#customization-panelWrapper box.panel-arrowbox {
  color: #282828!important
}
html#main-window body popupset#mainPopupSet panel#downloadsPanel.panel-no-padding panelmultiview#downloadsPanel-multiView box.panel-viewcontainer box.panel-viewstack panelview#downloadsPanel-mainView vbox#downloadsFooter stack hbox#downloadsFooterButtons.panel-footer.panel-footer-menulike {
  border-top: 1px solid #282828!important
}
.urlbarView-title:not(:empty) ~ .urlbarView-action {
  background-color: transparent!important;
  color: #e9e9e9!important
}
html#main-window body box#customization-container box#customization-content-container vbox#customization-panel-container vbox#customization-panelWrapper box.panel-arrowbox image.panel-arrow {
  fill: #e9e9e9!important;
  stroke: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-top: 5px!important;
  padding: 6px 15px 7px!important;
  border-radius: 2px!important;
  margin-right: -14px!important;
  scale: 80%!important
}
toolbarseparator {
  border-color: #282828!important
}
#searchbar {
  border: 1px solid #181818!important;
  background-color: #2d2d2d!important
}
#nav-bar-customization-target,
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar toolbarbutton#nav-bar-overflow-button.toolbarbutton-1.chromeclass-toolbar-additional.overflow-button,
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar toolbaritem#PanelUI-button toolbarbutton#PanelUI-menu-button.toolbarbutton-1 {
  background-color: #252525!important
}
#statuspanel #statuspanel-label {
  -moz-appearance: none!important;
  background-color: #242424!important;
  font-family: Oxanium!important;
  font-size-adjust: inherit!important;
  font-weight: 300!important;
  color: #e9e9e9!important;
  border: 0 solid #282828!important;
  border-radius: 3px 3px 3px 0!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding: 8px!important;
  text-align: center!important
}
:root {
  --chrome-content-separator-color: #282828!important;
  --panel-description-color: #e9e9e9!important;
  --focus-outline-color: #282828!important;
  --focus-outline-offset: 0px!important;
  --toolbarbutton-icon-fill-attention: #282828!important;
  --arrowpanel-menuitem-border-radius: 1px;
  --panelview-toolbarbutton-focus-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.50),0 0 0 1px #4040405c inset!important;
  --arrowpanel-background: #222!important;
  --arrowpanel-color: #e9e9e9!important;
  --panel-separator-margin: 5px 8px
}
window#aboutDialog vbox#aboutDialogContainer hbox#clientBox vbox#rightBox vbox#detailsBox hbox#updateBox vbox stack#updateDeck hbox#apply.selected button#updateButton,
window#aboutDialog vbox#aboutDialogContainer hbox#clientBox vbox#rightBox vbox#detailsBox hbox#updateBox vbox stack#updateDeck hbox#apply.selected button#updateButton:hover {
  color: #202020!important
}
:host(dialog),
:root[dialogroot] {
  --in-content-page-background: #222!important
}
.toolbarbutton-badge {
  background-color: #d1d1d1!important;
  height: 15px!important;
  padding: 4px 0!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbarbutton#bookmarks-menu-button.toolbarbutton-1.chromeclass-toolbar-additional.subviewbutton-nav menupopup#BMB_bookmarksPopup.cui-widget-panel.cui-widget-panelview.cui-widget-panelWithFooter.PanelUI-subView menu.menu-iconic.bookmark-item.subviewbutton menupopup {
  color: #222!important;
  padding-top: 6px!important
}
box.scrollbox-clip scrollbox {
  color: #222!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox scrollbox#PlacesToolbarItems toolbarbutton.bookmark-item menupopup menuitem.menuitem-iconic.bookmark-item.menuitem-with-favicon {
  filter: grayscale(100%)!important;
  padding-top: 1px!important;
  padding-bottom: 1px!important;
  padding-left: 5px!important;
  border-radius: 0!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox scrollbox#PlacesToolbarItems toolbarbutton.bookmark-item menupopup menuitem.openintabs-menuitem {
  text-align: center!important;
  filter: grayscale(100%)!important;
  padding-right: 22px!important;
  border-radius: 0!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox scrollbox#PlacesToolbarItems toolbarbutton.bookmark-item menupopup menuitem.menuitem-iconic.bookmark-item.menuitem-with-favicon:hover {
  filter: grayscale(0%)!important;
  color: #e9e9e9!important;
}
html#main-window body box toolbox#navigator-toolbox toolbar#PersonalToolbar.browser-toolbar.chromeclass-directories.instant.customization-target toolbaritem#personal-bookmarks hbox#PlacesToolbar hbox scrollbox#PlacesToolbarItems toolbarbutton.bookmark-item menupopup menuitem.openintabs-menuitem:hover {
  filter: grayscale(0%)!important
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#toolbar-menubar.browser-toolbar.chromeclass-menubar.titlebar-color.customization-target toolbaritem#menubar-items {
  margin-inline-start: 100px!important;
  background-color: #202020!important
}
#PlacesToolbarItems > .bookmark-item > .toolbarbutton-icon {
  display: none!important
}
window#commonDialogWindow dialog#commonDialog.sizeDetermined {
  color: #e9e9e9!important
}
toolbarbutton#scrollbutton-down,
toolbarbutton#scrollbutton-up {
  background-color: #202020!important;
  border-radius: 0!important;
  border: 1px solid #181818!important;
  padding: 0 10px!important
}
toolbarbutton#scrollbutton-down:hover,
toolbarbutton#scrollbutton-up:hover {
  fill-opacity: 1!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.all-tabs-button[selected=true] {
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#allTabsMenu-allTabsViewTabs > .all-tabs-item[selected=true] {
  background-color: transparent!important
}
.all-tabs-item:hover {
  filter: grayscale(0%)!important;
  background-color: transparent!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#identity-box.chromeUI box#identity-icon-box.identity-box-button label#identity-icon-label.plain {
  padding-bottom: 1px!important;
  padding-right: 1px!important;
  margin-left: -4px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#identity-box.chromeUI {
  margin: 3px 0 3px 3px!important;
  padding: 0!important;
  border-radius: 2px!important;
  border: 0 solid #282828!important
}
#urlbar:not(.searchButton) > #urlbar-input-container > #identity-box[pageproxystate=invalid] #identity-icon {
  scale: 117%!important
}
.tab-icon-sound-label {
  display: none!important
}
.PanelUI-subView toolbarseparator.proton-zap {
  border-image: var(--panel-separator-zap-gradient) 1
}
.tabbrowser-tab .tab-icon-image {
  box-sizing: border-box;
  background-clip: padding-box;
  border-radius: 4px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#PanelUI-history.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body toolbaritem#appMenu_historyMenu toolbarbutton.subviewbutton.subviewbutton-iconic.bookmark-item {
  filter: grayscale(100%);
  box-shadow: none!important;
  background-color: #222!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#PanelUI-history.PanelUI-subView.cui-widget-panelview vbox.panel-subview-body toolbaritem#appMenu_historyMenu toolbarbutton.subviewbutton.subviewbutton-iconic.bookmark-item:hover {
  filter: grayscale(0%);
  background-color: #242424!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 0!important
}
.tab-loading-burst {
  display: none!important
}
#nav-bar[customizing] > .overflow-button,
#nav-bar[nonemptyoverflow] > .overflow-button {
  margin-right: 8px!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target tabs#tabbrowser-tabs arrowscrollbox#tabbrowser-arrowscrollbox tab.tabbrowser-tab:hover stack.tab-stack hbox.tab-content vbox.tab-label-container[labeldirection=rtl] {
  margin-inline-end: 0!important
}
html#main-window body box#navigator-toolbox-background toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target tabs#tabbrowser-tabs arrowscrollbox#tabbrowser-arrowscrollbox tab.tabbrowser-tab:hover stack.tab-stack hbox.tab-content vbox.tab-label-container {
  margin-inline-end: -7px!important;
  display: none!important;
}
.tab-text[selected=true] {
  color: #e9e9e9!important;
  display: hidden!important;
}
#vertical-tabs-pin-button:hover {
  border-radius: 1px!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
#vertical-tabs-pin-button {
  border: 1px solid #181818!important
}
#vertical-tabs-pane .subviewbutton-iconic > .toolbarbutton-icon,
#vertical-tabs-pane[unpinned]:not([hidden]) .subviewbutton-iconic > .toolbarbutton-icon {
  margin-top: -13px!important;
  margin-bottom: -9px!important;
  padding: 3px;
  margin-left: -3px!important;
  width: 24px!important;
  height: 24px!important;
  scale: 117%!important;
  border-radius: 2px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box hbox#vertical-tabs-buttons-row toolbarbutton#vertical-tabs-new-tab-button.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -13px!important;
  margin-bottom: -9px!important;
  padding: 4px;
  margin-left: -6px!important;
  width: 27px!important;
  height: 27px!important;
  scale: 117%!important;
  border-radius: 1px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item:is([selected]) toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -13px!important;
  margin-bottom: -9px!important;
  padding: 3px;
  margin-left: -6px!important;
  width: 27px!important;
  height: 27px!important;
  scale: 100%!important;
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  border-radius: 1px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item:hover toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -13px!important;
  margin-bottom: -9px!important;
  padding: 3px;
  margin-left: -6px!important;
  width: 27px!important;
  height: 27px!important;
  scale: 100%!important;
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  border-radius: 1px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item:not([selected=true]) toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  border: 1px solid transparent!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item:not([selected=true]):hover toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  border: 1px solid #555!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item:not([selected=true]):hover toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic label.toolbarbutton-text {
  margin-left: -1px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item:is([selected]):hover toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -13px!important;
  margin-bottom: -9px!important;
  padding: 3px;
  margin-left: -6px!important;
  width: 27px!important;
  height: 27px!important;
  scale: 100%!important;
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  border-radius: 1px!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box arrowscrollbox#vertical-tabs-list toolbaritem.all-tabs-item toolbarbutton.all-tabs-button.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  margin-top: -13px!important;
  margin-bottom: -9px!important;
  padding: 3px!important;
  margin-left: -5px!important;
  width: 25px!important;
  height: 25px!important;
  scale: 103%!important;
  border: 1px solid #181818!important
}
html#main-window body hbox#browser vbox#vertical-tabs-pane.chromeclass-extrachrome vbox#vertical-tabs-inner-box hbox#vertical-tabs-buttons-row toolbarbutton#vertical-tabs-new-tab-button:hover.subviewbutton.subviewbutton-iconic image.toolbarbutton-icon {
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  border-radius: 1px!important;
  scale: 103%!important;
  padding: 1px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#identity-box.unknownIdentity box#identity-icon-box.identity-box-button {
  padding-left: 3px!important;
  padding-right: 3px!important
}
tab[selected=true] .tab-content {
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  background: linear-gradient(.45turn,#303030b8,#313131a1)!important;
  border-radius: 0!important;
  margin: 2px -1px!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
tab[selected=true]:hover .tab-content {
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border-radius: 0!important;
  background-image: linear-gradient(#d1d1d1,#d1d1d1),linear-gradient(#d1d1d1,#d1d1d1),var(--lwt-header-image,none)!important;
  border: 1px solid #555!important
}
tab:not([selected=true]) .tab-content {
  background-color: #242424!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin: 2px 0!important;
  border: 0 solid #353535!important
}
tab:not([selected=true]):hover .tab-content {
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  margin: 2px -1px!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.tabbrowser-tab:not([visuallyselected=true]):hover .tab-text {
  font-weight: 200!important;
  color: #e9e9e9!important
  display: hidden!important;
}
.tabbrowser-tab:not([visuallyselected=true]) .tab-text {
  font-weight: 200!important;
  display: hidden!important;
}
.tabbrowser-tab[visuallyselected=true] .tab-text {
  font-weight: 400!important;
  display: hidden!important;
}
.tab-text {
  color: #e9e9e9!important;
  display: hidden!important;
}
.tab-background {
  background-attachment: none!important;
    background-image: linear-gradient(#222,#222),linear-gradient(#444,#444),var(--lwt-header-image,none)!important
  border-radius: 4px!important;
  border-top: 2px solid #202020!important;
  border-bottom: 2px solid #202020!important;
  border-left: 2px solid #202020!important;
  border-right: 2px solid #202020!important;
  margin-left: 0!important;
  margin-right: 0!important;
  margin-bottom: 0px!important
}
.tabbrowser-tab {
  box-sizing: border-box;
  background-clip: border-box; 
    max-width: 32px!important;
    min-width:32px!important;

  padding: 0 !important;
  margin: 0 !important;
  }
.tab-close-button {
display: none !important;
-moz-appearance: none
}
html#main-window {
  --button-hover-bgcolor: #282828!important;
  --button-active-bgcolor: #232323!important
}
vbox.panel-arrowcontainer box.panel-arrowcontent {
  color: #e9e9e9!important;
  background-color: #222!important;
  border: 0 solid #282828!important;
  border-radius: 3px!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#appMenu-libraryView.PanelUI-subView.cui-widget-panelview {
  padding: 0 7px!important;
  margin-left: -7px!important;
  margin-right: -7px!important
}
window#places hbox#placesView splitter {
  width: 6px!important;
  background-color: #202020!important;
  border: 0 solid #222!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
window#places hbox#placesView vbox#contentView vbox#detailsPane vbox#infoBox vbox#editBookmarkPanelContent vbox#editBookmarkPanelRows vbox#editBMPanel_tagsRow hbox {
  color: #222!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#tracking-protection-icon-container {
  box-shadow: 0 1px 10px #00000088,3px 0 15px 1px #4040405c inset!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#tracking-protection-icon-container:hover {
  background-color: #404040!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container hbox#page-action-buttons hbox#star-button-box.urlbar-icon-wrapper.urlbar-page-action:hover,
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container hbox#page-action-buttons image#pageActionButton.urlbar-icon.urlbar-page-action:hover {
  background-color: #202020!important
}
html#main-window body popupset#mainPopupSet panel#pageActionPanel.cui-widget-panel.panel-no-padding panelmultiview#pageActionPanelMultiView box.panel-viewcontainer box.panel-viewstack panelview#pageActionPanelMainView.PanelUI-subView vbox.panel-subview-body {
  background-color: #222!important
}
#identity-permission-box:hover,
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar hbox#nav-bar-customization-target.customization-target toolbaritem#urlbar-container.chromeclass-location hbox#urlbar hbox#urlbar-input-container box#identity-box.verifiedDomain box#identity-icon-box.identity-box-button:hover {
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
html#main-window body popupset#mainPopupSet panel#identity-popup.panel-no-padding panelmultiview#identity-popup-multiView box.panel-viewcontainer box.panel-viewstack panelview#identity-popup-mainView,
html#main-window body popupset#mainPopupSet panel#protections-popup.panel-no-padding panelmultiview#protections-popup-multiView box.panel-viewcontainer box.panel-viewstack panelview#protections-popup-mainView,
html#main-window body popupset#mainPopupSet panel#protections-popup.panel-no-padding panelmultiview#protections-popup-multiView box.panel-viewcontainer box.panel-viewstack panelview#protections-popup-mainView vbox#protections-popup-mainView-panel-header-section hbox#protections-popup-mainView-panel-header {
  background-color: #222!important
}
html#main-window body box toolbox#navigator-toolbox toolbar#nav-bar.browser-toolbar panel#customizationui-widget-panel.cui-widget-panel.panel-no-padding panelmultiview#customizationui-widget-multiview box.panel-viewcontainer box.panel-viewstack panelview#PanelUI-history.PanelUI-subView.cui-widget-panelview toolbarbutton#PanelUI-historyMore.subviewbutton.subviewbutton-iconic.panel-subview-footer-button {
  margin-left: -22px!important
}
#customization-panelHeader {
  padding: 10px!important;
  margin-left: 1px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  text-align: center!important;
  border-radius: 2px!important;
  margin-right: 1px!important;
  border: 0 solid #282828!important;
  margin-top: -10px!important
}
#customization-panelWrapper > .panel-arrowcontent {
  color: #e9e9e9!important;
  background-color: #222!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: 0 solid #282828!important;
  border-radius: 3px!important;
  margin-top: 21px!important;
  margin-right: -10px!important
}
#customization-panelHolder > #widget-overflow-fixed-list:not(:empty) {
  border: 0 solid #262626!important;
  margin-left: 6px!important;
  margin-right: 6px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 4px!important;
  margin-bottom: -4px!important
}
#customization-palette:not([hidden]) {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 3px!important
}
#customization-header {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding: 10px;
  border-radius: 3px!important;
  text-align: center!important
}
#customization-done-button {
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#customization-done-button:hover {
  color: #e9e9e9!important
}
.customizationmode-button {
  color: #e9e9e9!important;
  background-color: #222!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: 0 solid #282828!important;
  padding: 2px 16px 0!important;
  margin-right: 1px!important;
  margin-left: 1px!important
}
.customizationmode-button:hover {
  color: #e9e9e9!important;
  background-color: #282828!important
}
#customization-uidensity-touch-spacer {
  border-top: 1px solid #282828!important
}
#customization-uidensity-autotouchmode-checkbox {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  padding: 6px!important;
  border-radius: 2px!important
}
.customization-lwtheme-menu-footeritem {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-radius: 2px!important;
  padding: 6px 20px 3px!important
}
#customization-lwtheme-menu-header {
  border-bottom: 0 solid #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border-top: 0!important;
  margin-top: -10px!important;
  margin-left: -10px!important;
  margin-right: -10px!important
}
#customization-panelHolder {
  border-radius: 3px!important
}
#customization-footer {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: none!important;
  background-color: #202020!important
}
html#main-window body popupset#mainPopupSet panel#widget-overflow.panel-no-padding panelmultiview box.panel-viewcontainer box.panel-viewstack panelview#widget-overflow-mainView vbox.panel-subview-body vbox#widget-overflow-fixed-list.widget-overflow-list.customization-target toolbarbutton .toolbarbutton-icon {
  filter: grayscale(100%)!important
}
html#main-window body popupset#mainPopupSet panel#widget-overflow.panel-no-padding panelmultiview box.panel-viewcontainer box.panel-viewstack panelview#widget-overflow-mainView vbox.panel-subview-body vbox#widget-overflow-fixed-list.widget-overflow-list.customization-target toolbarbutton .toolbarbutton-icon:hover {
  filter: grayscale(-100%)!important
}
html#main-window body popupset#mainPopupSet panel#widget-overflow.panel-no-padding panelmultiview box.panel-viewcontainer box.panel-viewstack panelview .PanelUI-subView {
  font-size: 10px!important
}
#downloadsPanel-mainView {
  color: #e9e9e9!important;
  background-color: #222!important
}
#customization-container {
  color: #e9e9e9!important;
  background-color: #202020!important;
  background-image: none!important
}
#sidebar-switcher-target {
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  border: none!important
}
.sidebar-placesTreechildren::-moz-tree-image(title,container) {
  fill: #d1d1d1!important
}
.sidebar-placesTreechildren::-moz-tree-image(selected) {
  fill: #e9e9e9!important
}
.sidebar-placesTreechildren::-moz-tree-image(hover) {
  fill: #e9e9e9!important
}
#sidebar-search-container #search-box {
  -moz-appearance: none!important;
  background-color: #282828!important;
  color: #e9e9e9!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#sidebar-search-container html|.textbox-input {
  background-color: #202020!important;
  color: #e9e9e9!important
}
#bookmarks-view-children,
#historyTree,
#sidebar-header,
#sidebar-search-container {
  color: #e9e9e9!important;
  background-color: #202020!important;
  -moz-appearance: none!important;
  border-color: #202020!important
}
#bookmarks-view treechildren::-moz-tree-cell(hover) {
  background-color: #242424!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#bookmarks-view treechildren::-moz-tree-cell(selected) {
  background-color: #282828!important;
  border: 1px solid #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#sidebar-header {
  background-color: #202020!important;
  color: #e9e9e9!important;
  fill: #e9e9e9!important
}
.sidebar-placesTree treechildren::-moz-tree-cell-text {
  color: #e9e9e9!important
}
panelmultiview[mainViewId=PanelUI-history] {
  --arrowpanel-background: #222
}
.titlebar-spacer[type=pre-tabs] {
  display: none!important
}
.tab-throbber::before {
  fill: #555555!important;
  opacity: 1!important
}
.toolbaritem-combined-buttons:-moz-any(:not([cui-areatype=toolbar]),[overflowedItem=true]) > toolbarbutton:-moz-any(:hover,:focus):not(:-moz-any([disabled],[open],:active)),
.widget-overflow-list .toolbarbutton-1:-moz-any(:hover,:focus):not(:-moz-any([disabled],[open],:active)),
menu.subviewbutton[_moz-menuactive]:not(:-moz-any([disabled],:active)),
menuitem.subviewbutton[_moz-menuactive]:not(:-moz-any([disabled],:active)),
panelview .toolbarbutton-1:-moz-any(:hover,:focus):not(:-moz-any([disabled],[open],:active)),
toolbarbutton.subviewbutton:-moz-any(:hover,:focus):not(:-moz-any([disabled],[open],:active)) {
  background: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}

.toolbarbutton-1 {
  --toolbarbutton-hover-background: #666666 !important;
  --toolbarbutton-active-background: #444444 !important;
}
#sidebar,
.browserContainer,
.sidebar-placesTree {
  background-color: #222!important
}
#widget-overflow panelview,
#widget-overflow-fixed-list {
  color: #e9e9e9!important;
  background-color: #222!important
}
#widget-overflow-list .toolbarbutton-icon {
  display: none;
  visibility: hidden
}
#mainPopupSet menupopup > :is(menu,menuitem) .menu-iconic-left {
  visibility: hidden
}
#titlebar{
   background-image: linear-gradient(#1c1c1c,#1c1c1c),linear-gradient(#1c1c1c,#1c1c1c),var(--lwt-header-image,none)!important;
}
#titlebar #TabsToolbar {
  background: #202020!important
  padding: 0!important;
  margin: 0!important;
}
.titlebar-spacer[type=post-tabs],
.titlebar-spacer[type=pre-tabs] {
  width: 0px!important;
  display: none!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  margin-left: 2px!important;
  margin-right: 2px!important
}
.titlebar-button {
  background-color: -moz-field;
  stroke: ButtonText;
  scale: 77%;
  padding-left: 26px!important;
  padding-right: 28px!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
  transition: scale .2s ease-in-out!important;
  background: #242424!important;
  margin: 0 -7px 0 -8px!important;
  border: 1px solid #181818!important
}
.titlebar-button > .toolbarbutton-icon,
.titlebar-button.titlebar-max > .toolbarbutton-icon,
.titlebar-button.titlebar-min > .toolbarbutton-icon {
  stroke: #f0f0f0!important;
  display: none!important;
}
.titlebar-button.titlebar-close > .toolbarbutton-icon {
  stroke: #e9e9e9!important;
  display: none!important;
}
.titlebar-button:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  border-radius: 2px!important;
  display: none!important;
}
.titlebar-button.titlebar-close:hover {
  border-radius: 2px!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  display: none!important;
}
.tabbrowser-tab::after,
.tabbrowser-tab::before {
  opacity: 1!important;

}
#tabbrowser-tabs:not([movingtab]) > .tabbrowser-tab[beforeselected-visible]::after,
#tabbrowser-tabs[movingtab] > .tabbrowser-tab[visuallyselected]::before,
.tabbrowser-tab:hover > .tab-stack > .tab-background > .tab-line:not([selected=true]),
.tabbrowser-tab[visuallyselected]::after {
  opacity: 1!important;
}
.tabbrowser-tab:not([visuallyselected=true]) {
  color: #a9a9a9!important
}
#tabs-newtab-button {
  fill: #363636 !important
}
#tabs-newtab-button:hover {
  fill: #e9e9e9!important
}
.close-icon > .button-box > .button-icon,
.close-icon > .button-icon,
.close-icon > .toolbarbutton-icon {
  transition: all 0.3s ease !important;
  border-radius: 0!important
}
.tabbrowser-tab > .tab-stack > .tab-background:not([selected=true]) {
  transition: all 0.3s ease !important;
}
.tabbrowser-tab:hover > .tab-stack > .tab-background:not([selected="true"]) {
    background-color: #4c4c4c !important;
}

.tab-line {
  height: 0!important
}
.urlbarView-type-icon {
  min-width: 0!important;
  height: 0!important;
  margin-bottom: 0!important;
  margin-inline-start: 0!important
}
.tabbrowser-tab[label^="New Tab"] .tab-icon-image {
  list-style-image: none!important;
  width: 0!important;
  padding: 10px!important;
  margin-top: 19px!important
}
.tabbrowser-tab[label^="New Tab"]:not([selected]):hover .tab-icon-image {
  margin-top: 19px!important
}
.tabbrowser-tab[label^="New Tab"]:not([selected]) .tab-icon-image {
  margin-top: 20px!important
}
.tabbrowser-tab:not([selected]):hover .tab-icon-image {
  filter: grayscale(0%)!important;
  margin-top: 0!important;
  padding: 10px!important
}
.tabbrowser-tab[label^="about:support"] .tab-icon-image {
  list-style-image: none!important;
  width: 0!important;
  margin-top: 0!important;
  padding: 10px!important
}
.infobar > .icon,
:host([type=system]) .notification-content {
  margin-inline-start: 16px;
  color: #777!important
}
#downloads-button[attention=success] > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-icon,
#downloads-button[attention=success] > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-progress-outer {
  fill: #d1d1d1!important
}
#downloads-button[attention=success] > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-icon:hover,
#downloads-button[attention=success] > .toolbarbutton-badge-stack > #downloads-indicator-anchor > #downloads-indicator-progress-outer:hover {
  fill: #e9e9e9!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#333,#333),linear-gradient(#333,#333),var(--lwt-header-image,none)!important
}
.searchbar-search-button[addengines=true] > .searchbar-search-icon-overlay {
  display: none!important
}
#star-button,
#star-button[starred] {
  fill: #e9e9e900!important
  stroke: #e9e9e9 !important;gi
}
.urlbarView-favicon {
  filter: grayscale(100%)!important;
  box-shadow: 0 1px 10px #00000088,3px 0 13px 1px #4040405c inset!important;
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important;
  padding: 2px!important;
  border-radius: 1px!important
}
#main-window[sizemode=normal] .urlbarView-row:not([type=switchtab],[type=remotetab],[type=search]) .urlbarView-favicon {
  margin-bottom: -18px!important
}
.urlbarView-tags,
.urlbarView-title:not(:empty) ~ .urlbarView-action,
.urlbarView-url {
  margin-inline-start: 10px!important
}
.urlbarView-row:hover .urlbarView-favicon {
  filter: grayscale(0%)!important
}
html#main-window body box toolbox#navigator-toolbox vbox#titlebar toolbar#TabsToolbar.browser-toolbar.titlebar-color hbox.toolbar-items hbox#TabsToolbar-customization-target.customization-target tabs#tabbrowser-tabs arrowscrollbox#tabbrowser-arrowscrollbox tab.tabbrowser-tab stack.tab-stack hbox.tab-content stack.tab-icon-stack image.tab-icon-image[soundplaying] {
  display: none!important
}
.tab-icon-overlay {
  width: 24px!important;
  height: 24px!important;
  -moz-box-ordinal-group: 0!important;
  margin: initial initial 1px -3px!important;
  opacity: 1!important;
  z-index: 1!important;
  scale: 120%!important
}
.tab-icon-overlay[soundplaying-scheduledremoval]:not([muted]):not(:hover) {
  transition: opacity .3s linear var(--soundplaying-removal-delay)!important;
  opacity: 1!important
}
.tab-icon-overlay[activemedia-blocked]:not([crashed]),
.tab-icon-overlay[muted]:not([crashed]),
.tab-icon-overlay[soundplaying] {
  border-radius: 2px!important
}
.tab-icon-overlay[muted][selected]:not([crashed]) {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.tab-icon-overlay[soundplaying][selected] {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.tab-icon-overlay[soundplaying]:not([selected]) {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.tab-icon-overlay[muted]:not([selected]):not([crashed]) {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
.tab-icon-overlay[soundplaying]:not([selected]):hover {
  background-color: #363636!important
}
.tab-icon-overlay[soundplaying][selected]:hover {
  border: 1px solid #555!important;
  background-image: linear-gradient(#282828,#282828),linear-gradient(#282828,#282828),var(--lwt-header-image,none)!important
}
:root {
  --tab-min-height: 24px!important;
  --background: #222!important;
  --odd-bg-row: #222!important;
  --textcolor: #e9e9e9!important;
  --iconcolor: #e9e9e9!important;
  --selected-iconcolor: #e9e9e9!important;
  --hover-iconcolor: #e9e9e9!important;
  --bordercolor: #e9e9e9!important;
  --hover-text-row: #e9e9e9!important;
  --selected-text-row: #e9e9e9!important;
  --downloads-item-height: 24px!important
}
window#places[title=Library] {
  background-color: var(--background)!important
}
#placesMenu > menu[open] {
  -moz-appearance: none!important;
  background-color: var(--hover-bg-row)!important;
  border: 0 var(--textcolor)!important
}
#placesMenu menupopup {
  -moz-appearance: none!important;
  background-color: var(--background)!important;
  color: var(--textcolor)!important;
  fill: var(--iconcolor)!important;
  border: 0 solid var(--bordercolor)!important
}
window#places toolbox#placesToolbox toolbar#placesToolbar.chromeclass-toolbar spacer#libraryToolbarSpacer {
  box-shadow: none!important
}
#placesToolbar {
  background-color: var(--background)!important
}
#placesToolbar > toolbarbutton[disabled] > .toolbarbutton-icon {
  opacity: .65!important
}
#placesToolbar > #back-button > .toolbarbutton-icon,
#placesToolbar > #forward-button > .toolbarbutton-icon {
  fill: #e9e9e9!important
}
#placesMenu > menu > .menubar-text {
  color: var(--textcolor)!important
}
#placesMenu menupopup menuitem[disabled] {
  color: var(--textcolor)!important;
  opacity: .45!important
}
#placesMenu menupopup menuseparator {
  display: none!important
}
#downloadsRichListBox {
  background-color: var(--background)!important;
  border-bottom: 1px var(--bordercolor)!important;
  color: var(--textcolor)!important
}
richlistitem[selected=true] {
  color: #e9e9e9!important;
  background-color: #242424!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
.downloadTypeIcon {
  margin: 8px 13px!important;
  width: 24px!important;
  height: 24px!important
}
#infoPane,
#placeContent,
#placesList,
#placesView,
#placesView .scrollbox-innerbox {
  -moz-appearance: none!important;
  background-color: var(--background)!important;
  color: var(--textcolor)!important
}
#placeContent treecol {
  -moz-appearance: none!important;
  background-color: var(--background)!important;
  padding: 3px!important;
  color: var(--textcolor)!important;
  border-top: 1px var(--bordercolor)!important;
  border-right: 1px var(--bordercolor)!important;
  border-bottom: 1px var(--bordercolor)!important
}
#placeContent treecol:hover {
  -moz-appearance: none!important;
  background-color: var(--hoverBGcolor)!important;
  color: var(--hover-text-row)!important
}
#placesView > splitter {
  border-inline-end: 1px var(--bordercolor)!important
}
#placesList {
  border-top: 1px var(--bordercolor)!important;
  border-bottom: 1px var(--bordercolor)!important
}
#placeContent treechildren::-moz-tree-cell-text(hover) {
  color: var(--hover-text-row)!important
}
#placeContent treechildren::-moz-tree-cell-text(selected) {
  color: var(--selected-text-row)!important
}
#placeContent treechildren::-moz-tree-row {
  background-color: var(--background)!important
}
#placeContent treechildren::-moz-tree-row(odd) {
  background-color: var(--odd-bg-row)!important
}
#placesView treechildren::-moz-tree-row(hover) {
  background-color: var(--hover-bg-row)!important
}
#placesView treechildren::-moz-tree-row(selected) {
  background-color: var(--hover-bg-row)!important
}
#placesView treechildren::-moz-tree-image {
  fill: var(--iconcolor)!important
}
#placesView treechildren::-moz-tree-image(titlehover) {
  fill: var(--hover-iconcolor)!important
}
#placesView treechildren::-moz-tree-image(titleselected) {
  fill: var(--selected-iconcolor)!important
}
#placesView treechildren::-moz-tree-image(containerselected) {
  fill: var(--selected-iconcolor)!important
}
#placesList treechildren::-moz-tree-image {
  fill: var(--iconcolor)!important
}
#placesList treechildren::-moz-tree-image(titlehover) {
  fill: var(--hover-iconcolor)!important
}
#placesList treechildren::-moz-tree-image(containerhover) {
  fill: var(--hover-iconcolor)!important
}
#placesList treechildren::-moz-tree-image(titleselected) {
  fill: var(--selected-iconcolor)!important
}
#placesList treechildren::-moz-tree-image(containerselected) {
  fill: var(--selected-iconcolor)!important
}
#placesList treechildren::-moz-tree-row(hover) {
  background-color: var(--hover-bg-row)!important
}
#placesList treechildren::-moz-tree-row(selected) {
  background-color: var(--hover-bg-row)!important
}
#placesList treechildren::-moz-tree-cell-text(hover) {
  color: var(--hover-text-row)!important
}
#placesList treechildren::-moz-tree-cell-text(selected) {
  color: var(--selected-text-row)!important
}
#searchFilter {
  -moz-appearance: none!important;
  background-color: transparent!important;
  border: 1px var(--bordercolor)!important;
  color: var(--textcolor)!important
}
#searchFilter[focused] {
  box-shadow: var(--input-field-focus-shadow)!important;
  background-color: var(--background)!important;
  color: var(--textcolor)!important
}
#clearDownloadsButton {
  color: #e9e9e9!important;
  background-color: #222!important
}
#clearDownloadsButton[disabled] {
  opacity: 1!important
}
#clearDownloadsButton:hover {
  color: #e9e9e9!important;
  background-color: #282828!important;
  box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important
}
#detailsDeck {
  background-color: var(--background)!important;
  color: var(--textcolor)!important;
  border-top: 1px solid var(--bordercolor)!important
}
#editBMPanel_keywordField,
#editBMPanel_locationField,
#editBMPanel_namePicker,
#editBMPanel_tagsField,
#editBMPanel_tagsSelector,
#infoBox listbox,
#infoBox textbox {
  -moz-appearance: none!important;
  border: 1px var(--bordercolor)!important;
  background-color: var(--background)!important;
  color: var(--textcolor)!important
}
#detailsDeck button {
  -moz-appearance: none!important;
  filter: invert(56%) sepia(80%) saturate(2591%) hue-rotate(81deg) brightness(118%) contrast(128%)!important
}
@-moz-document url("chrome://browser/content/places/places.xhtml") {
  treechildren::-moz-tree-row(selected) {
    border: 0 solid #d1d1d1!important;
    box-shadow: 0 1px 3px #00000088,0 0 0 1px #4040405c inset!important;
    color: #e9e9e9
  }
  html#main-window body popupset#mainPopupSet panel#appMenu-notification-popup.popup-notification-panel.panel-no-padding popupnotification#appMenu-update-available-notification hbox.popup-notification-button-container.panel-footer button.popup-notification-button.popup-notification-secondary-button:hover {
    background-color: #282828!important
  }
}
#PopupAutoCompleteRichResult .autocomplete-richlistitem, .urlbarView-row {border-bottom: 2px solid #212121 !important;}



#placesMenu menupopup menu,
#placesMenu menupopup menuitem {
  padding: 0px 0 !important;
}

.tabbrowser-tab .tab-icon-image {
    margin-top: -1px !important;
    margin-left: 3px !important;
}

''
