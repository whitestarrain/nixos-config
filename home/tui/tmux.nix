{ pkgs, flake-inputs, ... }:

{
  home.packages = (with pkgs;[
    tmux
  ]);
  # home.file.".tmux.conf".source = "${flake-inputs.dotfiles}/tmux/.tmux.conf";
}

