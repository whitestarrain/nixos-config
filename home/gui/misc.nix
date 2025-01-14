{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    mupdf
    flameshot
    clash-meta
  ]);
}
