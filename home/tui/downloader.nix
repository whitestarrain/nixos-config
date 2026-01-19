{
  pkgs,
  lib,
  config,
  sysConfig,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      megatools
      baidupcs-go
    ]
  );

  # firefox has aria2 gui frontend extension
  systemd.user.services.aria2 = {
    Unit = {
      Description = "aria2 local server";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = lib.strings.concatStringsSep " " [
        "${pkgs.aria2}/bin/aria2c"
        "--enable-rpc"
        "--interface=127.0.0.1"
        "--disable-ipv6"
        "--rpc-listen-all=true"
        "--rpc-allow-origin-all"
        "--all-proxy='http://127.0.0.1:${sysConfig.wsainHostOption.proxy-port}'"
      ];
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
