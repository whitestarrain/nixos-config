{
  description = "wsain's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@flake-inputs:
    let
      helper = {
        constants = import ./helper/constants.nix;
        lib = import ./helper/lib.nix { inherit (nixpkgs) lib; };
      };
      genSpeicalArgs = system: {
        inherit helper;
        inherit flake-inputs;
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
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
      };
    };
}
