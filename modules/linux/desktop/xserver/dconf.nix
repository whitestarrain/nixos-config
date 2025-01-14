{ ... }:

{
  # dconf is pretty much expected to be present on any desktop using GTK apps
  programs = {
    # dconf is a low-level configuration system.
    dconf.enable = true;
  };
}
