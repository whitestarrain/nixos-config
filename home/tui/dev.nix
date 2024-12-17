{ pkgs, ... }:

{
  home.packages = (with pkgs;[
    # language server
    clang-tools

    # debug adapter
    lldb_19

    # linter
    shellcheck
    statix

    # formatter
    nixfmt-rfc-style
    shfmt

    # nix related
    nix-output-monitor # it provides the command `nom` works just like `nix` with more details log output
    nix-index # A small utility to index nix store paths
    nix-init # generate nix derivation from url
    nix-melt # A TUI flake.lock viewer
    nix-tree # A TUI to visualize the dependency graph of a nix derivation
    nix-diff # Explain why two Nix derivations differ
    hydra-check # check hydra(nix's build farm) for the build status of a package
  ]);
}
