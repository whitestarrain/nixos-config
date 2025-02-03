{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    mupdf
    flameshot
    netease-cloud-music-gtk
    telegram-desktop
    aria2
    ariang
    uftpd
  ]);
}
