{
  pkgs,
  helper,
  pkgs-nur,
  ...
}:

let
  rime-custom = pkgs.callPackage ./rime-custom { };
  fcitx5-rime-custom =
    (pkgs.fcitx5-rime.override {
      rimeDataPkgs = [
        pkgs.rime-data
        rime-custom
        pkgs-nur.xddxdd.rime-ice
        pkgs-nur.xddxdd.rime-moegirl
        pkgs-nur.xddxdd.rime-zhwiki
      ];
    }).overrideAttrs
      (old: {
        # Prebuild schema data
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.parallel ];
        postInstall =
          (old.postInstall or "")
          + ''
            for F in $out/share/rime-data/*.schema.yaml; do
              echo "rime_deployer --compile "$F" $out/share/rime-data $out/share/rime-data $out/share/rime-data/build" >> parallel.lst
            done
            parallel -j$(nproc) < parallel.lst || true
          '';
      });
in
{
  home.file.".local/share/fcitx5/themes".source = ./themes;

  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };
    "fcitx5/config" = {
      source = ./config;
      force = true;
    };
    "fcitx5/conf/classicui.conf" = {
      source = ./classicui.conf;
      force = true;
    };
  };

  # .custom files(cmake parameter: RIME_DATA_DIR, default /usr/local/share) placed in the global configuration may not be effective
  xdg.dataFile = {
    "fcitx5/rime/default.custom.yaml" = {
      source = ./rime-custom/default.custom.yaml;
      force = true;
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk # gtk support
      fcitx5-rime-custom # rime support

      # lang support
      fcitx5-chinese-addons # pinyin
      fcitx5-mozc # japanese

      fcitx5-configtool
    ];
  };
}
