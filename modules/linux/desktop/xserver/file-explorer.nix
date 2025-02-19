{ pkgs, ... }:

let
  # When firefox opens a folder, thunar.service will be automatically started,
  # but thunar can't correctly use mime types to open files.
  package = (pkgs.xfce.thunar.override {
    thunarPlugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  }).overrideAttrs (old: {
    # Derivation of thunar with plugins is defined by pkgs.symlinkJoin,
    # use buildCommand to override.
    buildCommand =
      (old.buildCommand or "")
      + ''
        rm -rf $out/share/systemd/user
        rm -rf $out/lib/systemd/user
      '';
  });
in
{
  services = {
    tumbler.enable = true; # Thumbnail support for images
    gvfs.enable = true; # Mount, trash, and other functionalities
  };
  programs.xfconf.enable = true;
  environment.systemPackages = [
    package
  ];
}
