{ pkgs, helper, flake-inputs, user, ... }:

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

  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  # ranger
  programs.ranger = {
    enable = true;
    extraConfig = ''
      # icon
      default_linemode devicons
    '';
    settings = {
      show_hidden = "true";
    };
    mappings = {
      a = "console touch%space";
      r = "rename_append";
    };
    plugins = [
      {
        name = "ranger_devicons";
        src = builtins.fetchGit {
          url = "https://github.com/alexanderjeurissen/ranger_devicons.git";
          rev = "84db73d0a50a8c6085b3ec63f834c781b603e83e";
        };
      }
    ];
  };
  programs.bash = {
    initExtra = (builtins.readFile "${flake-inputs.dotfiles}/bash/.bashrc.d/ranger.sh") ;
  };

}
