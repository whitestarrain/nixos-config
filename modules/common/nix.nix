{ config, lib, pkgs, flake-inputs, ... }:

let
  flakeTypeInputs = {
    nixpkgs = flake-inputs.nixpkgs.outPath;
    home-manager = flake-inputs.home-manager.outPath;
  };
in
{
  # https://lantian.pub/article/modify-computer/nixos-impermanence.lantian/
  environment.variables = {
    NIX_REMOTE = "daemon";
  };

  # to install nvidia driver, need to enable unfree packages
  nixpkgs.config.allowUnfree = lib.mkForce true;

  nix.settings = rec {
    experimental-features = [ "nix-command" "flakes" ];

    trusted-users = [
      "@wheel"
      "wsain"
    ];

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      # cache mirror located in China
      # status: https://mirrors.ustc.edu.cn/status/
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # status: https://mirror.sjtu.edu.cn/
      # "https://mirror.sjtu.edu.cn/nix-channels/store"

      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-substituters = substituters;
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

      # the default public key of cache.nixos.org, it's built-in, no need to add it here
      # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    builders-use-substitutes = true;

    # prevent flake from downloading registry at every flake command
    flake-registry = "${flake-inputs.flake-registry}/flake-registry.json";
  };

  # disable channel
  # nix.channel.enable = false;

  environment.etc = lib.mapAttrs'
    (
      n: v: lib.nameValuePair "nix/inputs/${n}" { source = lib.mkForce v; }
    )
    flakeTypeInputs;

  nix = {
    nixPath = lib.mkForce [ "/etc/nix/inputs" ];
    registry = lib.mapAttrs (_n: v: { flake = lib.mkForce { outPath = v; }; }) flakeTypeInputs;
  };

  # Disable conflicting settings from nixpkgs
  nixpkgs.flake = {
    setFlakeRegistry = false;
    setNixPath = false;
  };
}
