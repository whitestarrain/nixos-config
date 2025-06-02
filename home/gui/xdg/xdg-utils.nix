{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # todo: use `file -bL --mime-type -- "${FPATH}"` to get mime-type rather than `xdg-mime query`
    xdg-utils
    xdg-user-dirs
  ];
}
