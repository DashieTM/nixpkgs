{
  lib,
  rustPlatform,
  fetchFromGitHub,
  vimUtils,
  gitMinimal,
  dbus,
  pkg-config,
}: let
  version = "2025.11.2";
  src = fetchFromGitHub {
    owner = "nomad";
    repo = "nomad";
    tag = version;
    hash = "sha256-fF70G5fTrOHKxZ/EB6+Q0pyOEjfvAd30BL70xr3DKeM=";
  };

  nomad-rust = rustPlatform.buildRustPackage {
    inherit version src;
    pname = "nomad-rust";

    buildInputs = [ dbus ];
    nativeBuildInputs = [ pkg-config gitMinimal ];
  cargoBuildFlags = [ "--package" "nomad-neovim" ];
  cargoCheckFlags = [ "--package" "nomad-neovim" ];
    doCheck = false;


    cargoHash = "sha256-tNFCT5Puddj2K2HCQd/ENdmZ6mSruWczA3RvbTrEeQg=";
    # nativeBuildInputs = [ gitMinimal ];
        # ${lib.optionalString isCross "--target=${hostPlatform.rust.rustcTarget}"} \
    # doCheck = false;
    # buildPhaseCargoCommand = ''
    #   ${lib.getExe xtask} neovim build \
    #     "--release" \
    #     --out-dir=$out \
    #     --includes=
    # '';
    #           doNotPostBuildInstallCargoBinaries = true;
    #           installPhaseCommand = "";

    env = {
      # TODO: remove this if plugin stops using nightly rust
      RUSTC_BOOTSTRAP = true;
    };
  };
in
  vimUtils.buildVimPlugin {
    pname = "nomad";
    inherit version src;

    # preInstall = ''
    #   mkdir -p $out
    #   cp -r ${nomad-rust}/lua $out/
    #   chmod -R +w $out/lua
    #   cp -r ${../lua}/* $out/lua
    # '';

    dependencies = [
      nomad-rust
    ];

    meta = {
      description = "what";
      homepage = "https://github.com/nomad/nomad";
      changelog = "https://github.com/nomad/nomad/releases/tag/${version}";
      license = lib.licenses.gpl3; # TODO beforepr
      maintainers = with lib.maintainers; [DashieTM];
    };

    # nvimSkipModules = [
    #   # Module for reproducing issues
    #   "repro"
    # ];
  }
