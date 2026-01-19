{
  pkgs,
  ...
}:
{
  home.packages = (
    with pkgs;
    [
      mupdf
      zathura
      xournalpp
    ]
  );
}
