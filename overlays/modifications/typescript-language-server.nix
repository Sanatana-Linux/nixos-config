{inputs, ...}: {
  modifications = final: prev: let
    # Import stable nixpkgs for pinned Python packages
    stable-pkgs = import inputs.stable {
      system = final.stdenv.hostPlatform.system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = ["electron-39.8.10"];
      };
    };
  in {
    # nixpkgs' typescript-language-server 6.0.2 ships a pnpmDeps hash that no
    # longer reproduces (the FOD aborts). Use the stable-channel 5.3.0 instead.
    typescript-language-server = stable-pkgs.typescript-language-server;
  };
}
