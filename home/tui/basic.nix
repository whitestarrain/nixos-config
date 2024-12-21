{ pkgs, lib, config, helper, flake-inputs, user, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # install software for through home.packages
  home.packages = (with pkgs;[
    # archives
    zip
    xz
    unzip
    p7zip
    gnutar
    # terminal file manager
    ranger
    # quick cd
    zoxide
    # search, find
    ripgrep
    fd
    fzf
    # file parse
    jq
    yq-go
    # others
    git
    starship
    stow
    bat # better cat
    tldr # cheatsheet
    just
  ]);

  programs.git = {
    enable = true;
    userName = user;
    userEmail = helper.constants.githubEmail;
  };

  # starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = false;
    };
  };

  # zoxide
  programs.zoxide = {
    enable = true;
  };

  # bash
  programs.bash = {
    enable = true;
  };

  home.file.".bashrc".source = lib.mkForce (pkgs.writeTextFile {
    name = "bashrc";
    text = builtins.concatStringsSep "\n\n" [
      ''
        ${config.programs.bash.bashrcExtra}
        # Commands that should be applied only for interactive shells.
        [[ $- == *i* ]] || return
      ''
      (builtins.readFile "${flake-inputs.dotfiles}/bash/.bashrc.d/base.sh")
      (builtins.readFile "${flake-inputs.dotfiles}/bash/.bashrc.d/history.sh")
      ''
        ${config.programs.bash.initExtra}
      ''
    ];
    checkPhase = ''
      ${pkgs.stdenv.shellDryRun} "$target"
    '';
  });

}
