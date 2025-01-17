{ pkgs, helper, ... }:

{
  imports = (helper.lib.scanNixPaths ./.);
  services.xserver.enable = true;
}
