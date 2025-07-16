{ pkgs, helper, ... }:

{
  environment.systemPackages = [ helper.derivations.subconverter ];
  services.v2raya = {
    enable = true;
  };
  # Waiting time for connecting to the network, v2ray will request subconverter.
  systemd.services.v2raya.serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 10";
  systemd.services.subconverter = {
    enable = true;
    unitConfig = {
      Description = "subconverter service";
      Before = [
        "v2raya.service"
      ];
    };
    serviceConfig = {
      ExecStart = "${helper.derivations.subconverter}/bin/subconverter/subconverter";
      Restart = "on-failure";
      RestartSec = 5;
      Type = "simple";
    };
    # InstallConfig
    wantedBy = [ "multi-user.target" ];
  };
}
