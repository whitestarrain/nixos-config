{
  pkgs,
  lib,
  config,
  helper,
  ...
}:

let
  dnsServers = [
    helper.constants.dnsServers.ipv4
    helper.constants.dnsServers.ipv6
  ];
  check_network_connection = lib.getExe (
    pkgs.writeShellApplication {
      name = "check_network";
      text = ''
        for _ in {1..30}; do
          ping -c1 ${helper.constants.dnsServers.ipv4} &> /dev/null && break;
          ${pkgs.coreutils}/bin/sleep 1;
        done
      '';
    }
  );
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

  # only used as check condition
  systemd.services.networking-conncted = {
    enable = true;
    unitConfig = {
      Description = "check whether connect to network";
      After = [
        "network.target"
      ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = check_network_connection;
    };
    wantedBy = [ "multi-user.target" ];
  };
}
