{ pkgs, config, ... }:

{
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };
}
