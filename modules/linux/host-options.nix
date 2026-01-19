{
  pkgs,
  config,
  helper,
  lib,
  ...
}:
{
  # custom options will be placed here
  options = {
    wsainHostOption = {
      proxy-port = lib.mkOption {
        type = lib.types.str;
        default = "7890";
        description = ''
          Port of porxy
        '';
      };
      cpuTemperatureDevicePath = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The path of the file that records the CPU temperature
        '';
      };
    };
  };
}
