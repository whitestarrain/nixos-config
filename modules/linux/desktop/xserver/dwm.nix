{ pkgs, helper, ... }:

{
  environment.systemPackages = with pkgs; [
    dmenu
    st
    alacritty
    rxvt-unicode
  ];
  services.xserver.windowManager = {
    dwm = {
      enable = true;
      package = pkgs.dwm.override {
        patches = helper.static.dwm-patches;
      };
    };
  };
}
