{ lib, pkgs, ... }:

{
  constants = import ./constants.nix { inherit lib pkgs; };
  lib = import ./lib.nix { inherit lib pkgs; };
  sources = import ./sources.nix { inherit lib pkgs; };
}

