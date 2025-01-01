{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xorg.xdpyinfo
  ];

  services.xserver.dpi = 123;
}
