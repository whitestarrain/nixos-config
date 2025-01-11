{ lib, ... }:

{
  networking.hostName = "R9000K";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "114.114.114.114" "8.8.8.8" ];
}
