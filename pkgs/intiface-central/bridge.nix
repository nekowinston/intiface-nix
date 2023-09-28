{
  callPackage,
  dbus,
  gcc,
  openssl,
  pkg-config,
  rustPlatform,
  udev,
}: let
  nvfetcher = (callPackage ../../_sources/generated.nix {}).intiface-central;
in
  rustPlatform.buildRustPackage rec {
    inherit (nvfetcher) pname version src;

    cargoLock.lockFile = ./Cargo.lock;

    sourceRoot = "${src.name}/intiface-engine-flutter-bridge";

    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';

    nativeBuildInputs = [
      pkg-config
    ];
    buildInputs = [
      dbus
      gcc
      openssl
      udev
    ];
  }
