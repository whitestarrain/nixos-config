{
  pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
  },
}:
let
  constants = import ../helper/constants.nix {
    inherit pkgs;
  };
  lib-path = constants.cuda-lib-path;
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    stdenv.cc

    cudatoolkit

    libGLU
    libGL

    xorg.libXi
    xorg.libXmu
    freeglut

    xorg.libXext
    xorg.libX11
    xorg.libXv
    xorg.libXrandr

    zlib

    ncurses5
  ];
  shellHook = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH":${lib-path}"
  '';
}
