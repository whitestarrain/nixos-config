{ lib, pkgs, ... }:

{
  lib = import ./lib.nix { inherit lib pkgs; };
  constants = import ./constants.nix { inherit lib pkgs; };
  static = import ./static { inherit lib pkgs; };
  derivations = import ./derivations { inherit lib pkgs; };
}
