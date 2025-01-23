{
  pkgs,
  lib,
  config,
  ...
}:

{
  environment.systemPackages = [
    pkgs.nvtopPackages.full
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    sync.enable = true;

    # neet to enable hybird mode in bios to detect integrated graphics !!!!!!
    amdgpuBusId = "PCI:06:0:0";
    nvidiaBusId = "PCI:01:0:0";
  };

  # boot.kernelParams = [ "video=DP-2:2560x1440@144" ];
  # boot.initrd.kernelModules = [ "amdgpu" ];

  specialisation = {
    nvidia-offload-mode.configuration = {
      system.nixos.tags = [ "nvidia-sync-mode" ];
      hardware.nvidia = {
        powerManagement.enable = lib.mkForce true;
        powerManagement.finegrained = lib.mkForce true;

        prime.sync.enable = lib.mkForce false;
        prime.offload.enable = lib.mkForce true;
        prime.offload.enableOffloadCmd = lib.mkForce true;
      };
    };
  };

}
