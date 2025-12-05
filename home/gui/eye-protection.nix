{ ... }:
{
  services.gammastep = {
    enable = true;
    tray = false;
    # test: gammastep -x && sleep 1 && gammastep -O 5500
    temperature = {
      day = 5500;
      night = 5100;
    };
    settings = {
      general = {
        fade = "1";
        brightness-day = "1.0";
        brightness-night = "0.8";
        location-provider = "manual";
        adjustment-method = "randr"; # for xorg
      };
      manual = {
        # China Bejing
        lat = "39.9"; # latitude
        lon = "116.3"; # longitude
      };
    };
  };
}
