{ pkgs, lib, flake-inputs, ... }:

let
  # the scripts will cause high cpu usage. TODO: rewrite by perl or python
  drop_dup_command = lib.getExe (pkgs.writeShellApplication {
    name = "bash_drop_dup_command";
    runtimeInputs = with pkgs; [ python3 ];
    text = ''
      if [[ -z "$HOME" ]]; then
        echo "no HOME env"
        exit
      fi
      echo "HOME: $HOME"
      python3 ${flake-inputs.dotfiles}/linux-home/.bin/erase_history_dup \
        -o "$HOME/.bash_history" \
        -d 'git ,erase_history_dup,echo,ls ,cd ,nvim temp,git clone,GIT_COMMITTER_DATE,z ,ps ,cloc ,curl ,wget ,markdown_mv ,0,mv ,which ,ra ,nvim ./,nvim ~/,nvim /proc,ra ,kill ,man ,trans ,$'
    '';
  });
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
    # InstallConfig
    wantedBy = [ "default.target" ];
  };
}
