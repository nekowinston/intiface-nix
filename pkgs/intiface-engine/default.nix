{
  dbus,
  fetchFromGitHub,
  gcc,
  openssl,
  pkg-config,
  rustPlatform,
  udev,
}: let
  npins = import ../../npins;
in
  rustPlatform.buildRustPackage rec {
    name = "intiface-engine";
    version = npins.intiface-engine.version;

    src = fetchFromGitHub {
      owner = "intiface";
      repo = "intiface-engine";
      rev = npins.intiface-engine.revision;
      sha256 = npins.intiface-engine.hash;
    };

    env.VERGEN_BUILD_TIMESTAMP = "0";
    env.VERGEN_GIT_SHA_SHORT = npins.intiface-engine.revision;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

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
