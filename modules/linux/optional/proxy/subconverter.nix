{ helper, ... }:

{
  # subconverter
  environment.systemPackages = [ helper.derivations.subconverter ];
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
    # auto start
    wantedBy = [ "multi-user.target" ];
  };
}
