{
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = options.zenos.desktops.gnome.extensions.gsconnect;

  # --- Helpers ---
  mkBool =
    default: description:
    mkOption {
      type = types.bool;
      default = default;
      description = description;
    };

  mkInt =
    default: description:
    mkOption {
      type = types.int;
      default = default;
      description = description;
    };

  mkUint =
    default: description:
    mkOption {
      type = types.int;
      default = default;
      description = description;
    };

  mkStr =
    default: description:
    mkOption {
      type = types.str;
      default = default;
      description = description;
    };

  mkStrList =
    default: description:
    mkOption {
      type = types.listOf types.str;
      default = default;
      description = description;
    };

  # --- Serializers ---
  # Basic GSConnect types are simple, but runcommand list is a{sv}
  mkVariant = v: "<${v}>";
  mkString = v: "'${v}'";

  serializeCommandList =
    commands:
    if commands == { } then
      "@a{sv} {}"
    else
      let
        # Expect input: { "name" = { name = "Name"; command = "cmd"; }; }
        serializeCmd =
          cmdAttrs:
          let
            n = cmdAttrs.name or "";
            c = cmdAttrs.command or "";
          in
          " {'name': ${mkVariant (mkString n)}, 'command': ${mkVariant (mkString c)}}";

        pairs = mapAttrsToList (k: v: "${mkString k}: ${mkVariant (serializeCmd v)}") commands;
      in
      "{${concatStringsSep ", " pairs}}";

  # --- Submodules ---

  pluginBatterySubmodule = types.submodule {
    options = {
      send-statistics = mkBool false "Send battery statistics.";
      low-battery-notification = mkBool true "Low battery notification.";
      custom-battery-notification = mkBool false "Custom battery notification.";
      custom-battery-notification-value = mkUint 80 "Custom battery notification value (%).";
      full-battery-notification = mkBool false "Full battery notification.";
    };
  };

  pluginClipboardSubmodule = types.submodule {
    options = {
      receive-content = mkBool false "Receive clipboard content.";
      send-content = mkBool false "Send clipboard content.";
    };
  };

  pluginContactsSubmodule = types.submodule {
    options = {
      contacts-source = mkBool true "Share contacts.";
    };
  };

  pluginMousepadSubmodule = types.submodule {
    options = {
      share-control = mkBool true "Share mouse control.";
    };
  };

  pluginMprisSubmodule = types.submodule {
    options = {
      share-players = mkBool true "Share media players.";
    };
  };

  pluginNotificationSubmodule = types.submodule {
    options = {
      send-notifications = mkBool true "Send notifications.";
      send-active = mkBool true "Send only active notifications.";
      applications = mkStr "{}" "JSON string of application policies.";
    };
  };

  pluginRunCommandSubmodule = types.submodule {
    options = {
      command-list = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              name = mkStr "" "Name of the command.";
              command = mkStr "" "Command to execute.";
            };
          }
        );
        default = {
          lock = {
            name = "Lock";
            command = "xdg-screensaver lock";
          };
          restart = {
            name = "Restart";
            command = "systemctl reboot";
          };
          logout = {
            name = "Log Out";
            command = "gnome-session-quit --logout --no-prompt";
          };
          poweroff = {
            name = "Power Off";
            command = "systemctl poweroff";
          };
          suspend = {
            name = "Suspend";
            command = "systemctl suspend";
          };
        };
        description = "List of commands to share.";
      };
    };
  };

  pluginSftpSubmodule = types.submodule {
    options = {
      automount = mkBool true "Automount device filesystem.";
    };
  };

  pluginShareSubmodule = types.submodule {
    options = {
      receive-files = mkBool true "Receive files.";
      receive-directory = mkStr "" "Directory to receive files (empty = Downloads).";
      launch-urls = mkBool false "Automatically launch received URLs.";
    };
  };

  pluginSmsSubmodule = types.submodule {
    options = {
      legacy-sms = mkBool false "Use legacy SMS support.";
    };
  };

  pluginSystemVolumeSubmodule = types.submodule {
    options = {
      share-sinks = mkBool true "Share system volume sinks.";
    };
  };

  pluginTelephonySubmodule = types.submodule {
    options = {
      ringing-volume = mkStr "lower" "Ringing volume behavior (lower, mute, etc).";
      ringing-pause = mkBool false "Pause media on ring.";
      talking-volume = mkStr "mute" "Talking volume behavior.";
      talking-microphone = mkBool true "Mute microphone while talking.";
      talking-pause = mkBool true "Pause media while talking.";
    };
  };

  deviceDefaultsSubmodule = types.submodule {
    options = {
      battery = mkOption {
        type = pluginBatterySubmodule;
        default = { };
      };
      clipboard = mkOption {
        type = pluginClipboardSubmodule;
        default = { };
      };
      contacts = mkOption {
        type = pluginContactsSubmodule;
        default = { };
      };
      mousepad = mkOption {
        type = pluginMousepadSubmodule;
        default = { };
      };
      mpris = mkOption {
        type = pluginMprisSubmodule;
        default = { };
      };
      notification = mkOption {
        type = pluginNotificationSubmodule;
        default = { };
      };
      runcommand = mkOption {
        type = pluginRunCommandSubmodule;
        default = { };
      };
      sftp = mkOption {
        type = pluginSftpSubmodule;
        default = { };
      };
      share = mkOption {
        type = pluginShareSubmodule;
        default = { };
      };
      sms = mkOption {
        type = pluginSmsSubmodule;
        default = { };
      };
      systemvolume = mkOption {
        type = pluginSystemVolumeSubmodule;
        default = { };
      };
      telephony = mkOption {
        type = pluginTelephonySubmodule;
        default = { };
      };
    };
  };

