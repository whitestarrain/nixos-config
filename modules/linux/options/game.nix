{ pkgs, config, flake-inputs, ... }:

{
  imports = [
    flake-inputs.nix-gaming.nixosModules.pipewireLowLatency
    flake-inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  environment.systemPackages = [
    pkgs.lutris
    # need install dxvk to make sure wine can use the GPU
    pkgs.winetricks
    flake-inputs.nix-gaming.packages."${pkgs.system}".wine-ge
  ];

  services.pipewire = {
    lowLatency = {
      # enable this module
      enable = true;
      # defaults (no need to be set unless modified)
      quantum = 64;
      rate = 48000;
    };
  };

  programs.steam.platformOptimizations.enable = true;

  nix.settings = {
    substituters = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  # Full-screen may cause the game to black the screen when switching tag in dwm
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };
}
