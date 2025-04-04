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
    cmus # console music player

    # image
    flameshot # screenshot
    geeqie
    sxiv
    imv
    w3m
    imagemagick

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
      config = {
        # enable hardware acceleration
        hwdec = "auto";
      };
    };
  };

  # services = {
  #   playerctld.enable = true;
  # };
}
