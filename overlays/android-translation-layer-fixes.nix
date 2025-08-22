final: prev: {
  android-translation-layer = prev.android-translation-layer.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or []) ++ [
      ./patches/android-translation-layer-aarch64-relocs.patch
      ./patches/android-translation-layer-elfutils-glibc.patch
      ./patches/android-translation-layer-cmake-glib.patch
    ];
    
    # Additional build fixes
    preConfigure = ''
      ${oldAttrs.preConfigure or ""}
      # Fix missing includes
      export CPPFLAGS="-I${prev.glib.dev}/include/glib-2.0 -I${prev.glib.out}/lib/glib-2.0/include $CPPFLAGS"
      export PKG_CONFIG_PATH="${prev.glib.dev}/lib/pkgconfig:${prev.gthread.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
    '';
    
    buildInputs = (oldAttrs.buildInputs or []) ++ [
      prev.glib
      prev.gthread
      prev.pkg-config
    ];
    
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      prev.cmake
      prev.pkg-config
    ];
  });
}