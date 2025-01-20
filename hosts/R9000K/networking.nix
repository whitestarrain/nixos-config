{ lib, ... }:

{
  imports = (helper.lib.relativeToRootFiles "modules/linux/options" [ "networkd.nix" ]);
  networking.hostName = "R9000K";
  systemd.network.networks.eno1 = {
    matchConfig.Name = "eno1";
    DHCP = "true";
  };
  systemd.network.networks.wlan0 = {
    matchConfig.Name = "wlan0";
    DHCP = "true";
  };
}
