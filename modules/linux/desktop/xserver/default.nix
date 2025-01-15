{ pkgs, helper, ... }:

{
  imports = (helper.lib.scanNixPaths ./.);
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
    };
  };
}
