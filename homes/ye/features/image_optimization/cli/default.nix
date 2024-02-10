{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    image_optim
    # uses
    advancecomp
    gifsicle
    jhead
    jpegoptim
    jpeg-archive
    libjpeg
    optipng
    oxipng
    pngcrush
    pngquant
    nodePackages_latest.svgo

    imageworsener
    pngloss
    flaca
    trimage

    libjxl
    imlib2Full
    libimagequant

    imagemagickBig
    graphicsmagick
    epeg
    freeimage
    jhead
    mjpegtoolsFull
    vips
    qoi
  ];
}
