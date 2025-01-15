{ pkgs, lib, helper, ... }:

{
  services.xserver.displayManager = {
    lightdm = {
      enable = true;
      background = lib.mkForce helper.static.wallpaper;
    };
  };
}
