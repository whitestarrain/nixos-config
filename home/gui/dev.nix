{ pkgs, helper, ... }:

let
  wireshark = helper.lib.wrapEnv pkgs.wireshark "bin/wireshark" {
    GDK_SCALE = 2;
    QT_SCALE_FACTOR=2;
  };
in
{
  home.packages = [
    wireshark
  ];
}
