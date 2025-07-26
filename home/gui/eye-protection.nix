{ ... }:
{
  services.gammastep = {
    enable = true;
    tray = false;
    temperature = {
      day = 6700;
      night = 5000;
    };
    settings = {
      general = {
        fade = "1";
        brightness-day = "1.0";
        brightness-night = "0.8";
        location-provider = "manual";
      };
      manual = {
        # China Bejing
        lat = "39.9"; # latitude
        lon = "116.3"; # longitude
      };
    };
  };
}
