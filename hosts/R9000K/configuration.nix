{ config, lib, pkgs, helper, ... }:

{
  imports = (
    [ ./hardware-configuration.nix ./boot.nix ./networking.nix ./nvidia.nix ]
    ++ (helper.lib.scanNixRelativeRootPath "modules/common")
    ++ (helper.lib.scanNixRelativeRootPath "modules/linux/base")
    ++ (helper.lib.scanNixRelativeRootPath "modules/linux/desktop")
    ++ (helper.lib.relativeToRootFiles "modules/linux/options" [
      "bluetooth.nix"
      "clash-verge.nix"
      "game.nix"
      "ignore-lid-close.nix"
      "tlp.nix"
    ])
    ++ [ ./users.nix ]
  );

  services.tlp.settings.RUNTIME_PM_DENYLIST = "03:00.0 04:00.0";

  # The first version of NixOS installed on the machine.
  # And is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # Don't change this option !!!!
  system.stateVersion = "24.05";
}

