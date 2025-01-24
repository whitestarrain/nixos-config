{ pkgs, ... }:

{
  # clash-meta
  programs.clash-verge = {
    package = pkgs.clash-verge-rev;
    enable = true;
    autoStart = true;
  };
}
