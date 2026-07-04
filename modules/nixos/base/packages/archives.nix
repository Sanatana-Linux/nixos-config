{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.base.packages.archives;
in {
  options.modules.base.packages.archives = {
    enable = mkEnableOption "Archive and compression utilities";
    basicFormats = mkEnableOption "Basic archive formats (tar, zip, cpio)";
    modernCompression = mkEnableOption "Modern compression tools (zstd, lz4, xz)";
    parallelTools = mkEnableOption "Parallel compression utilities";
    specializedFormats = mkEnableOption "Specialized formats (7z, rar, jar)";
    integrationLibs = mkEnableOption "Archive integration libraries";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
    # Basic archive formats
      optionals cfg.basicFormats [
        gnutar # GNU tar - standard archive utility
        cpio # Copy-in/copy-out archive format
        zip # PKZIP archive format
        unzip # PKZIP extraction
        minizip-ng # Zip library (ng version)
      ]
      # Modern compression tools
      ++ optionals cfg.modernCompression [
        zstd # Zstandard compression - fast with good ratio
        lz4 # Extremely fast compression
        xz # LZMA/XZ compression - high ratio
        zlib-ng # Modern zlib replacement
      ]
      # Parallel compression utilities
      ++ optionals cfg.parallelTools [
        crabz # Parallel gzip/zstd
        pigz # Parallel gzip
        pixz # Parallel xz with indexing
        plzip # Parallel lzip
        pxz # Parallel xz
      ]
      # Specialized formats
      ++ optionals cfg.specializedFormats [
        _7zz # 7-Zip console version
        p7zip # 7-Zip utilities
        p7zip-rar # 7-Zip with RAR support
        rar # RAR archiver
        lrzip # Long-range ZIP - for large files
        fastjar # Fast Java archive tool
        mozlz4a # Mozilla LZ4 archive tool
      ]
      # Integration libraries
      ++ optionals cfg.integrationLibs [
        libarchive # Multi-format archive library
        archivemount # Mount archives as filesystems
        gnome-autoar # GNOME archive library
        advancecomp # Recompression tools
        ouch # Painless archive extraction
      ];
  };
}
