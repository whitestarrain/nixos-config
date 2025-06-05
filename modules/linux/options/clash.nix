{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.clash-nyanpasu
    (pkgs.makeAutostartItem {
      name = "clash-nyanpasu";
      package = pkgs.clash-nyanpasu;
    })
  ];
}
