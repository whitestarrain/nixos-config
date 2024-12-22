{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    # Bash
    dos2unix
    shellcheck
    shfmt

    # C
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

    # Golang
    go

    # LaTeX
    # texlive.combined.scheme-full

    # Lua
    lua

    # NodeJS
    nodejs
    nodePackages.npm

    # Python
    python313

    # Java
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
