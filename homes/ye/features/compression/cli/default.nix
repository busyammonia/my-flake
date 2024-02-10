{ pkgs, config, ... }: {
    home.packages = with pkgs; [
    gnutar
    libarchive
    binutils
    cpio
    dar
    bzip2
    lbzip2 # Parallel version of bzip2
    pbzip2 # Parallel version of bzip2
    bzip3
    gzip
    pigz # Parallel version of gzip
    htslib # Contains parallel version of gzip, bgzip
    crabz # Parallel version of gzip
    rapidgzip # Parallel version of gzip
    zip
    unzipNLS
    lrzip
    lz4
    lzip
    plzip # Parallel version of lzip
    lzop
    xz
    pixz
    pxz
    zstd
    p7zip
    rar
    tarlz
    unar
    zpaq
    zpaqd
    zpaqfranz
    lhasa
    archiver
    arj
    ncompress
    par2cmdline
    sharutils
    brotli
    libzip
    zlib-ng
    zopfli
    zarchive
  ];
}