{ helper, ... }:

{
  xresources.extraConfig = builtins.readFile ./urxvt.conf;
}
