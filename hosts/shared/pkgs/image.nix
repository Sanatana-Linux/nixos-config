{pkgs, ...}:
with pkgs; [
  autotrace # Convert bitmap to vector graphics
  babl # Dynamic pixel format translation library
  cairosvg # SVG converter based on Cairo
  colorz # Color scheme generator from images
  curtail # Image compression tool
  emote # Emoji picker for Linux
  exiftool # Read and write meta information in files
  feh # Fast and light image viewer
  figlet # ASCII art text generator
  gdk-pixbuf # Image loading library
  gegl # Generic Graphics Library
  geticons # Icon extraction tool
  gif-for-cli # Display GIFs in terminal
  giflib # Library for reading and writing GIF images
  gifsicle # Command-line tool for creating and editing GIFs
  gimp3-with-plugins # GNU Image Manipulation Program version 3
  gimp3Plugins.gmic # G'MIC plugin for GIMP 3
  giph # GIF creation tool
  gmic # Image processing framework
  gnome-obfuscate # Censor private information in images
  gradia # Gradient generator
  graphicsmagick # Image processing system
  image-roll # Fast and simple GTK image viewer
  image_optim # Image optimization tool
  imagemagick # Image manipulation programs
  imlib2-nox # Image loading library (no X11)
  imlib2Full # Image loading library (full version)
  img-cat # Display images in terminal
  imgcat # Display images inline in iTerm2
  inkscape-with-extensions # Vector graphics editor with extensions
  jpeginfo # Print information about JPEG files
  jpegoptim # JPEG optimization utility
  libexif # Library for parsing EXIF files
  libjpeg # JPEG image compression library
  libpng # PNG image format library
  librsvg # SVG rendering library
  libspng # Simple PNG library
  libwebp # WebP image format library
  meme-image-generator # Create meme images
  metapixel # Photomosaic generator
  mozjpeg # Improved JPEG encoder
  nodePackages_latest.svgo # SVG optimizer
  optipng # PNG optimizer
  oxipng # Parallel PNG optimizer in Rust
  perlPackages.ImageMagick # Perl interface to ImageMagick
  perlPackages.PerlMagick # Perl interface to ImageMagick (legacy name)
  pngcrush # PNG optimization tool
  pngtoico # Convert PNG to Windows icon format
  pngtools # PNG manipulation utilities
  potrace # Transform bitmaps into vector graphics
  python312Packages.colorthief # Extract color palettes from images
  python312Packages.pyfiglet # Python implementation of figlet
  python312Packages.pystache # Mustache template renderer
  python312Packages.svgwrite # Python library to create SVG drawings
  # rclip # ai image search - DISABLED: requires python3.13-torch which OOMs display manager during compilation
  resvg # SVG rendering library
  satty # Screenshot annotation tool
  scour # SVG optimizer written in Python
  smile # Emoji picker
  svgcleaner # Clean and optimize SVG files
  t1utils # Type 1 font manipulation utilities
  termcolor # ANSI color formatting for terminal output
  toilet # Display large colorful characters
  uni # Query Unicode character information
  upscayl # AI image upscaling application
  upscayl-ncnn # AI upscaling CLI tool using NCNN
  xcolor # Pick colors from screen
]
