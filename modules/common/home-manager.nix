{ config, lib, pkgs, specialArgs, ... }:

{
  imports = [
    specialArgs.flake-inputs.home-manager.nixosModules.home-manager
  ];

  # use global `pkgs` ranther than evaluate an extra nixpkgs
  home-manager.useGlobalPkgs = true;
  # install packages to `/etc/profiles` rather than `~/.nix-profile`
  home-manager.useUserPackages = true;

  # extra args
  home-manager.extraSpecialArgs = specialArgs;
}
