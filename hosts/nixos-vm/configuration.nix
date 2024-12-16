{ config, lib, pkgs, helper, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./users.nix
  ]
  ++ (helper.lib.scanRelativeRootPath "modules/common")
  ++ (helper.lib.scanRelativeRootPath "modules/linux/base")
  ;

  # The first version of NixOS installed on the machine.
  # And is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # Don't change this option !!!!
  system.stateVersion = "24.05";
}

