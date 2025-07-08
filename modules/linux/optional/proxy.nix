{
  pkgs,
  lib,
  config,
  ...
}:

{
  environment.systemPackages = [
    pkgs.v2raya
  ];
  systemd.user.services.v2raya = {
    enable = true;
    unitConfig = {
      Description = "v2rayA service";
      After = [
        "network.target"
        "nss-lookup.target"
        "network-online.target"
        "iptables.service"
        "ip6tables.service"
        "nftables.service"
      ];
      Wants = [ "network.target" ];
    };
    serviceConfig = {
      ExecStartPre="${pkgs.coreutils}/bin/sleep 10";
      ExecStart = "${lib.getExe pkgs.v2raya} --lite --log-disable-timestamp --address 127.0.0.1:2017 --log-file /dev/null";
      Restart = "on-failure";
      RestartSec = 5;
      Type = "simple";
    };
    # InstallConfig
    wantedBy = [ "default.target" ];
  };
}
