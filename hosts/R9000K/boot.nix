{ ... }:

{
  boot.loader.grub = {
    # UEFI boot, need to set device to "nodev"
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    # high resolutions maybe cause input delay
    gfxmodeBios = "2560x1600";
    gfxmodeEfi = "2560x1600";
    fontSize = 32;
  };
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # boot animation
  # boot.plymouth = {
  #   enable = true;
  # };
}
