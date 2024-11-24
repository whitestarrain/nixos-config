{
  description = "wsain's NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
    unstable = import nixpkgs-unstable {inherit system;};
  in
    {
      nixosConfigurations.wsainNixos  = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.wsain = import ./wsain-home.nix;
            home-manager.extraSpecialArgs = {nixpkgs-unstable = (import nixpkgs-unstable {inherit system;});};
          }
        ];
      };
    };
}
