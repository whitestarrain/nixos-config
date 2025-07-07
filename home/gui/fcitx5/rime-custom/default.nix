{
  lib,
  linkFarm,
  writeText,
  ...
}:

linkFarm "rime-custom" [
  {
    name = "share/rime-data/rime_ice.custom.yaml";
    path = ./rime_ice.custom.yaml;
  }
  {
    name = "share/rime-data/custom_rime_ice_dict.dict.yaml";
    path = ./custom_rime_ice_dict.dict.yaml;
  }
  {
    name = "share/rime-data/default.custom.yaml";
    path = ./default.custom.yaml;
  }
]
