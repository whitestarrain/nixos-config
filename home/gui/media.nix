{ pkgs, ... }:

# media - control and enjoy audio/video
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
    glxinfo
    cava # for visualizing audio

    # audio
    audacious

    # image
    geeqie
    sxiv
    imv
    w3m

    # video
    vlc
    ffmpeg-full
  ];

  # https://github.com/catppuccin/cava
  xdg.configFile."cava/config".text = ''
    # custom config
  '';

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      scripts = [ pkgs.mpvScripts.mpris ];
    };
  };

  # services = {
  #   playerctld.enable = true;
  # };
}
