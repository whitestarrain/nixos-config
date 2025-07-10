{
  stdenv,
  howard-hinnant-date,
  cmake,
  catch2,
  pkg-config,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "libcron";
  version = "v1.3.1";

  # [Nix: what are fixed-output derivations and why use them?](https://bmcgee.ie/posts/2023/02/nix-what-are-fixed-output-derivations-and-why-use-them/)
  # https://discourse.nixos.org/t/puzzling-behavior-of-fetchfromgithub-with-submodules/48911
  # https://nix.dev/manual/nix/2.28/glossary#gloss-fixed-output-derivation
  # If the output path is the same, and the hash is the same, you always get the old result regardless of how the inputs have changed (unless you build with --check)
  # Always zero out hashes whenever you change anything about a FOD.
  src = fetchFromGitHub {
    owner = "PerMalmberg";
    repo = "libcron";
    tag = version;
    fetchSubmodules = false;
    sha256 = "sha256-Z4ZShxGHVE+967BKZ4kS85ATW/WxVe3CtbulGDvHLnw=";
  };

  postPatch = ''
    # submodules
    mkdir -p test/externals/Catch2/single_include/catch2
    cp ${catch2}/include/catch2/catch.hpp test/externals/Catch2/single_include/catch2
    mkdir -p libcron/externals/date
    ln -s ${howard-hinnant-date.dev}/include libcron/externals/date/include
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    howard-hinnant-date
  ];
}
