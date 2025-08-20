# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    nps = inputs.nps.defaultPackage.${prev.system};
    

	newm = inputs.newm.packages.newm.overrideAttrs (old: rec {
		postInstall = ''
			mkdir -p $out/share/wayland-sessions/
			cp newm/resources/newm.desktop $out/share/wayland-sessions/
		'';
	
		passthru.providedSessions = [ "newm" ];                   
	});   

    };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'

  unstable-packages = final: prev: {
    unstable = import inputs.unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  f2k-packages = final: prev: {
    f2k = import inputs.nixpkgs-f2k {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  stable-packages = final: prev: {
    stable = import inputs.stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  master-packages = final: prev: {
    master = import inputs.nixpkgs-master {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  chaotic-packages = final: prev: {
    chaotic = import inputs.chaotic {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
