{ pkgs, helper, ... }:

{
  environment.systemPackages = [ helper.derivations.subconverter ];
  services.v2raya = {
    enable = true;
  };
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
