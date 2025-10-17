{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
  # touchpad
  boot.blacklistedKernelModules = ["elan_i2c"];

  boot.loader.grub = {
    # UEFI boot, need to set device to "nodev"
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    # high resolutions may cause input delay
    gfxmodeBios = "800x600";
    gfxmodeEfi = "800x600";
  };
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # The Linux ntfs implementation only supports read-only, add NTFS support for write on ntfs.
  # NixOS uses NTFS-3G for NTFS support,
  # Usage: mount -t ntfs-3g /dev/sda1 /mnt/sda1
  boot.supportedFilesystems = [ "ntfs" ];

  # boot animation
  # boot.plymouth = {
  #   enable = true;
  # };
}