in
{
  options.zenos.desktops.gnome.extensions.gsconnect = {
    enable = mkEnableOption "GSConnect GNOME extension configuration";

    # --- Global Settings ---
    enabled = mkBool true "Enable GSConnect globally.";
    show-indicators = mkBool false "Show status indicators.";
    keep-alive-when-locked = mkBool true "Keep connection alive when locked.";
    create-native-messaging-hosts = mkBool true "Create native messaging hosts (browser integration).";

    id = mkStr "" "Service ID.";
    name = mkStr "" "Service Name.";
    devices = mkStrList [ ] "List of device IDs (managed by extension, usually).";
    debug = mkBool false "Enable debug logging.";
    discoverable = mkBool true "Discoverable on network.";

    # --- Device Defaults ---
    device-defaults = mkOption {
      type = deviceDefaultsSubmodule;
      default = { };
      description = "Default settings applied to ALL paired devices.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.gsconnect ];

    # 1. Global Dconf Settings
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/shell/extensions/gsconnect" = {
            enabled = cfg.enabled;
            show-indicators = cfg.show-indicators;
            keep-alive-when-locked = cfg.keep-alive-when-locked;
            create-native-messaging-hosts = cfg.create-native-messaging-hosts;
            id = cfg.id;
            name = cfg.name;
            # devices = cfg.devices; # Usually managed dynamically, careful overwriting
            debug = cfg.debug;
            discoverable = cfg.discoverable;
          };
        };
      }
    ];

    # 2. Dynamic Device Configuration Service
    # Iterates over all paired devices found in dconf and applies 'device-defaults'
    systemd.user.services.gsconnect-device-config = {
      description = "Apply GSConnect device defaults";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        # Helper to write if changed (simple version: just write)
        set_val() {
          ${pkgs.dconf}/bin/dconf write "$1" "$2"
        }

        # Get list of devices (format: ['id1', 'id2'])
        DEVICES_RAW=$(${pkgs.dconf}/bin/dconf read /org/gnome/shell/extensions/gsconnect/devices)

        if [ -z "$DEVICES_RAW" ] || [ "$DEVICES_RAW" = "@as []" ]; then
          echo "No GSConnect devices found."
          exit 0
        fi

        # Clean string to space-separated list
        DEVICES=$(echo "$DEVICES_RAW" | sed "s/[[']//g;s/,/ /g;s/]//g")

        for ID in $DEVICES; do
          echo "Configuring GSConnect device: $ID"
          BASE="/org/gnome/shell/extensions/gsconnect/device/$ID"

          # Battery
          set_val "$BASE/plugin/battery/send-statistics" "${
            if cfg.device-defaults.battery.send-statistics then "true" else "false"
          }"
          set_val "$BASE/plugin/battery/low-battery-notification" "${
            if cfg.device-defaults.battery.low-battery-notification then "true" else "false"
          }"
          set_val "$BASE/plugin/battery/custom-battery-notification" "${
            if cfg.device-defaults.battery.custom-battery-notification then "true" else "false"
          }"
          set_val "$BASE/plugin/battery/custom-battery-notification-value" "uint32 ${toString cfg.device-defaults.battery.custom-battery-notification-value}"
          set_val "$BASE/plugin/battery/full-battery-notification" "${
            if cfg.device-defaults.battery.full-battery-notification then "true" else "false"
          }"

          # Clipboard
          set_val "$BASE/plugin/clipboard/receive-content" "${
            if cfg.device-defaults.clipboard.receive-content then "true" else "false"
          }"
          set_val "$BASE/plugin/clipboard/send-content" "${
            if cfg.device-defaults.clipboard.send-content then "true" else "false"
          }"

          # Contacts
          set_val "$BASE/plugin/contacts/contacts-source" "${
            if cfg.device-defaults.contacts.contacts-source then "true" else "false"
          }"

          # Mousepad
          set_val "$BASE/plugin/mousepad/share-control" "${
            if cfg.device-defaults.mousepad.share-control then "true" else "false"
          }"

          # MPRIS
          set_val "$BASE/plugin/mpris/share-players" "${
            if cfg.device-defaults.mpris.share-players then "true" else "false"
          }"

          # Notification
          set_val "$BASE/plugin/notification/send-notifications" "${
            if cfg.device-defaults.notification.send-notifications then "true" else "false"
          }"
          set_val "$BASE/plugin/notification/send-active" "${
            if cfg.device-defaults.notification.send-active then "true" else "false"
          }"
          set_val "$BASE/plugin/notification/applications" "${pkgs.lib.escapeShellArg cfg.device-defaults.notification.applications}"

          # RunCommand (Complex Variant)
          set_val "$BASE/plugin/runcommand/command-list" "${pkgs.lib.escapeShellArg (serializeCommandList cfg.device-defaults.runcommand.command-list)}"

          # SFTP
          set_val "$BASE/plugin/sftp/automount" "${
            if cfg.device-defaults.sftp.automount then "true" else "false"
          }"

          # Share
          set_val "$BASE/plugin/share/receive-files" "${
            if cfg.device-defaults.share.receive-files then "true" else "false"
          }"
          set_val "$BASE/plugin/share/receive-directory" "'${cfg.device-defaults.share.receive-directory}'"
          set_val "$BASE/plugin/share/launch-urls" "${
            if cfg.device-defaults.share.launch-urls then "true" else "false"
          }"

          # SMS
          set_val "$BASE/plugin/sms/legacy-sms" "${
            if cfg.device-defaults.sms.legacy-sms then "true" else "false"
          }"

          # SystemVolume
          set_val "$BASE/plugin/systemvolume/share-sinks" "${
            if cfg.device-defaults.systemvolume.share-sinks then "true" else "false"
          }"

          # Telephony
          set_val "$BASE/plugin/telephony/ringing-volume" "'${cfg.device-defaults.telephony.ringing-volume}'"
          set_val "$BASE/plugin/telephony/ringing-pause" "${
            if cfg.device-defaults.telephony.ringing-pause then "true" else "false"
          }"
          set_val "$BASE/plugin/telephony/talking-volume" "'${cfg.device-defaults.telephony.talking-volume}'"
          set_val "$BASE/plugin/telephony/talking-microphone" "${
            if cfg.device-defaults.telephony.talking-microphone then "true" else "false"
          }"
          set_val "$BASE/plugin/telephony/talking-pause" "${
            if cfg.device-defaults.telephony.talking-pause then "true" else "false"
          }"
        done
      '';
    };
  };
}
