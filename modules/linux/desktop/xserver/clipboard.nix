{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xclip
  ];
  services.clipmenu.enable = true;
}
