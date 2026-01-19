{
  pkgs,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      gpick
    ]
  );
}
