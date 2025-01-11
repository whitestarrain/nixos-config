{ pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./lightdm.nix
    ./dwm.nix
    ./hidpi.nix
    ./picom
  ];
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
    # systemd.defaultUnit to change default target
    xserver = {
      enable = true;
      xkb.layout = "us";
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
    };
  };
}
