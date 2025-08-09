{ pkgs, pkgs-unstable, helper, ... }:

{
  home.packages = (with pkgs;[
      # ffmpegthumbnailer
      mediainfo
      exiftool
      viu
  ]);
  programs.nnn = rec {
    enable = true;
    package = (pkgs-unstable.nnn.override {
      withNerdIcons = true;
    }).overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ (helper.lib.scanFilePaths ./patches);
    });
    plugins = {
      src = "${package}/share/plugins";
      mappings = {
        p = "preview-tui";
        s = "preview-tabbed";
        z = "autojump";
        b = "cdpath"; # cd bookmark
        f = "finder"; # find
        n = "fixname"; # fix name
        o = "nuke";
        c = "-!_nnn_copypath*"; # copy current file path
        m = "nmount";
      };
    };
    extraPackages = with pkgs; [
      zoxide
      fzf
      renameutils
      moreutils
      mpv
      sxiv
      zathura
      tabbed
      nsxiv
      vim
      mktemp
      xdotool
      ueberzugpp
      atool # archive command line helper
      jq
      udisks
      # util-linux # lsblk
    ];
  };

  # add -c option to swallow window
  programs.bash = {
    initExtra = (builtins.readFile ./quitcd.sh);
  };
}
