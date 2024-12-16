{ lib, ... }:

{
  networking.hostName = "nixos-vm";
  networking.interfaces.ens33.ipv4.addresses = [
    {
      address = "192.168.179.151";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.179.2";
  networking.nameservers = [ "114.114.114.114" "8.8.8.8" ];
}
