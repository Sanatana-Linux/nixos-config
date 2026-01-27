{pkgs, ...}:
with pkgs; [
  _7zz # 7-Zip command-line utility
  advancecomp # Advanced compression utilities for ZIP, PNG, MNG, and GZ files
  archivemount # Mount archive files as a filesystem
  cpio # Copy-in, copy-out archive tool
  crabz # Parallel Zstandard compressor/decompressor
  dtrx # "Do The Right Extraction" - intelligent archive extractor
  fastjar # Fast Java archive (JAR) tool
  gnome-autoar # GNOME library for automatic archive handling
  gnutar # GNU tar archiver
  libarchive # Multi-format archive and compression library
  lz4 # Extremely fast compression algorithm
  mozlz4a # Mozilla LZ4 archive utility
  ouch # Command-line archive and compression tool
  p7zip-rar # 7-Zip with RAR support
  pigz # Parallel implementation of gzip
  pixz # Parallel, indexed XZ compressor
  plzip # Parallel lzip compressor
  pxz # Parallel XZ compressor
  rar # RAR archive tool
  xz # XZ compression utility
  zip # ZIP archive tool
  zlib-ng # Next-generation zlib compression library
  zstd # Zstandard compression utility
]
