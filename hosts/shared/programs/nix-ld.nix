{
  lib,
  config,
  pkgs,
  ...
}: {
  # This file configures nix-ld, a Nix utility that enables running dynamically linked bin
  # not built with Nix by providing a compatible runtime environment. The packages listed
  # are included to supply shared libraries and tools commonly required by such binaries,
  # ensuring they can find their dependencies at runtime when executed on a NixOS system.

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      xdotool
      xdo
      # Graphics
      clutter
      clutter-gtk # Clutter graphics library with GTK3 support
      libGL # OpenGL library
      libGLU # OpenGL Utility Library
      libGLX # GLX (OpenGL Extension to the X Window System)
      libglut # OpenGL Utility Toolkit
      libglvnd # GL Vendor-Neutral Dispatch library
      freeglut # Alternative to GLUT
      glew # OpenGL Extension Wrangler
      glew_1_10 # Older version of GLEW for compatibility
      glfw # OpenGL framework for window/context/input
      mesa # Open-source OpenGL implementation
      xorg_sys_opengl # Xorg OpenGL system integration
      xorg.libxshmfence # X shared memory fence Library
      libva # Video Acceleration API
      libva-utils # Utilities for VA-API

      perl

      # SDL (Simple DirectMedia Layer)
      SDL # SDL 1.2, cross-platform multimedia library
      SDL2 # SDL 2.x, newer version
      SDL2_gfx # SDL2 graphics extensions
      SDL2_image # Image loading for SDL2
      SDL2_mixer # Audio mixing for SDL2
      SDL2_image # Image loading for SDL1
      SDL2_mixer # Audio mixing for SDL1
      SDL2_net
      SDL2_sound # Sound library for SDL2
      SDL2_ttf # TrueType font rendering for SDL2
      SDL2_Pango # Pango text rendering to SDL
      SDL_compat # Compatibility layer for SDL1 to SDL2

      # Audio
      alsa-lib-with-plugins # ALSA sound library with plugins
      flac # Free Lossless Audio Codec library
      libmikmod # Module music file player library
      libogg # Ogg bitstream library
      libpulseaudio # PulseAudio sound server client library
      libsamplerate # Audio sample rate conversion
      libtheora # Theora video codec library
      libvorbis # Vorbis audio codec library
      libvpx # VP8/VP9 video codec library
      portaudio # Cross-platform audio I/O library
      speex # Speech codec library

      # CUDA/NVIDIA
      config.boot.kernelPackages.nvidiaPackages.production # NVIDIA X11 kernel module
      # cudaPackages.cudnn # NVIDIA CUDA Deep Neural Network library
      # cudaPackages.nccl # NVIDIA Collective Communications Library
      # cudaPackages.nvidia_fs # NVIDIA file system support
      # cudaPackages.libnvjitlink # CUDA JIT linker
      # cudaPackages.cuda_cccl # CUDA C++ Core Libraries
      # cudaPackages.cuda_cudart # CUDA runtime library
      # cudaPackages.cuda_gdb # CUDA debugger
      # cudaPackages.saxpy # CUDA sample code
      # cudaPackages.cuda_nvml_dev # NVIDIA Management Library (dev)
      # cudaPackages.cuda_opencl # CUDA OpenCL support
      # cudaPackages.cudatoolkit # CUDA toolkit
      # cudaPackages.libcublas # CUDA BLAS library
      # cudaPackages.libcusparse # CUDA sparse matrix library
      # cudatoolkit # CUDA toolkit (meta)
      intel-media-driver # Intel VAAPI driver for GPUs
      intel-vaapi-driver # Intel VAAPI driver (older)
      libnvidia-container # NVIDIA container runtime library
      libvdpau # Video Decode and Presentation API for Unix
      libvdpau-va-gl # VDPAU driver with VA-API backend
      nv-codec-headers # NVIDIA codec headers
      nvidia-container-toolkit # NVIDIA container toolkit
      nvidia-texture-tools # NVIDIA texture processing tools
      nvidia-vaapi-driver # NVIDIA VAAPI driver
      nvidia_cg_toolkit # NVIDIA Cg toolkit
      nvtopPackages.nvidia # NVIDIA GPU monitoring tool
      peakperf # Performance analysis tool
      libva-vdpau-driver # VAAPI to VDPAU translation library
      # GStreamer
      gst_all_1.gst-plugins-ugly # GStreamer plugins for proprietary codecs
      gst_all_1.gst-plugins-bad # GStreamer plugins that are not fully tested
      gst_all_1.gst-plugins-good # GStreamer plugins that are well-tested
      gst_all_1.gst-plugins-rs # GStreamer Rust plugins
      gst_all_1.gst-editing-services # GStreamer editing services
      gst_all_1.gstreamer
      gst_all_1.gst-vaapi # GStreamer VAAPI plugins
      gst_all_1.gst-libav # GStreamer libav plugins
      # Icons
      adwaita-icon-theme # Adwaita icon theme
      hicolor-icon-theme # High contrast icon
      ## FFMPEG
      ffmpeg # FFmpeg multimedia framework
      ## GVFS
      gvfs # GNOME Virtual File system

      # Xorg
      xorg.libICE # X Inter-Client Exchange library
      xorg.libSM # X Session Management library
      xorg.libX11 # X11 client-side library
      xorg.libXScrnSaver # X11 Screen Saver extension
      xorg.libXcomposite # X11 Composite extension
      xorg.libXcursor # X11 Cursor management
      xorg.libXdamage # X11 Damage extension
      xorg.libXext # X11 miscellaneous extensions
      xorg.libXfixes # X11 Fixes extension
      xorg.libXft # X FreeType interface library
      xorg.libXi # X Input extension
      xorg.libXinerama # Xinerama extension for multi-head
      xorg.libXmu # Miscellaneous utility functions
      xorg.libXrandr # X Resize, Rotate and Reflect extension
      xorg.libXrender # X Rendering extension
      xorg.libXt # X Toolkit Intrinsics
      xorg.libXtst # X Testing extension
      xorg.libXxf86vm # XFree86 video mode extension
      xorg.libpciaccess # PCI access library
      xorg.libxcb # X protocol C-language Binding
      xorg.xcbutil # XCB utility library
      xorg.xcbutilimage # XCB image extension
      xorg.xcbutilkeysyms # XCB key symbol utilities
      xorg.xcbutilrenderutil # XCB render utilities
      xorg.xcbutilwm # XCB window manager utilities
      xorg.xkeyboardconfig # X keyboard configuration

      # GTK/GUI
      at-spi2-atk # Assistive Technology Service Provider Interface
      at-spi2-core # AT-SPI core
      atk # Accessibility toolkit
      cairo # 2D graphics library
      desktop-file-utils # Utilities for .desktop files
      fontconfig # Font configuration and customization
      fribidi # Bidirectional text support
      gdk-pixbuf # Image loading for GTK
      glib # Core GNOME library
      gobject-introspection # Introspection for GObject libraries
      gtk2 # GTK+ 2 toolkit
      gtk3 # GTK+ 3 toolkit
      harfbuzz # Text shaping library
      libappindicator-gtk2 # Application indicators for GTK2
      libcaca # Color ASCII art library
      libcanberra # Event sound library
      libcanberra-gtk3 # Event sound for GTK3
      libdbusmenu # DBus menu library
      libdbusmenu-gtk3 # DBus menu for GTK3
      libfm # File management library
      libfm-extra # Extra components for libfm
      libgee # GObject collection library
      libgig # Gigasampler file access library
      libnotify # Desktop notification library
      librsvg # SVG rendering library
      libsForQt5.qt5ct # Qt5 configuration tool
      pango # Text layout and rendering
      pixman # Pixel manipulation library
      sassc # Sass compiler
      speechd # Speech dispatcher
      xsettingsd # XSettings daemon

      # System/Utils
      bash # GNU Bourne Again SHell
      binutils # Binary utilities (linker, assembler, etc.)
      bzip2 # Compression library
      cups # Printing system
      curl # Data transfer library
      curlWithGnuTls # Curl with GNU TLS support
      luajitPackages.lgi #
      luajitPackages.lua # Lua interpreter
      lua51Packages.lua # Lua 5.1 interpreter
      lua51Packages.lgi #
      lua51Packages.luarocks
      luajitPackages.luarocks-nix # Nix integration for luarocks
      luajitPackages.luarocks # LuaRocks package manager
      lua51Packages.luarocks-nix # Nix integration for LuaRocks
      lua51Packages.luarocks # LuaRocks package manager for Lua 5.1
      dbus # Message bus system
      dbus-glib # GLib bindings for DBus
      e2fsprogs # Ext2/3/4 filesystem utilities
      expat # XML parsing library
      freetype # Font rendering library
      fuse # Filesystem in Userspace
      fuse3 # Filesystem in Userspace (v3)
      gmp # GNU Multiple Precision arithmetic library
      gmime3 # MIME message parser
      libgpg-error # GnuPG error handling Library
      icu # International Components for Unicode
      keyutils.lib # Key management utilities
      libcap # POSIX capabilities library
      libgcrypt # Cryptographic library
      libglibutil # GLib utilities
      libgpg-error # GnuPG error library
      libgudev # GObject bindings for libudev
      libidn # Internationalized domain names library
      libimobiledevice # Communicate with iOS devices
      libinput # Input device library
      libisoburn # ISO-9660 image manipulation
      libjack2 # JACK audio connection kit
      libjpeg # JPEG image library
      libpng12 # PNG image library (older version)
      libsecret # Secret storage library
      libthai # Thai language support
      libtiff # TIFF image library
      libtool # Generic library support script
      libudev0-shim # Udev compatibility shim
      libunwind # Stack unwinding library
      libusb1 # USB access library
      libuuid # UUID library
      libxdg_basedir # XDG base directory specification
      libxkbcommon # Keyboard handling library
      libxml2 # XML parsing library
      lld # LLVM linker
      openssl # SSL/TLS cryptography library
      p11-kit # PKCS#11 module management
      pkg-config # Build configuration tool
      sqlite # SQL database engine
      sqlite-analyzer # SQLite database analysis tool
      sqlite-interactive # SQLite interactive shell
      sqlite-utils # SQLite utilities
      sqlitebrowser # SQLite database browser
      stdenv.cc.cc # Standard C compiler
      tbb # Threading Building Blocks
      udev # Device manager for Linux
      util-linux # Essential system utilities
      vulkan-loader # Vulkan loader library
      wayland # Wayland display server protocol
      xz # Compression library
      zlib # Compression library
      zsh # Z shell

      python313Packages.pygobject3
      python313Packages.pyqt6
      python312Packages.pyqt6

      lua51Packages.lua # Lua interpreter
      lua51Packages.luautf8 # UTF-8 support for LuaJIT
      lua51Packages.std-_debug # Debugging utilities for LuaJIT
      lua51Packages.std-normalize # Normalization utilities for LuaJIT
      lua51Packages.stdlib # Standard library for LuaJIT
      lua51Packages.vicious # Widget library for window managers
      libGLX
      # LuaJIT and Lua libraries
      luajit
      luajitPackages.cjson # JSON parsing for LuaJIT
      luajitPackages.cqueues # Networking and event loop for LuaJIT
      luajitPackages.inspect # Object inspection for LuaJIT
      luajitPackages.ldbus # D-Bus bindings for LuaJIT
      luajitPackages.ldoc # Documentation generator for Lua
      luajitPackages.lgi # GObject Introspection for LuaJIT
      luajitPackages.lpeg # Parsing Expression Grammars for LuaJIT
      luajitPackages.lpeg_patterns # Common patterns for LPeg
      luajitPackages.lpeglabel # LPeg with labeled failures
      luajitPackages.lua # Lua interpreter
      luajitPackages.lua-curl # cURL bindings for LuaJIT
      luajitPackages.lua-messagepack # MessagePack serialization for LuaJIT
      luajitPackages.lua-protobuf # Protocol Buffers for LuaJIT
      luajitPackages.lua-subprocess # Subprocess management for LuaJIT
      luajitPackages.luarocks # Lua package manager
      luajitPackages.luarocks-nix # Nix integration for LuaRocks
      luajitPackages.luasocket # Networking support for LuaJIT
      luajitPackages.luasql-sqlite3 # SQLite3 bindings for LuaJIT
      luajitPackages.luautf8 # UTF-8 support for LuaJIT
      luajitPackages.mediator_lua # Mediator pattern for LuaJIT
      luajitPackages.mpack # MessagePack for LuaJIT
      luajitPackages.std-_debug # Debugging utilities for LuaJIT
      luajitPackages.std-normalize # Normalization utilities for LuaJIT
      luajitPackages.stdlib # Standard library for LuaJIT
      luajitPackages.vicious # Widget library for window managers
      luajitPackages.wrapLua # LuaJIT wrapper utilities
    ];
  };
}
