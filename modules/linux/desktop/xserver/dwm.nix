{ pkgs, helper, lib, ... }:

let
  dwmblocks = (pkgs.dwmblocks.overrideAttrs {
    src = helper.static.dwmblocks;
  });
in
{
  environment.systemPackages = with pkgs; [
    alacritty
    rxvt-unicode
    (dmenu.overrideAttrs (finalAttrs: previousAttrs: {
      src = helper.static.dmenu;
      preConfigure = ''
        makeFlagsArray+=(
          PREFIX="$out"
          CC="$CC"
          # default config.mk hardcodes dependent libraries and include paths
          INCS="`$PKG_CONFIG --cflags fontconfig x11 xft xinerama`"
          LIBS="`$PKG_CONFIG --libs   fontconfig x11 xft xinerama` -lm"
        )
      '';
    }))
    (st.overrideAttrs {
      src = helper.static.st;
    })
    dwmblocks
  ];

  # dwm
  services.xserver.windowManager = {
    dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = helper.static.dwm;
      };
    };
    # run dwmblock in session config
    session = lib.singleton
      {
        name = "dwm";
        start =
          ''
            export _JAVA_AWT_WM_NONREPARENTING=1
            ${dwmblocks}/bin/dwmblocks &
            dwm &
            # waitpid must be the dwm's pid
            waitPID=$!
          '';
      };
  };
}
