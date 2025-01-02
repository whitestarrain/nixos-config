{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    # bash
    dos2unix
    shellcheck
    shfmt

    # c
    autoconf
    automake
    binutils
    bison
    clang-analyzer
    clang-tools
    cmake
    cppcheck
    fakeroot
    file
    findutils
    flex
    gawk
    gcc
    gdb
    gettext
    gnumake
    groff
    libtool
    lldb
    m4
    patch
    pkgconf
    texinfo
    which

    # golang
    go

    # latex
    # texlive.combined.scheme-full

    # lua
    lua

    # nodejs
    nodejs
    nodePackages.npm

    # python
    python313

    # java
    jdk17

    # nix related
    nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output
    nix-index # A small utility to index nix store paths
    nix-init # generate nix derivation from url
    nix-melt # A TUI flake.lock viewer
    nix-tree # A TUI to visualize the dependency graph of a nix derivation
    nix-diff # Explain why two Nix derivations differ
    hydra-check # check hydra(nix's build farm) for the build status of a package
    nixfmt-rfc-style
  ]);

  programs.go = {
    enable = true;
    goBin = ".local/bin";
    goPath = ".local/share/go";
  };
}
