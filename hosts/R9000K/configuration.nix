{ config, lib, pkgs, helper, ... }:

{
  imports = (
    [ ./hardware-configuration.nix ./boot.nix ./networking.nix ./nvidia.nix ]
    ++ (helper.lib.scanNixRelativeRootPath "modules/common")
    ++ (helper.lib.scanNixRelativeRootPath "modules/linux/base")
    ++ (helper.lib.scanNixRelativeRootPath "modules/linux/desktop")
    ++ (helper.lib.relativeToRootFiles "modules/linux/options" [
      "bash-drop-dup.nix"
      "bluetooth.nix"
      "clash-verge.nix"
      "game.nix"
      "ignore-lid-close.nix"
      "tlp.nix"
      "virtualisation.nix"
    ])
    ++ [ ./users.nix ]
  );

  services.tlp.settings.RUNTIME_PM_DENYLIST = "03:00.0 04:00.0";

  # fix crackling at high volume
  # https://forum.manjaro.org/t/howto-troubleshoot-crackling-in-pipewire/82442
  services.pipewire.extraConfig.pipewire."92-fix-pop" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.allowed-rates" = [44100 48000];
    };
  };

  virtualisation.docker.storageDriver = "btrfs";

  # The first version of NixOS installed on the machine.
  # And is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # Don't change this option !!!!
  system.stateVersion = "24.05";
}

