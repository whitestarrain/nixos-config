{ pkgs, lib, ... }:
let
  drvList = builtins.map (f: pkgs.callPackage (./. + "/${f}") { }) (
    builtins.attrNames (
      lib.attrsets.filterAttrs (
        path: _type:
        (_type == "directory") # include directories
        || (
          (path != "default.nix") # ignore default.nix
          && (lib.strings.hasSuffix ".nix" path) # include .nix files
        )
      ) (builtins.readDir ./.)
    )
  );
  drvAttrs = builtins.listToAttrs (
    builtins.map (drv: {
      name = drv.pname;
      value = drv;
    }) drvList
  );
in
drvAttrs
