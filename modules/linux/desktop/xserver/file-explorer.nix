{ pkgs, ... }:

{
  services = {
    tumbler.enable = true; # Thumbnail support for images
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
