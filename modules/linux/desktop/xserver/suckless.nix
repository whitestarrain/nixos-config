{ pkgs
, config
, helper
, lib
, ...
}:

let
  dwm = pkgs.dwm.overrideAttrs {
    src = helper.static.dwm;
  };
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
  st-desktop-item = pkgs.makeDesktopItem {
    name = "st";
    desktopName = "st";
    exec = "st";
    terminal = false;
    type = "Application";
    categories = [ "System" "TerminalEmulator" ];
    comment = "st";
  };
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
    st-desktop-item
    st-float
    dwmblocks
  ];

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
        ${dwmblocks}/bin/dwmblocks &
        dwm &
        # waitpid must be the dwm's pid
        waitPID=$!
        # update volume after startup
        (sleep 1 && kill -47 $(pidof dwmblocks)) &
      '';
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "st.desktop" "xterm.desktop" ];
    };
  };
}
