{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    neofetch
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
  ]);
}
