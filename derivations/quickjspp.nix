{
  stdenv,
  gcc,
  cmake,
  pkg-config,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "quickjspp";
  version = "0c00c48895919fc02da3f191a2da06addeb07f09";

  # stdenv default disable LTO
  # nixpkgs/pkgs/stdenv/linux/default.nix
  postPatch = ''
    sed -i -e 's/set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)/set(CMAKE_INTERPROCEDURAL_OPTIMIZATION FALSE)/g' CMakeLists.txt
  '';

  src = fetchFromGitHub {
    owner = "ftk";
    repo = "quickjspp";
    rev = version;
    fetchSubmodules = false;
    sha256 = "sha256-YdDSs5KkjnX2tjI4wDsEqDSPYahKSocnxtnBgiv6xcA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
}
