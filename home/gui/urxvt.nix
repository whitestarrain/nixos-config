{ pkgs, lib, helper, sysConfig, ... }:

{
  xresources.extraConfig = builtins.readFile helper.static.urxvt-conf;
}
