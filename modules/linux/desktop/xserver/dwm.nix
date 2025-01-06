{ pkgs, helper, ... }:

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
  ];

  # dwm
  services.xserver.windowManager = {
    dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = helper.static.dwm;
      };
    };
  };
}
