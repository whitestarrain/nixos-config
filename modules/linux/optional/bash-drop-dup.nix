{
  pkgs,
  lib,
  flake-inputs,
  ...
}:

let
  # nix-shell --pure will truncate ~/.bash_history to 1000 line
  history_file_path = "$HOME/.bash_histfile";
  useless_command_prefix = builtins.concatStringsSep "," [
    "$"
    "./"
    "/"
    "0"
    "cat "
    "cd "
    "chmod "
    "cloc "
    "curl "
    "df "
    "du "
    "echo "
    "erase_history_dup"
    "git "
    "history "
    "kill "
    "less "
    "ls "
    "man "
    "markdown_mv "
    "mv "
    "n "
    "nix shell "
    "nix-shell "
    "nnn"
    "nvim ./"
    "nvim /proc"
    "nvim temp"
    "nvim ~/"
    "ping "
    "ps "
    "pstree "
    "ra "
    "ra "
    "trans "
    "wget "
    "which "
    "y "
    "yazi"
    "z "
  ];
  wrap_command_prefix = builtins.concatStringsSep "," [
    "pc "
    "proxychains4 "
    "sp "
    "sudo "
    "switchproxy "
  ];
  drop_dup_command = lib.getExe (
    pkgs.writeShellApplication {
      name = "bash_drop_dup_command";
      runtimeInputs = with pkgs; [ python3 ];
      text = ''
        if [[ -z "$HOME" ]]; then
          echo "no HOME env"
          exit
        fi
        python3 ${flake-inputs.dotfiles}/linux-home/.bin/erase_history_dup \
          -o "${history_file_path}" \
          -d "${useless_command_prefix}" \
          -w "${wrap_command_prefix}"
      '';
    }
  );
in
{
  systemd.user.services.bash-drop-dup = {
    enable = true;
    unitConfig = {
      Description = "Drop duplicate bash history command";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = drop_dup_command;
    };
    # auto start
    wantedBy = [ "default.target" ];
    environment = {
      HISTFILE = history_file_path;
    };
  };
  environment.variables = {
    # nix-shell --pure will truncate ~/.bash_history. to 1000 line
    HISTFILE = history_file_path;
  };
}
