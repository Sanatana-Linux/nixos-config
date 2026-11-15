{inputs, ...}: {
  stable-packages = final: prev: {
    stable =
      prev
      // {
        inherit
          (import inputs.stable {
            system = final.stdenv.hostPlatform.system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "electron-39.8.10"
              ];
            };
          })
          efitools
          inkscape
          inkscape-with-extensions
          gimp3-with-plugins
          calibre
          ffmpeg-full
          ;
      };
  };
}
