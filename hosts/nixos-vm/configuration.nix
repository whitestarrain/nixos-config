{ config, lib, pkgs, helper, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./networking.nix
    ./users.nix
  ]
  ++ (helper.lib.scanNixRelativeRootPath "modules/common")
  ++ (helper.lib.scanNixRelativeRootPath "modules/linux/base")
  ++ [
    (helper.lib.relativeToRoot "modules/linux/desktop/xserver")
    (helper.lib.relativeToRoot "modules/linux/desktop/pipewire.nix")
  ]
  ;

  # The first version of NixOS installed on the machine.
  # And is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # Don't change this option !!!!
  system.stateVersion = "24.05";
}

