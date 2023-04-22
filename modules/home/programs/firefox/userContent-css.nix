{}:

''@namespace xul url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");
@namespace html url("http://www.w3.org/1999/xhtml");

/* Variables that start with --gnome- are added by me and are assigned
 * to elements somewhere in this code. The rest of the variables are
 * built-in in Firefox, so you need to add an !important if you wanna
 * override them. */

 :root {
	/* Browser area before a page starts loading */
	--gnome-browser-before-load-background: #F7F7F7;

	/* Accent */
	--gnome-accent-bg: #5b9bf8;
	--gnome-accent: #3c84f7;

	/* Toolbars */
	--gnome-toolbar-background: #efefef;
	--gnome-toolbar-color: rgb(46, 52, 54);
	--gnome-toolbar-border-color: rgba(0, 0, 0, .15);
	--gnome-toolbar-icon-fill: #2e3436;
	--gnome-inactive-toolbar-background: #fafafa;
	--gnome-inactive-toolbar-color: #d5d0cc;
	--gnome-inactive-toolbar-border-color: #DCDCDC;
	--gnome-inactive-toolbar-icon-fill: #929595;

	/* Sidebar */
	--gnome-sidebar-background: var(--gnome-toolbar-background);
	--gnome-inactive-sidebar-background: var(--gnome-sidebar-background);

	/* Menu */
	--gnome-menu-background: #ffffff;
	--gnome-menu-border-color: rgba(0, 0, 0, .2);
	--gnome-menu-shadow: 0 1px 5px 1px rgba(0,0,0, .09), 0 2px 14px 3px rgba(0,0,0, .05);
	--gnome-menu-button-hover-background: var(--gnome-button-background);
	--gnome-menu-separator-color: rgba(0, 0, 0, 0.1);

	/* Header bar */
	--gnome-headerbar-background: #f2f2f2;
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
	--gnome-titlebutton-min-background: #fdbe04;
	--gnome-titlebutton-max-background: #38c76a;
	--gnome-titlebutton-close-background: #fd5f51;
	--gnome-titlebutton-min-hover-background: #fdbe04;
	--gnome-titlebutton-max-hover-background: #38c76a;
	--gnome-titlebutton-close-hover-background: #fd5f51;
	--gnome-titlebutton-min-active-background: #fdcd43;
	--gnome-titlebutton-max-active-background: #6ad48e;
	--gnome-titlebutton-close-active-background: #fb857c;

	/* Entries */
	--gnome-entry-background: rgba(0, 0, 0, .08);
	--gnome-entry-color: #303030;
	--gnome-inactive-entry-color: #303030;
	--gnome-focused-urlbar-border-color: rgba(28, 113, 216, .5);
	--gnome-urlbarView-shadow: 0 1px 5px 1px rgba(0,0,0, .15),
	                           0 2px 14px 3px rgba(0,0,0, .1),
	                           0 0 0 1px rgba(0,0,0, .08);

	/* Switch */
	--gnome-switch-background: rgba(0, 0, 0, .12);
	--gnome-switch-slider-background: #ffffff;
	--gnome-switch-active-background: var(--gnome-accent-bg);
	--gnome-switch-active-slider-background: #ffffff;

	/* Tabs */
	--gnome-tabbar-tab-background: #efefef;
	--gnome-tabbar-tab-border-color: var(--gnome-toolbar-border-color);
	--gnome-tabbar-tab-hover-background: #dedede;
	--gnome-tabbar-tab-active-background: #ffffff;
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
	--gnome-private-accent: #272F42;
	
	/* Toolbars */
	--gnome-private-toolbar-background: #EAF0F7;
	--gnome-private-inactive-toolbar-background: var(--gnome-private-toolbar-background);
	/* Menus */
	--gnome-private-menu-background: #D7E3F0;
	/* Header bar */
	--gnome-private-headerbar-background: #D7E3F0;
	--gnome-private-inactive-headerbar-background: var(--gnome-private-toolbar-background);

	/* Text color for Firefox Logo in new private tab */
	--gnome-private-wordmark: #20123A;

	/* New private tab background */
	--gnome-private-in-content-page-background: #EAF0F7;

	/* Private browsing info box */
	--gnome-private-text-primary-color: #15141A;
}

