{
  callPackage,
  cargo,
  flutter,
  rustc,
}: let
  nvfetcher = (callPackage ../../_sources/generated.nix {}).intiface-central;
  bridge = callPackage ./bridge.nix {};
in
  flutter.buildFlutterApplication {
    inherit (nvfetcher) pname version src;

    # NB: the pubspec.yaml patch might be removed when
    # https://github.com/intiface/intiface-central/issues/86
    # is closed.
    patchPhase = ''
      substituteInPlace ./pubspec.yaml --replace \
        'flutter_rust_bridge: ^1.79.0' \
        'flutter_rust_bridge: ">=1.79.0 <1.80.0"'
      substituteInPlace ./linux/CMakeLists.txt --replace \
        'include(./rust.cmake)' \
        'target_link_libraries(''${BINARY_NAME} PRIVATE "intiface_engine_flutter_bridge")'
    '';

    pubspecLockFile = ./pubspec.lock;
    depsListFile = ./deps.json;
    vendorHash = "sha256-kF5Cj1ZPTDfsMp/SO8kzk0DA/P6zKMJmJFuYYoV8VxI=";

    buildInputs = [
      bridge
      cargo
      rustc
    ];

    meta.mainProgram = "intiface_central";
  }
