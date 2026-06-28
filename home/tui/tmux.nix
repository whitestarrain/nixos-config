{ pkgs, pkgs-unstable, flake-inputs, ... }:

{
  home.packages = (with pkgs;[
    pkgs-unstable.tmux
  ]);
  # home.file.".tmux.conf".source = "${flake-inputs.dotfiles}/tmux/.tmux.conf";
}