/* Variables that start with --gnome- are added by me and are assigned
 * to elements somewhere in this code. The rest of the variables are
 * built-in in Firefox, so you need to add an !important if you wanna
 * override them. */
 @media (prefers-color-scheme: dark) {
	:root {
		/* Browser area before a page starts loading */
		--gnome-browser-before-load-background: #242424;

		/* Accent */
		--gnome-accent-bg: #3584e4;
		--gnome-accent: #78aeed;

		/* Toolbars */
		--gnome-toolbar-background: #2c2c2c;
		--gnome-toolbar-color: #ffffff;
		--gnome-toolbar-border-color: rgba(255, 255, 255, .15);
		--gnome-toolbar-icon-fill: #eeeeee;
		--gnome-inactive-toolbar-color: #919191;
		--gnome-inactive-toolbar-background: var(--gnome-toolbar-background);
		--gnome-inactive-toolbar-border-color: #3F3F3F;
		--gnome-inactive-toolbar-icon-fill: #919191;

		/* Sidebar */
		--gnome-sidebar-background: var(--gnome-toolbar-background);
		--gnome-inactive-sidebar-background: var(--gnome-sidebar-background);

		/* Menus */
		--gnome-menu-background: #383838;
		--gnome-menu-border-color: rgba(0, 0, 0, .65);
		--gnome-menu-shadow: 0 1px 5px 1px rgba(0,0,0, .09),
		                     0 2px 14px 3px rgba(0,0,0, .05),
		                     inset 0 0 0 1px rgba(255, 255, 255, 0.1);
		--gnome-menu-button-hover-background: var(--gnome-button-background);
		--gnome-menu-separator-color: rgba(255, 255, 255, .1);

		/* Header bar */
		--gnome-headerbar-background: #242424;
		--gnome-headerbar-border-color: var(--gnome-toolbar-border-color);
		--gnome-inactive-headerbar-background: #2c2c2c;
		--gnome-inactive-headerbar-border-color: var(--gnome-inactive-toolbar-border-color);

		/* Buttons */
		--gnome-button-background: rgba(255, 255, 255, .1);
		--gnome-button-hover-background: rgba(255, 255, 255, .15);
		--gnome-button-active-background: rgba(255, 255, 255, .3);
		--gnome-button-flat-hover-background: rgba(255, 255, 255, .07);
		--gnome-button-flat-active-background: rgba(255, 255, 255, .1);
		--gnome-button-suggested-action-background: var(--gnome-accent-bg);
		--gnome-button-destructive-action-background: #e01b24;

		--gnome-button-close-background: var(--gnome-button-flat-hover-background);
		--gnome-button-hover-close-background:var(--gnome-button-hover-background);
		--gnome-button-active-close-background: var(--gnome-button-active-background);

		/* TitleButtons */
		--gnome-titlebutton-min-background: #fdbe04;
		--gnome-titlebutton-max-background: #38c76a;
		--gnome-titlebutton-close-background: #fd5f51;
		--gnome-titlebutton-min-hover-background: #fdbe04;
		--gnome-titlebutton-max-hover-background: #38c76a;
		--gnome-titlebutton-close-hover-background: #fd5f51;
		--gnome-titlebutton-min-active-background: #fdcd43;
		--gnome-titlebutton-max-active-background: #6ad48e;
		--gnome-titlebutton-close-active-background: #fb857c;

		/* Entries */
		--gnome-entry-background: rgba(255, 255, 255, .08);
		--gnome-entry-color: #ffffff;
		--gnome-inactive-entry-color: #d6d6d6;
		--gnome-focused-urlbar-border-color: rgba(120, 174, 237, .5); /* Same as --gnome-accent but with opacity*/
		--gnome-urlbarView-shadow: 0 1px 5px 1px rgba(0,0,0, .2),
		                           0 2px 14px 3px rgba(0,0,0, .15),
		                           0 0 0 1px rgba(0, 0, 0, 0.75);

		/* Switch */
		--gnome-switch-background: rgba(255, 255, 255, .15);
		--gnome-switch-slider-background: #d2d2d2;
		--gnome-switch-active-background: var(--gnome-accent-bg);
		--gnome-switch-active-slider-background: #ffffff;

		/* Tabs */
		--gnome-tabbar-tab-background: #2c2c2c;
		--gnome-tabbar-tab-border-color: var(--gnome-toolbar-border-color);
		--gnome-tabbar-tab-hover-background: #363636;
		--gnome-tabbar-tab-active-background: #404040;
		--gnome-tabbar-tab-active-background-contrast: #4F4F4F;
		--gnome-tabbar-tab-active-hover-background: #444444;
		--gnome-inactive-tabbar-tab-background: #2c2c2c;
		--gnome-inactive-tabbar-tab-active-background: #323232;
		--gnome-tab-button-background: rgba(0, 0, 0, .5);
		--gnome-tab-button-hover-background: rgba(0, 0, 0, .6);
		--gnome-tabbar-tab-identity-base-opacity: 0;
	}

	/* Private window colors */
	:root {
		--gnome-private-accent: #71A1DB;

		/* Toolbars */
		--gnome-private-toolbar-background: #1C2438;
		--gnome-private-inactive-toolbar-background: var(--gnome-private-toolbar-background);
		/* Menus */
		--gnome-private-menu-background: #252F49;
		/* Header bar */
		--gnome-private-headerbar-background: #252F49;
		--gnome-private-inactive-headerbar-background: var(--gnome-private-toolbar-background);

		/* Text color for Firefox Logo in new private tab */
		--gnome-private-wordmark: #FBFBFE;

		/* New private tab background */
		--gnome-private-in-content-page-background: #1C2438;

		/* Private browsing info box */
		--gnome-private-text-primary-color: #FBFBFE;
	}
}

