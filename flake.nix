{
  description = "wsain's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    flake-registry = {
      url = "github:nixos/flake-registry";
      flake = false;
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
    };
    dotfiles = {
      url = "github:whitestarrain/dotfiles";
      flake = false;
    };
    nur = {
      url = "github:nix-community/NUR";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      nur,
      dotfiles,
      ...
    }@flake-inputs:
    let
      genSpeicalArgs = system: {
        inherit flake-inputs;
        helper = import ./helper {
          inherit (nixpkgs) lib;
          pkgs = nixpkgs.legacyPackages.${system};
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-nur = nur.legacyPackages.${system}.repos;
      };
    in
    {
      nixosConfigurations = {
        nixos-vm = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = genSpeicalArgs system;
          modules = [
            ./hosts/nixos-vm/configuration.nix
          ];
        };
        R9000K = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = genSpeicalArgs system;
          modules = [
            ./hosts/R9000K/configuration.nix
          ];
        };
      };
    };
}
