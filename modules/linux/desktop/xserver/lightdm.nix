{ pkgs, lib, helper, ... }:

{
  services.xserver.displayManager = {
    lightdm = {
      enable = true;
      # greeters.gtk = {
      #   cursorTheme = {
      #     package = pkgs.capitaine-cursors;
      #     name = "capitaine-cursors";
      #     size = 24;
      #   };
      # };
      background = lib.mkForce helper.static.wallpaper;
    };
  };
}