@-moz-document url("about:newtab"), url("about:home") {
  body {
      --newtab-background-color: var(--gnome-browser-before-load-background) !important;
      --newtab-background-color-secondary: var(--gnome-menu-background) !important;
      --newtab-primary-action-background: var(--gnome-accent) !important;
  }
}
@-moz-document url("about:privatebrowsing") {
  html.private {
      --in-content-page-background: var(--gnome-private-in-content-page-background) !important;

      /* Used by headings in promo boxes Firefox shows (like an ad for Firefox Focus) */
      --in-content-text-color: var(--gnome-private-text-primary-color) !important;
  }
  .wordmark {
      fill: var(--gnome-private-wordmark) !important;
  }
  .showPrivate {
      color: var(--gnome-private-text-primary-color);
  }
}

.progressBar::-moz-progress-bar {
	background-color: #fff !important;
}

.scrubber:hover::-moz-range-thumb,
.volumeControl:hover::-moz-range-thumb {
	background-color: #ccc !important;
}

.scrubber:active::-moz-range-thumb,
.volumeControl:active::-moz-range-thumb {
	background-color: #bbb !important;
}

.controlBar {
	border-radius: 5px;
	margin: auto;
	margin-bottom: 5px;
	width: 98.5%;
	max-width: 800px;
	height: 30px !important;
	background-color: rgba(20,20,20,0.8) !important;
}

.controlBar > .button:enabled:hover {
	fill: #ccc !important;
}
  
.controlBar > .button:enabled:hover:active {
	fill: #bbb !important;
}

.scrubberStack {
	margin: 0 10px;
}

.playButton {
	scale: 0.8;
}
  


/** Vertical Volume Bar **/
/* I'm to stupid to get this working. Wasn't able to set proper position relative to mute button */

/* .muteButton:hover ~ .volumeStack{
	margin-bottom: 129px !important;
  }
	.volumeStack:hover {
	margin-bottom: 129px !important;
  }
  
  .volumeStack {
	transform: rotate(270deg);
	max-height: 33px !important;
	min-width: 100px !important;
  position:absolute !important;
  margin-bottom: -150px !important;
	background-color: rgba(20,20,20,0.8) !important;
	border-bottom-right-radius: 5px !important;
	border-top-right-radius: 5px !important;
	transition-property: margin-bottom;
	transition-duration: 0.13s;
	transition-timing-function: linear;
  }
  
  .volumeControl{
	  width: 92% !important;
	  margin-left: 5px !important;
} */

''
