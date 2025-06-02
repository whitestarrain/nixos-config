{ pkgs, ... }:

{
  home.packages = [
    (pkgs.xdg-utils.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./patches/xdg-mime.patch ];
    }))
    pkgs.xdg-user-dirs
  ];
}
