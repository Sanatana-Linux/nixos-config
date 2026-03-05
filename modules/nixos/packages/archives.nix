{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.modules.packages.archives = {
    enable = mkEnableOption "Archive and compression tools";

    basicFormats = mkEnableOption "Basic archive formats (ZIP, TAR, GZIP)" // {default = true;};
    modernCompression = mkEnableOption "Modern compression algorithms (Zstd, LZ4, XZ)" // {default = true;};
    parallelTools = mkEnableOption "Parallel compression and extraction tools" // {default = true;};
    specializedFormats = mkEnableOption "Specialized formats (7z, RAR, JAR)" // {default = false;};
    integrationLibs = mkEnableOption "Archive integration libraries and utilities" // {default = true;};
  };

  config = mkIf config.modules.packages.archives.enable {
    environment.systemPackages = with pkgs;
      []
      # Basic archive formats
      ++ optionals config.modules.packages.archives.basicFormats [
        gnutar # GNU tar archiver
        zip # ZIP archive tool
        cpio # Copy-in, copy-out archive tool
      ]
      # Modern compression algorithms
      ++ optionals config.modules.packages.archives.modernCompression [
        zstd # Zstandard compression utility
        lz4 # Extremely fast compression algorithm
        xz # XZ compression utility
        zlib-ng # Next-generation zlib compression library
      ]
      # Parallel compression tools
      ++ optionals config.modules.packages.archives.parallelTools [
        crabz # Parallel Zstandard compressor/decompressor
        pigz # Parallel implementation of gzip
        pixz # Parallel, indexed XZ compressor
        plzip # Parallel lzip compressor
        pxz # Parallel XZ compressor
      ]
      # Specialized formats
      ++ optionals config.modules.packages.archives.specializedFormats [
        _7zz # 7-Zip command-line utility
        p7zip-rar # 7-Zip with RAR support
        rar # RAR archive tool
        fastjar # Fast Java archive (JAR) tool
        mozlz4a # Mozilla LZ4 archive utility
      ]
      # Integration libraries and smart tools
      ++ optionals config.modules.packages.archives.integrationLibs [
        advancecomp # Advanced compression utilities for ZIP, PNG, MNG, and GZ files
        archivemount # Mount archive files as a filesystem
        dtrx # "Do The Right Extraction" - intelligent archive extractor
        gnome-autoar # GNOME library for automatic archive handling
        libarchive # Multi-format archive and compression library
        ouch # Command-line archive and compression tool
      ];
  };
}
