{ lib, pkgs, ... }:

rec {
  relativeToRoot = path: lib.path.append ../. path;
  relativeToRootFiles = path: files:
    builtins.map
      (f: lib.path.append (relativeToRoot path) f)
      files;
  scanFilePaths = path:
    builtins.map
      (f: (path + "/${f}"))
      (builtins.attrNames
        (lib.attrsets.filterAttrs
          (
            path: _type:
              (_type == "regular")
          )
          (builtins.readDir path)));
  scanNixPaths = path:
    builtins.map
      (f: (path + "/${f}"))
      (builtins.attrNames
        (lib.attrsets.filterAttrs
          (
            path: _type:
              (_type == "directory") # include directories
              || (
                (path != "default.nix") # ignore default.nix
                && (lib.strings.hasSuffix ".nix" path) # include .nix files
              )
          )
          (builtins.readDir path)));
  scanNixRelativeRootPath = path: scanNixPaths (relativeToRoot path);
}

