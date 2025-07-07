{ lib, pkgs, ... }:

rec {
  relativeToRoot = path: lib.path.append ../. path;
  relativeToRootFiles = path: files: builtins.map (f: lib.path.append (relativeToRoot path) f) files;
  scanFilePaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (path: _type: (_type == "regular")) (builtins.readDir path)
      )
    );
  scanNixPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );
  scanNixRelativeRootPath = path: scanNixPaths (relativeToRoot path);
  wrapEnv =
    pkg: bin_path: env:
    let
      env_string = builtins.concatStringsSep " " (
        builtins.map (envName: "--set ${envName} ${builtins.toString (builtins.getAttr envName env)}") (
          builtins.attrNames env
        )
      );
    in
    lib.hiPrio (
      pkgs.runCommand pkg.pname { nativeBuildInputs = with pkgs; [ makeWrapper ]; } ''
        mkdir -p $out/bin
        makeWrapper \
          ${pkg}/${bin_path} \
          $out/${bin_path} \
          ${env_string}
      ''
    );
}
