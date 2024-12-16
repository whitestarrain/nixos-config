{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    tmux
    which
    gnutar
    zip
    tree
    rsync
  ];
}
