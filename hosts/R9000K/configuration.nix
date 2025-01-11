{ config, lib, pkgs, helper, ... }:

{
  imports = (
    [ ./hardware-configuration.nix ./boot.nix ./networking.nix ]
    ++ (helper.lib.scanNixRelativeRootPath "modules/common")
    ++ (helper.lib.scanNixRelativeRootPath "modules/linux/base")
    ++ (helper.lib.relativeToRootFiles "modules/linux/desktop" [
      "xserver"
      "pipewire.nix"
      "tlp.nix"
      "libinput.nix"
    ])
    ++ [ ./users.nix ]
  );

  # The first version of NixOS installed on the machine.
  # And is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # Don't change this option !!!!
  system.stateVersion = "24.05";
}

