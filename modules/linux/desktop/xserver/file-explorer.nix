{ pkgs, ... }:

{
  services = {
    tumbler.enable = true; # Thumbnail support for images
    gvfs.enable = true; # Mount, trash, and other functionalities
  };

  programs = {
    # thunar file manager(part of xfce) related options
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}
