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
    extraPackages = with pkgs; [
      libGL
    ];
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

  # Optimus://wiki.archlinux.org/title/NVIDIA_Optimus
  # prime: https://wiki.archlinux.org/title/PRIME
  hardware.nvidia.prime = {
    sync.enable = true;

    # neet to enable hybird mode in bios to detect integrated graphics !!!!!!
    amdgpuBusId = "PCI:06:0:0";
    nvidiaBusId = "PCI:01:0:0";
  };

  services.xserver.displayManager.setupCommands = lib.mkAfter ''
    IN_eDP=$(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gnugrep}/bin/grep "eDP" | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.gnused}/bin/sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
    ALL_DP=$(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gnugrep}/bin/grep -v "eDP" | ${pkgs.gnugrep}/bin/grep "DP" | ${pkgs.gnugrep}/bin/grep " connected" | ${pkgs.gnused}/bin/sed -e "s/\([A-Z1-9]\+\) connected.*/\1/")
    DP_NUM=$(${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gnugrep}/bin/grep -v "eDP" | ${pkgs.gnugrep}/bin/grep "DP" | ${pkgs.gnugrep}/bin/grep " connected" | wc -l)
    if [[ -z "$IN_eDP" ]]; then
      if [[ $DP_NUM -lt 2 ]]; then
        ${pkgs.xorg.xrandr}/bin/xrandr --output $ALL_DP --rate 165.02 --mode 2560x1600
      else
        # todo
        echo ""
      fi
    else
      # igpu and dgpu (Optimus mode)
      if (${pkgs.xorg.xrandr}/bin/xrandr | ${pkgs.gnugrep}/bin/grep "$ALL_DP disconnected"); then
        ${pkgs.xorg.xrandr}/bin/xrandr --output $IN_eDP --rate 165.02 --mode 2560x1600
      else
        ${pkgs.xorg.xrandr}/bin/xrandr --output $IN_eDP --off --output $ALL_DP --rate 144 --mode 2560x1440 --scale 1.2x1.2
      fi
    fi
  '';

  # boot.kernelParams = [
  #   "video=DP-2:2560x1440@144" # default 60 fps, kernel params can't work
  #   "video=eDP:d"
  #   "video=eDP-1:d"
  #   "video=eDP-2:d"
  # ];
  # boot.initrd.kernelModules = [ "amdgpu" ];

  specialisation = {
    nvidia-offload-mode.configuration = {
      system.nixos.tags = [ "nvidia-offload-mode" ];
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
