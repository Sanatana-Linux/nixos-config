{ config, pkgs, ... }:

{

  gtk = {
    	enable = true;
	font = {
		name = "Monomaniac One";
		size = 11;
	};
	iconTheme = {
		name = "Fluent-Dark";
		package = pkgs.fluent-icon-theme;
	};
	cursorTheme = {
		name = "Phinger Cursors (light)";
		package = pkgs.phinger-cursors;
		size = 24;
	};
	theme = {
		name = "Orchis-Dark";
		package = pkgs.orchis;
	};
	gtk2 = {
		configLocation = "/home/paul/.gtkrc-2.0";
		extraConfig = ''
			gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
			gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
			gtk-button-images=1
			gtk-menu-images=1
			gtk-enable-event-sounds=1
			gtk-enable-input-feedback-sounds=1
			gtk-xft-antialias=1
			gtk-xft-hinting=1
			gtk-xft-hintstyle="hintslight"
			gtk-xft-rgba="rgba"
			'';
	};
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
  };


  # services
  services.playerctld.enable = true;



}
