{
  callPackage,
  dbus,
  gcc,
  openssl,
  pkg-config,
  rustPlatform,
  udev,
}: let
  nvfetcher = (callPackage ../../_sources/generated.nix {}).intiface-engine;
in
  rustPlatform.buildRustPackage {
    inherit (nvfetcher) pname version src;
    cargoLock = nvfetcher.cargoLock."Cargo.lock";

    env.VERGEN_BUILD_TIMESTAMP = "0";
    env.VERGEN_GIT_SHA_SHORT = "0000000";

    nativeBuildInputs = [
      gcc
      pkg-config
    ];

    buildInputs = [
      dbus
      openssl
      udev
    ];
  }
