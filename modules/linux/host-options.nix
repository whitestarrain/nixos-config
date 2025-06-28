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
      cpuTemperatureFilePath = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The path of the file that records the CPU temperature
        '';
      };
    };
  };
}
