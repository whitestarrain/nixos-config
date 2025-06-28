{ pkgs, helper, ... }:
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
