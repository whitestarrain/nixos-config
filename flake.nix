{
  description = "wsain's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    # secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";
      inputs.nixpkgs.follows = "nixpkgs";
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
      pkg-options = {
        config.allowUnfree = true;
        # cudaSupport enable globally may cause some questions (https://github.com/NixOS/nixpkgs/issues/338315)
        # config.cudaSupport = true;
        # config.cudnnSupport = true;
      };
      genSpeicalArgs = system: {
        inherit flake-inputs;
        helper = import ./helper {
          inherit (nixpkgs) lib;
          pkgs = import nixpkgs (
            {
              inherit system;
            }
            // pkg-options
          );
        };
        pkgs-unstable = import nixpkgs-unstable (
          {
            inherit system;
          }
          // pkg-options
        );
        pkgs-nur =
          (import nixpkgs (
            {
              inherit system;
              overlays = [ nur.overlays.default ];
            }
            // pkg-options
          )).nur.repos;
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
