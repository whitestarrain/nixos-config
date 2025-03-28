{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    aria2
    ariang
    uftpd
    megatools
    baidupcs-go

    mupdf
    baobab # disk usage analyzer
    rar
    kdePackages.ark # gui archive manager

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
