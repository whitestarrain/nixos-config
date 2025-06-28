{ pkgs, helper, ... }:
pkgs.dwm.overrideAttrs {
  src = helper.static.dwm;
}
