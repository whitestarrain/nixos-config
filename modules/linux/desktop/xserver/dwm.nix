{ pkgs, helper, ... }:

{
  environment.systemPackages = with pkgs; [
    st
    alacritty
    rxvt-unicode
    (dmenu.override {
      patches = helper.static.dmenu-patches;
    })
  ];

  # dwm
  services.xserver.windowManager = {
    dwm = {
      enable = true;
      package = pkgs.dwm.override {
        patches = helper.static.dwm-patches;
      };
    };
  };
}
