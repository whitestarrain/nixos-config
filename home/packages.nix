{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    aria2
    ariang
    uftpd
    megatools

    mupdf

    netease-cloud-music-gtk
    telegram-desktop
    calibre
    newsflash
    # discord
  ]);
}
