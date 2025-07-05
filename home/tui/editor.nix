{ pkgs, ... }:

{
  home.packages = ([
    pkgs.neovim
    pkgs.emacs
  ]);

  programs.bash = {
    initExtra = ''
      export EDITOR='nvim -u NONE'
      export MANPAGER="nvim +Man!"
    '';
  };
}
