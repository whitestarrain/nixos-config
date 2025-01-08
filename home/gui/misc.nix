{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    mupdf
    flameshot
    clash-meta
    mpv
    sxiv
    w3m
  ]);
}
