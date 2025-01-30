{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    mupdf
    flameshot
    netease-cloud-music-gtk
    ffmpeg-full
  ]);
}
