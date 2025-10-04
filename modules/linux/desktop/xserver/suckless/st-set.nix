{ pkgs, helper, ... }:
let
  st = (
    (pkgs.st.override { extraLibs = [ pkgs.xorg.libXcursor ]; }).overrideAttrs {
      src = helper.static.st;
    }
  );
in
{
  inherit st;
  st-desktop-item = pkgs.makeDesktopItem {
    name = "st";
    desktopName = "st";
    exec = "st";
    terminal = false;
    type = "Application";
    categories = [
      "System"
      "TerminalEmulator"
    ];
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
}
