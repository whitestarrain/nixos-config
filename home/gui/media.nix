{ pkgs, ... }:

# media - control and enjoy audio/video
{
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    sxiv # image viewer

    # video/audio tools
    cava # for visualizing audio
    libva-utils
    vdpauinfo
    vulkan-tools
    glxinfo

    w3m
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
