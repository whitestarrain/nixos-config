{ lib, helper, ... }:

{
  imports = (helper.lib.relativeToRootFiles "modules/linux/options" [ "networkd.nix" "wireless.nix" ]);
  networking.hostName = "R9000K";
  systemd.network.networks.eno1 = {
    matchConfig.Name = "eno1";
    networkConfig.DHCP = "ipv4";
  };
  systemd.network.networks.wlan0 = {
    matchConfig.Name = "wlan0";
    networkConfig.DHCP = "ipv4";
  };
}
