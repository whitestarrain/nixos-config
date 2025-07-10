# nix-build -E 'with import <nixpkgs> {}; callPackage ./subconverter.nix {}'
# nix-shell -E 'with import <nixpkgs> {}; callPackage ./subconverter.nix {}'
{
  pkgs,
  stdenv,
  lib,
  cmake,
  curl,
  fetchgit,
  rapidjson,
  toml11,
  pcre2,
  fetchFromGitHub,
  yaml-cpp,
  pkg-config,
}:
let
  libcron = pkgs.callPackage ./libcron.nix { };
  quickjspp = pkgs.callPackage ./quickjspp.nix { };
  toml11-v4 = toml11.overrideAttrs rec {
    version = "4.2.0";
    src = fetchFromGitHub {
      owner = "ToruNiina";
      repo = "toml11";
      rev = "v${version}";
      hash = "sha256-NUuEgTpq86rDcsQnpG0IsSmgLT0cXhd1y32gT57QPAw=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "subconverter";
  version = "8e042ae6f1ee2bb2099e1da5dd53172778cafffd";

  src = fetchFromGitHub {
    owner = "tindy2013";
    repo = "subconverter";
    rev = version;
    sha256 = "sha256-1Nchp6ozksn0pJUckhWpKEwh9tHECxllXLkAItCyDHs=";
  };

  dontFixCmake = true;

  postPatch = ''
    sed -i \
      -e 's/szTemp\[1024\]/szTemp\[10240\]/g' \
      -e 's/filename\[256\]/filename\[2560\]/g' src/main.cpp
  '';

  # nixpkgs/pkgs/by-name/cm/cmake/setup-hook.sh
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    curl
    rapidjson
    toml11-v4
    pcre2
    yaml-cpp
    libcron
    quickjspp
  ];
}
