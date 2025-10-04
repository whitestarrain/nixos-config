{ pkgs, helper, ... }:
pkgs.dwm.overrideAttrs (old: {
  src = helper.static.dwm;
  buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.xorg.libXcursor ];
})
