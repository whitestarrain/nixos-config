{ helper, ... }:

{
  imports = helper.lib.scanNixPaths ./.;
}
