{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clashtui";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "whitestarrain";
    repo = "clashtui";
    rev = "2262a2e6faf751ba42592135c8d00e47edd77e8c";
    hash = "sha256-H15KbZqOL1DMHFiqNh5nlPBhBDBJw48/hujPy3dvFS8=";
  };

  # sourceRoot = ".";

  cargoHash = "sha256-BSXFG+aN/iWcbNbU44b3++R9OpdmIfYvsCiWlrJGeW0=";

  cargoBuildFlags = [ "--all-features" ];

  checkFlags = [
    # need fhs
    "--skip=utils::config::test::test_save_and_load"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mihomo (Clash.Meta) TUI Client";
    homepage = "https://github.com/whitestarrain/clashtui";
    changelog = "https://github.com/whitestarrain/clashtui/releases/tag/v${finalAttrs.version}";
    mainProgram = "clashtui";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
