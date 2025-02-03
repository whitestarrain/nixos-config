{ pkgs, helper, flake-inputs, user, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.bin"
    "$HOME/.local/bin"
  ];

  # install software for through home.packages
  home.packages = (with pkgs;[
    # archives
    zip
    xz
    unzip
    p7zip
    gnutar
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
    bc
    cloc
    scc # replace cloc
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

  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.translate-shell = {
    enable = true;
    settings = {
      tl = [ "zh" ];
      proxy = "127.0.0.1:7890";
    };
  };
}
