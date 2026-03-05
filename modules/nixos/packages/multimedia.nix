{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  # Check if this is the bagalamukhi host (tlh user)
  isBagalamukhi = config.networking.hostName == "bagalamukhi";
  # Check if this is the matangi host (smg user)
  isMatangi = config.networking.hostName == "matangi";
in {
  options.modules.packages.multimedia = {
    enable = mkEnableOption "Multimedia packages for audio, video, and image processing";

    videoTools = mkEnableOption "Video processing and editing tools" // {default = true;};
    imageTools = mkEnableOption "Image processing and editing tools" // {default = true;};
    streamingTools = mkEnableOption "Streaming and recording tools" // {default = true;};
    gstreamerPlugins = mkEnableOption "Complete GStreamer plugin ecosystem" // {default = true;};
    creators = mkEnableOption "Content creation tools (advanced editors)" // {default = false;};
    minimal = mkEnableOption "Minimal multimedia for live/ISO environments";
  };

  config = mkMerge [
    # Minimal preset: keep image tools, disable heavy video/streaming stacks
    (mkIf config.modules.packages.multimedia.minimal {
      modules.packages.multimedia = {
        videoTools = mkDefault false;
        streamingTools = mkDefault false;
        gstreamerPlugins = mkDefault false;
      };
    })

    (mkIf config.modules.packages.multimedia.enable {
      environment.systemPackages = with pkgs;
        []
        # Core multimedia framework
        ++ [
          ffmpeg-full
          vlc
        ]
        # Video processing tools
        ++ optionals config.modules.packages.multimedia.videoTools [
          cheese
          ffcast
          flowblade
          frei0r
          fswebcam
          gallery-dl
          losslesscut-bin
          mjpegtoolsFull
          mp4v2
          oggvideotools
          peek
          spotdl
          vid-stab
          vidmerger
          vvenc
          yt-dlp
          xvidcore
        ]
        # Image processing tools
        ++ optionals config.modules.packages.multimedia.imageTools [
          autotrace
          babl
          cairosvg
          colorz
          curtail
          exiftool
          feh
          figlet
          gdk-pixbuf
          gegl
          geticons
          gif-for-cli
          giflib
          gifsicle
          giph
          gmic
          gnome-obfuscate
          gradia
          graphicsmagick
          image-roll
          image_optim
          imagemagick
          imlib2-nox
          imlib2Full
          img-cat
          imgcat
          inkscape-with-extensions
          jpeginfo
          jpegoptim
          libexif
          libjpeg
          libpng
          librsvg
          libspng
          libwebp
          meme-image-generator
          metapixel
          mozjpeg
          nodePackages_latest.svgo
          optipng
          oxipng
          perlPackages.ImageMagick
          perlPackages.PerlMagick
          pngcrush
          pngtoico
          pngtools
          potrace
          python312Packages.colorthief
          python312Packages.pyfiglet
          python312Packages.pystache
          python312Packages.svgwrite
          resvg
          satty
          scour
          smile
          svgcleaner
          t1utils
          termcolor
          toilet
          uni
          upscayl
          upscayl-ncnn
          xcolor
          emote
        ]
        # Streaming and recording tools
        ++ optionals config.modules.packages.multimedia.streamingTools [
          menyoki
          megapixels
          pipeline
          switcheroo
          traverso
          webp-pixbuf-loader
        ]
        # GStreamer plugins
        ++ optionals config.modules.packages.multimedia.gstreamerPlugins [
          gst_all_1.gst-devtools
          gst_all_1.gst-editing-services
          gst_all_1.gst-libav
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-vaapi
          gst_all_1.gstreamer
          gst_all_1.gstreamermm
        ]
        # Advanced content creation tools
        ++ optionals config.modules.packages.multimedia.creators ([
            gimp3-with-plugins
            gimp3Plugins.gmic
          ]
          ++ optionals isMatangi [
            # olive-editor ONLY for matangi host, using stable version
            pkgs.stable.olive-editor
            # shotcut ONLY for matangi host, using stable version
            pkgs.stable.shotcut
          ]
          ++ [
            beautysh
            gi-docgen
            gibo
            gnome.nixos-gsettings-overrides
            gsettings-desktop-schemas
            imgpatchtools
            libdrm
            libgee
            libplacebo
            librem
            libtheora
            libvpl
            libwebcam
            lrzip
            lsix
            lv2
            p7zip
            pantheon.granite
            python312Packages.pygobject3
            redoflacs
          ]);
    })
  ];
}
