{ pkgs, ... }:

let
  show_clip_image = pkgs.writeShellScriptBin "show_clip_image" ''
    ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -o | ${pkgs.feh}/bin/feh -
  '';
in
{
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer

    # video/audio tools
    libva-utils
    vdpauinfo
    vulkan-tools
    mesa-demos
    cava # for visualizing audio

    # audio
    audacious
    cmus # console music player

    # image
    flameshot # screenshot
    geeqie
    sxiv
    imv
    w3m
    imagemagick
    feh
    show_clip_image

    # video
    vlc
    ffmpeg-full
  ];

  xdg.configFile = {
    "cava/config" = {
      source = ./cava_config;
      force = true;
    };
    "feh/buttons" = {
      source = ./feh_buttons;
      force = true;
    };
    "mpv/mpv.conf" = {
      source = ./mpv.conf;
      force = true;
    };
  };

  home.file.".w3m/keymap" = {
    source = ./keymap.w3m;
    force = true;
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
      ];
    };
  };

  # services = {
  #   playerctld.enable = true;
  # };
}
