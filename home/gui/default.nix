{ pkgs, lib, sysConfig, ... }:

{
  imports = [
    ./app.nix
    ./urxvt.nix
  ];
  config = lib.mkIf sysConfig.services.xserver.enable {
    xsession = {
      enable = true;
      # windowManager.command = "…";
    };
  };
}
