{ pkgs, ... }:

{
  # boot.kernelModules = ["vfio-pci"];

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        # enables pulling using containerd, which supports restarting from a partial pull
        # https://docs.docker.com/storage/containerd/
        # "features" = {"containerd-snapshotter" = true;};
      };
      enableOnBoot = false;
    };
  };

  environment.systemPackages = with pkgs; [
    # QEMU/KVM(HostCpuOnly), provides:
    #   qemu-storage-daemon qemu-edid qemu-ga
    #   qemu-pr-helper qemu-nbd elf2dmp qemu-img qemu-io
    #   qemu-kvm qemu-system-x86_64 qemu-system-aarch64 qemu-system-i386
    qemu_kvm

    # Install QEMU(other architectures), provides:
    #   ......
    #   qemu-loongarch64 qemu-system-loongarch64
    #   qemu-riscv64 qemu-system-riscv64 qemu-riscv32  qemu-system-riscv32
    #   qemu-system-arm qemu-arm qemu-armeb qemu-system-aarch64 qemu-aarch64 qemu-aarch64_be
    #   qemu-system-xtensa qemu-xtensa qemu-system-xtensaeb qemu-xtensaeb
    #   ......
    qemu
  ];
}
