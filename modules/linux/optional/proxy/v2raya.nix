{ ... }:

{
  # v2raya
  services.v2raya = {
    enable = true;
  };
  # Waiting time for connecting to the network, v2ray will request subconverter.
  systemd.services.v2raya.unitConfig.After = [ "networking-conncted.service" ];
}
