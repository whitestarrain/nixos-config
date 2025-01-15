{ pkgs, ... }:

{
  imports = [
    ./dconf.nix
    ./fonts.nix
    ./lightdm.nix
    ./dwm.nix
    ./hidpi.nix
    ./picom
    ./file-explorer.nix
    ./clipboard.nix
  ];
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
    };
  };
}
