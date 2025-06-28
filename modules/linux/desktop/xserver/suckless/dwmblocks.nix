{
  pkgs,
  config,
  helper,
  lib,
  ...
}:
pkgs.dwmblocks.overrideAttrs {
  src = helper.static.dwmblocks;
  preConfigure = lib.optionalString (config.wsainHostOption.cpuTemperatureFilePath != null) ''
    makeFlagsArray+=(
      CFLAGS='-D CPU_TERMPERATURE_FILE_PATH=${config.wsainHostOption.cpuTemperatureFilePath}'
    )
  '';
}
