{ pkgs, helper, ... }:

{
  imports = (helper.lib.scanNixPaths ./.);

  environment.systemPackages = with pkgs; [
    xclip
  ];

  services.xserver.enable = true;
}
