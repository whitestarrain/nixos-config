{
  pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
  },
}:
let
  lib-path = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc
    # pkgs.linuxKernel.packages.linux_6_12.nvidia_x11
    pkgs.linuxPackages.nvidia_x11
  ];
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    # cudatoolkit
    stdenv.cc
  ];
  shellHook = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH":${lib-path}"
  '';
}
