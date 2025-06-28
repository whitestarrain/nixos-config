{ lib, helper, ... }:

{
  imports = (
    helper.lib.relativeToRootFiles "modules/linux/optional/networking" [
      "networkd.nix"
      "wireless.nix"
      "network-boot-options.nix"
    ]
  );
  networking.hostName = "R9000K";
  systemd.network.networks.eno1 = {
    matchConfig.Name = "eno1";
    networkConfig.DHCP = "ipv4";
    dhcpV4Config = {
      # default 1024
      RouteMetric = 512;
    };
  };
  # `sudo rfkill unblock all` to unlock wlan0
  systemd.network.networks.wlan0 = {
    matchConfig.Name = "wlan0";
    networkConfig.DHCP = "ipv4";
  };
}
