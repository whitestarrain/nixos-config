{
  pkgs,
  config,
  helper,
  lib,
  ...
}:
let
  args = {
    inherit
      pkgs
      config
      helper
      lib
      ;
  };
  dwm = import ./dwm.nix args;
  dwmblocks = import ./dwmblocks.nix args;
  dmenu = import ./dmenu.nix args;
  st-set = import ./st-set.nix args;
in
{
  environment.systemPackages = [
    pkgs.alacritty
    pkgs.rxvt-unicode
    dmenu
    dwmblocks
  ] ++ (builtins.attrValues st-set);

  # dwm
  services.xserver.windowManager = {
    dwm = {
      enable = true;
      package = dwm;
    };
    # run dwmblock in session config
    session = lib.singleton {
      name = "dwm";
      start = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        dwmblocks &
        dwm &
        # waitpid must be the dwm's pid
        waitPID=$!
        # update volume after startup
        (for (( i = 0; i < 3; i++ )); do sleep 1 && kill -47 $(pidof dwmblocks); done;) &
      '';
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "st.desktop"
        "xterm.desktop"
      ];
    };
  };
}
