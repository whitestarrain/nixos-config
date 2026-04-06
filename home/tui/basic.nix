{
  pkgs,
  helper,
  flake-inputs,
  user,
  config,
  ...
}:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.bin"
    "$HOME/.local/bin"
  ];

  # install software for through home.packages
  home.packages = (
    with pkgs;
    [
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

      # translator
      # download dict: http://download.huzheng.org/zh_CN/
      sdcv # StarDict

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
      icdiff # better diff
      delta # better git diff
      figlet # ascii art
      croc # transform file
      syncthing # sync data
    ]
  );

  programs.git = {
    enable = true;
    settings = {
      core = {
        quotepath = "false";
      };
      alias = {
        A = "add -A";
        st = "status";
        tree = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        caa = "commit -a --amend --no-edit";
      };
      user = {
        name = user;
        email = helper.constants.githubEmail;
      };
      safe = {
        directory = [
          "/mnt/*"
          "/media/*"
        ];
      };
    };
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
}
