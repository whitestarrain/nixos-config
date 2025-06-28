{ lib, helper, ... }:

{
  imports = (helper.lib.relativeToRootFiles "modules/linux/optional/networking" [ "networkd.nix" ]);
  networking.hostName = "nixos-vm";
  systemd.network.networks.ens33 = {
    matchConfig.Name = "ens33";
    address = [ "192.168.179.151/24" ];
    gateway = [ "192.168.179.2" ];
  };
}
