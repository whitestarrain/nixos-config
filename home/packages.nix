{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    aria2
    ariang
    uftpd
    megatools

    mupdf
    baobab # disk usage analyzer

    mutt # mail client
    irssi # IRC client,
    # TODO: IRC weed theme

    netease-cloud-music-gtk
    telegram-desktop
    calibre
    newsflash
    # discord
  ]);
}
