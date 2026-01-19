{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:

{
  # dae
  services.dae = {
    enable = true;
    package = pkgs-unstable.dae;
    configFile = pkgs.replaceVarsWith {
      src = ./conf.dae;
      replacements = {
        PROXY_PORT = config.wsainHostOption.proxy-port;
      };
    };
  };
  # disable dae autostart
  systemd.services.dae.wantedBy = lib.mkForce [ ];
}
