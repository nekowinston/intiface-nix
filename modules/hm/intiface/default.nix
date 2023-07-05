{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.intiface;
  inherit (lib) types;
in {
  options.services.intiface = {
    enable = lib.mkEnableOption "intiface";
    package = lib.mkOption {
      type = types.package;
      default = pkgs.callPackage ../../../pkgs/intiface-engine {};
      description = "The intiface package to use.";
    };
    port = lib.mkOption {
      type = types.port;
      default = 12345;
      description = "Port to listen on for websocket connections";
    };
    serverName = lib.mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Name to use for the websocket server";
    };

    allInterfaces = lib.mkEnableOption "If passed, websocket server listens on all interfaces. Otherwise, only listen on 127.0.0.1.";
    bluetoothLE = lib.mkEnableOption "Turn on bluetooth LE device support";
    lovense = lib.mkOption {
      type = types.submodule ({config, ...}: {
        options = {
          enable = lib.mkEnableOption "Turn on lovense connect app device support";
          hid = lib.mkEnableOption "Turn on lovense dongle hid device support";
          serial = lib.mkEnableOption "Turn on lovense dongle serial device support";
        };
      });
      default = {};
      description = "Options for lovense device support";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.intiface = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Service = {
        ExecStart = builtins.toString (
          [(lib.getExe cfg.package) "--websocket-port" (builtins.toString cfg.port)]
          ++ lib.optionals cfg.allInterfaces ["--websocket-use-all-interfaces"]
          ++ lib.optionals cfg.bluetoothLE ["--use-bluetooth-le"]
          ++ lib.optionals cfg.lovense.enable ["--use-lovense-connect"]
          ++ lib.optionals cfg.lovense.hid ["--use-lovense-dongle-hid"]
          ++ lib.optionals cfg.lovense.serial ["--use-lovense-dongle-serial"]
          ++ lib.optionals (cfg.serverName != null) ["--server-name" cfg.serverName]
        );
        Restart = "on-failure";
        Slice = "app.slice";
        TimeoutStopSec = 15;
        Type = "simple";

        # Sandboxing.
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateUsers = true;
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
      };
      Unit = {
        Description = "Intiface";
        After = ["graphical-session-pre.target"] ++ lib.optionals cfg.bluetoothLE ["bluetooth.target"];
        Requires = [] ++ lib.optionals cfg.bluetoothLE ["bluetooth.target"];
      };
    };
  };
}
