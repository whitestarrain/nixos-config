{ pkgs, lib, flake-inputs, ... }:

{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

  boot.loader.systemd-boot.enable = lib.mkForce false;

  # touchpad
  boot.blacklistedKernelModules = [ "elan_i2c" ];

  # boot.loader.grub = {
  #   # UEFI boot, need to set device to "nodev"
  #   device = "nodev";
  #   efiSupport = true;
  #   useOSProber = true;
  #   # high resolutions may cause input delay
  #   gfxmodeBios = "800x600";
  #   gfxmodeEfi = "800x600";
  # };

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

  # secure boot
  imports = [
    flake-inputs.lanzaboote.nixosModules.lanzaboote
  ];
  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  # secure boot quickstart: https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    # configurationLimit=1;
  };
}
