{ pkgs, lib, flake-inputs, ... }:

let
  drop_dup_command = lib.getExe (pkgs.writeShellApplication {
    name = "bash_drop_dup_command";
    runtimeInputs = with pkgs; [ python3 ];
    text = ''
      if [[ -z "$HOME" ]]; then
        echo "no HOME env"
        exit
      fi
      python3 ${flake-inputs.dotfiles}/linux-home/.bin/erase_history_dup \
        -o "$HOME/.bash_history" \
        -d 'git ,erase_history_dup,echo ,ls ,cd ,cat ,df ,du ,less ,nix shell ,nix-shell ,nvim temp,git clone,GIT_COMMITTER_DATE,z ,ps ,pstree ,cloc ,curl ,wget ,markdown_mv ,0,mv ,which ,ra ,nvim ./,nvim ~/,nvim /proc,ra ,kill ,man ,trans ,$,nnn,n ,yazi,y ,./,ping ,history ,chmod ' \
        -w 'sudo ,pc ,proxychains4 ,sp ,switchproxy '
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
    # auto start
    wantedBy = [ "default.target" ];
  };
}
