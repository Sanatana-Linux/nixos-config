{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.system.multimedia;
in {
  options.modules.system.multimedia = {
    enable = mkEnableOption "Multimedia packages";
    minimal = mkOption {
      type = types.bool;
      default = false;
      description = "Minimal multimedia for live/ISO environments";
    };
    videoTools = mkOption {
      type = types.bool;
      default = true;
      description = "Video processing and editing tools";
    };
    imageTools = mkOption {
      type = types.bool;
      default = true;
      description = "Image processing and editing tools";
    };
    streamingTools = mkOption {
      type = types.bool;
      default = true;
      description = "Streaming and recording tools";
    };
    gstreamerPlugins = mkOption {
      type = types.bool;
      default = true;
      description = "Complete GStreamer plugin ecosystem";
    };
    creators = mkOption {
      type = types.bool;
      default = true;
      description = "Content creation tools (gimp, inkscape)";
    };
    stableVideoEditors = mkOption {
      type = types.bool;
      default = true;
      description = "Stable video editors";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.minimal {
      modules.system.multimedia = {
        streamingTools = mkDefault false;
        gstreamerPlugins = mkDefault false;
        creators = mkDefault false;
        stableVideoEditors = mkDefault false;
      };
    })
    {
      environment.systemPackages = with pkgs;
        [ffmpeg-full vlc]
        ++ optionals cfg.videoTools [
          libaom
          dav1d
          libtheora
          libvpl
          cheese
          fswebcam
          libwebcam
          v4l-utils
          libcamera
          gst_all_1.gst-devtools
          gst_all_1.gst-rtsp-server
          ladspa-sdk
          lv2
          swh
          mjpegtools
          mp4v2
          oggvideotools
          peek
          yt-dlp
          svt-av1
          # Video editing effects and filters
          frei0r
          mlt
          movit
          opencv
          chromaprint
          rubberband
          sox
          audiowaveform
        ]
        ++ optionals cfg.imageTools [
          imagemagick
          graphicsmagick
          image_optim
          gegl
          cairosvg
          svgo
          svgcleaner
          optipng
          oxipng
          pngcrush
          pngquant
          jpegoptim
          jpeginfo
          gthumb
          exiftool
          libexif
          libpng
          libjpeg
          mozjpeg
          libwebp
          libjxl
          libavif
          libheif
          librsvg
          giflib
          gifsicle
          resvg
          pngtools
          pngtoico
          libspng
          t1utils
          imgcat
          lsix
          ascii-image-converter
          cfonts
          uni
          termcolor
          python312Packages.pyfiglet
          autotrace
          potrace
          metapixel
          emote
          gdk-pixbuf
          perlPackages.ImageMagick
          perlPackages.PerlMagick
          python312Packages.colorthief
          python312Packages.pystache
          python312Packages.svgwrite
        ]
        ++ optionals cfg.streamingTools [pipewire traverso giph webp-pixbuf-loader]
        ++ optionals cfg.gstreamerPlugins [
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          gst_all_1.gst-plugins-good
          gst_all_1.gst-plugins-bad
          gst_all_1.gst-plugins-ugly
          gst_all_1.gst-plugins-rs
          gst_all_1.gst-libav
          gst_all_1.gst-editing-services
        ]
        ++ optionals cfg.creators [gimp3-with-plugins inkscape-with-extensions]
        ++ optionals cfg.stableVideoEditors [
          pkgs.stable.olive-editor
          pkgs.stable.shotcut
          pkgs.stable.openshot-qt
          losslesscut-bin
          vid-stab
          vidmerger
          vvenc
          x264
          x265
        ];
    }
  ]);
}
