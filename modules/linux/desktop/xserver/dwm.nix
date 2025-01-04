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

  # debug dwm:
    # Xephyr -br -ac -noreset -screen 800x600 :1
    # DISPLAY=:1 dwm

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
