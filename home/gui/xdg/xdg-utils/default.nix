{ pkgs, helper, ... }:

{
  home.packages = [
    (pkgs.xdg-utils.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ (helper.lib.scanFilePaths ./patches);
    }))
    pkgs.xdg-user-dirs
  ];
}
