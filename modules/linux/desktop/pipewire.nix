{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Sound Open Firmware
    sof-firmware
    pulseaudio # provides `pactl`, but wpctl privated by wireplumber is better
    # gui tool
    helvum
    pavucontrol
    alsa-utils
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;
  };
}

