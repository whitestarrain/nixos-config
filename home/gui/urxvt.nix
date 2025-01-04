{ helper, ... }:

{
  xresources.extraConfig = builtins.readFile helper.static.urxvt-conf;
}
