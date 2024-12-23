{ lib, flake-inputs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellOptions = [
      "complete_fullquote"
    ];
    initExtra = lib.mkOrder 10000 (builtins.concatStringsSep "\n\n" [
      (builtins.readFile "${flake-inputs.dotfiles}/bash/.bashrc.d/base.sh")
      (builtins.readFile "${flake-inputs.dotfiles}/bash/.bashrc.d/history.sh")
    ]);
  };
}

