{ pkgs, helper, ... }:

let
  show_clip_image = pkgs.writeShellScriptBin "show_clip_image" ''
    ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -o | ${pkgs.feh}/bin/feh -
  '';
in
{
  imports = (helper.lib.scanNixPaths ./.);

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
  };

  home.file.".w3m/keymap" = {
    source = ./keymap.w3m;
    force = true;
  };

  # services = {
  #   playerctld.enable = true;
  # };
}
