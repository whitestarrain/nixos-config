{ lib, pkgs, ... }:

{
  # ranger_devicons = builtins.fetchGit {
  #   url = "https://github.com/alexanderjeurissen/ranger_devicons.git";
  #   rev = "84db73d0a50a8c6085b3ec63f834c781b603e83e";
  # };
  ranger_devicons = ./static/ranger_devicons;
}

