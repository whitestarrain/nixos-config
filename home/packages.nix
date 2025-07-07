{
  pkgs,
  lib,
  helper,
  ...
}:

let
  netease-cloud-music-gtk-wrapped =
    helper.lib.wrapEnv pkgs.netease-cloud-music-gtk "bin/netease-cloud-music-gtk4"
      {
        GDK_SCALE = 2;
      };
  ark-wrapped = helper.lib.wrapEnv pkgs.kdePackages.ark "bin/ark" {
    QT_SCALE_FACTOR = 1.5;
  };
in
{
  home.packages = (
    with pkgs;
    [
      aria2
      ariang
      uftpd
      megatools
      baidupcs-go

      mupdf
      zathura
      baobab # disk usage analyzer
      rar
      ark-wrapped # gui archive manager

      mutt # mail client
      irssi # IRC client,
      # TODO: IRC weed theme

      netease-cloud-music-gtk-wrapped
      telegram-desktop
      calibre
      newsflash
      # discord
      gpick
    ]
  );
}
