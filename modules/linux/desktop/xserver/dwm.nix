{
  pkgs,
  config,
  helper,
  lib,
  ...
}:

let
  dwmblocks = (
    pkgs.dwmblocks.overrideAttrs {
      src = helper.static.dwmblocks;
    }
  );
  dmenu = (
    pkgs.dmenu.overrideAttrs (
      finalAttrs: previousAttrs: {
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
      }
    )
  );
  st = (
    pkgs.st.overrideAttrs {
      src = helper.static.st;
    }
  );
  st-float = (
    pkgs.writeShellApplication {
      name = "st-float";
      runtimeInputs = with pkgs; [
        st
      ];
      text = ''
        ${st}/bin/st -c st-float -e "$@"
      '';
    }
  );
in
{
  environment.systemPackages = [
    pkgs.alacritty
    pkgs.rxvt-unicode
    dmenu
    st
    st-float
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
    session = lib.singleton {
      name = "dwm";
      start = ''
        export _JAVA_AWT_WM_NONREPARENTING=1
        ${dwmblocks}/bin/dwmblocks &
        dwm &
        # waitpid must be the dwm's pid
        waitPID=$!
      '';
    };
  };
}
