{ lib, pkgs, ... }:

let
  helperLib = import ./lib.nix { inherit lib pkgs; };
in
{
  constants = import ./constants.nix { inherit lib pkgs; };
  lib = helperLib;
  static = import ./static { inherit lib pkgs helperLib; };
}

