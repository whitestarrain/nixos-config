{
  pkgs,
  config,
  helper,
  lib,
  ...
}:
pkgs.dwmblocks.overrideAttrs {
  src = helper.static.dwmblocks;
  preConfigure = lib.optionalString (config.wsainHostOption.cpuTemperatureDevicePath != null) ''
    makeFlagsArray+=(
      CFLAGS='-D CPU_TERMPERATURE_DEVICE_PATH=${config.wsainHostOption.cpuTemperatureDevicePath}'
    )
  '';
}
