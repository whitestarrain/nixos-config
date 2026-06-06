{ pkgs, ... }:

let
  mpv-delete-file = pkgs.mpvScripts.buildLua {
    pname = "mpv-delete-file";
    version = "62f4bb3";
    src = ./delete-file;
    meta = {
      homepage = "https://github.com/zenyd/mpv-scripts";
    };
  };
in
{
  xdg.configFile = {
    "mpv/mpv.conf" = {
      source = ./mpv.conf;
      force = true;
    };
  };

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      bindings = {
        n = "playlist-next";
        p = "playlist-prev";
        k = "script-message playlistmanager show playlist toggle";
        j = "seek -5";
        l = "seek 5";
      };
      scripts = [
        pkgs.mpvScripts.mpris
        pkgs.mpvScripts.uosc
        pkgs.mpvScripts.thumbfast
        pkgs.mpvScripts.mpv-playlistmanager
        mpv-delete-file
      ];
    };
  };
}
