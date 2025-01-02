{ pkgs, lib, helper, sysConfig, ... }:

{
  config = lib.mkIf sysConfig.services.xserver.enable {
    xsession = {
      # when enable, home-manager will create an ~/.xprofile file, and source hm-session-vars.hs
      enable = true;
      # windowManager.command = "…";
    };
    xresources.extraConfig = builtins.readFile helper.static.xresources-conf;
  };
}
