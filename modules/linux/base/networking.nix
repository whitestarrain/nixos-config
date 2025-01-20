{ pkgs, lib, config, ... }:

let
  dnsServers = [
    "8.8.8.8"
    "2001:4860:4860::8888"
  ];
in
{
  # networking tools
  networking.iproute2.enable = true;

  networking = {
    hostId = lib.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);
    domain = "wsain.pub";
    firewall.enable = false;
    firewall.checkReversePath = false;
    nat.enable = false;
    resolvconf.dnsExtensionMechanism = true;
    resolvconf.dnsSingleRequest = true;
    search = [ "wsain.pub" ];
    tempAddresses = "disabled";
    nameservers = dnsServers;
  };
}
