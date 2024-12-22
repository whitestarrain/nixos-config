{ pkgs, lib, config, helper, flake-inputs, user, ... }:

with lib;

let
  cfg = config.programs.bash;

  aliasesStr = concatStringsSep "\n"
    (mapAttrsToList (k: v: "alias ${k}=${escapeShellArg v}")
      cfg.shellAliases);

  shoptsStr =
    let switch = v: if hasPrefix "-" v then "-u" else "-s";
    in concatStringsSep "\n"
      (map (v: "shopt ${switch v} ${removePrefix "-" v}") cfg.shellOptions);

  sessionVarsStr = config.lib.shell.exportAll cfg.sessionVariables;

  historyControlStr = concatStringsSep "\n"
    (mapAttrsToList (n: v: "${n}=${v}") ({
      HISTFILESIZE = toString cfg.historyFileSize;
      HISTSIZE = toString cfg.historySize;
    } // optionalAttrs (cfg.historyFile != null) {
      HISTFILE = ''"${cfg.historyFile}"'';
    } // optionalAttrs (cfg.historyControl != [ ]) {
      HISTCONTROL = concatStringsSep ":" cfg.historyControl;
    } // optionalAttrs (cfg.historyIgnore != [ ]) {
      HISTIGNORE = escapeShellArg (concatStringsSep ":" cfg.historyIgnore);
    }));
in

{
  # bash
  programs.bash = {
    enable = true;
  };

  home.file.".bashrc".source = lib.mkForce (pkgs.writeTextFile {
    name = "bashrc";
    text = builtins.concatStringsSep "\n\n" [
      ''
        ${cfg.bashrcExtra}
        # Commands that should be applied only for interactive shells.
        [[ $- == *i* ]] || return
      ''
      (builtins.readFile "${flake-inputs.dotfiles}/bash/.bashrc.d/base.sh")
      ''
        ${shoptsStr}

        ${aliasesStr}

        ${cfg.initExtra}
      ''
      (builtins.readFile "${flake-inputs.dotfiles}/bash/.bashrc.d/history.sh")
    ];
    checkPhase = ''
      ${pkgs.stdenv.shellDryRun} "$target"
    '';
  });
}

