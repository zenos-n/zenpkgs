{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.zenos.desktops.gnome.extensions.gsconnect;
  inherit (lib)
    mkIf
    mkOption
    types
    mapAttrsToList
    concatStringsSep
    mkEnableOption
    escapeShellArg
    ;

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
      send-statistics = mkOption {
        type = types.bool;
        default = false;
        description = "Send battery statistics to the connected device";
      };
      low-battery-notification = mkOption {
        type = types.bool;
        default = true;
        description = "Show notification when battery is low";
      };
      custom-battery-notification = mkOption {
        type = types.bool;
        default = false;
        description = "Enable custom battery threshold notification";
      };
      custom-battery-notification-value = mkOption {
        type = types.int;
        default = 80;
        description = "Percentage threshold for custom battery notification";
      };
      full-battery-notification = mkOption {
        type = types.bool;
        default = false;
        description = "Show notification when battery is fully charged";
      };
    };
  };

  pluginClipboardSubmodule = types.submodule {
    options = {
      receive-content = mkOption {
        type = types.bool;
        default = false;
        description = "Receive clipboard content from connected devices";
      };
      send-content = mkOption {
        type = types.bool;
        default = false;
        description = "Send local clipboard content to connected devices";
      };
    };
  };

  pluginContactsSubmodule = types.submodule {
    options = {
      contacts-source = mkOption {
        type = types.bool;
        default = true;
        description = "Share local contacts with the connected device";
      };
    };
  };

  pluginMousepadSubmodule = types.submodule {
    options = {
      share-control = mkOption {
        type = types.bool;
        default = true;
        description = "Allow the connected device to control the mouse pointer";
      };
    };
  };

  pluginMprisSubmodule = types.submodule {
    options = {
      share-players = mkOption {
        type = types.bool;
        default = true;
        description = "Share MPRIS media player controls with the connected device";
      };
    };
  };

  pluginNotificationSubmodule = types.submodule {
    options = {
      send-notifications = mkOption {
        type = types.bool;
        default = true;
        description = "Send system notifications to the connected device";
      };
      send-active = mkOption {
        type = types.bool;
        default = true;
        description = "Only send notifications when the system is active";
      };
      applications = mkOption {
        type = types.str;
        default = "{}";
        description = "JSON string defining per-application notification policies";
      };
    };
  };

  pluginRunCommandSubmodule = types.submodule {
    options = {
      command-list = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              name = mkOption {
                type = types.str;
                description = "Display name of the command";
              };
              command = mkOption {
                type = types.str;
                description = "Shell command to execute";
              };
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
        description = "Attributes of commands shared with connected devices";
      };
    };
  };

  pluginSftpSubmodule = types.submodule {
    options = {
      automount = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically mount the device filesystem via SFTP";
      };
    };
  };

  pluginShareSubmodule = types.submodule {
    options = {
      receive-files = mkOption {
        type = types.bool;
        default = true;
        description = "Allow receiving files from the connected device";
      };
      receive-directory = mkOption {
        type = types.str;
        default = "";
        description = "Directory for received files (defaults to ~/Downloads)";
      };
      launch-urls = mkOption {
        type = types.bool;
        default = false;
        description = "Automatically open received URLs in the default browser";
      };
    };
  };

  pluginSmsSubmodule = types.submodule {
    options = {
      legacy-sms = mkOption {
        type = types.bool;
        default = false;
        description = "Enable legacy SMS support for older Android versions";
      };
    };
  };

  pluginSystemVolumeSubmodule = types.submodule {
    options = {
      share-sinks = mkOption {
        type = types.bool;
        default = true;
        description = "Allow connected devices to control system volume";
      };
    };
  };

  pluginTelephonySubmodule = types.submodule {
    options = {
      ringing-volume = mkOption {
        type = types.str;
        default = "lower";
        description = "System volume behavior during incoming calls (lower, mute, or none)";
      };
      ringing-pause = mkOption {
        type = types.bool;
        default = false;
        description = "Pause media playback during incoming calls";
      };
      talking-volume = mkOption {
        type = types.str;
        default = "mute";
        description = "System volume behavior during active calls";
      };
      talking-microphone = mkOption {
        type = types.bool;
        default = true;
        description = "Mute local microphone during active calls";
      };
      talking-pause = mkOption {
        type = types.bool;
        default = true;
        description = "Pause media playback during active calls";
      };
    };
  };

  deviceDefaultsSubmodule = types.submodule {
    options = {
      battery = mkOption {
        type = pluginBatterySubmodule;
        default = { };
        description = "Battery plugin settings";
      };
      clipboard = mkOption {
        type = pluginClipboardSubmodule;
        default = { };
        description = "Clipboard plugin settings";
      };
      contacts = mkOption {
        type = pluginContactsSubmodule;
        default = { };
        description = "Contacts plugin settings";
      };
      mousepad = mkOption {
        type = pluginMousepadSubmodule;
        default = { };
        description = "Remote mousepad plugin settings";
      };
      mpris = mkOption {
        type = pluginMprisSubmodule;
        default = { };
        description = "Media player integration settings";
      };
      notification = mkOption {
        type = pluginNotificationSubmodule;
        default = { };
        description = "Notification synchronization settings";
      };
      runcommand = mkOption {
        type = pluginRunCommandSubmodule;
        default = { };
        description = "Remote command execution settings";
      };
      sftp = mkOption {
        type = pluginSftpSubmodule;
        default = { };
        description = "Filesystem integration settings";
      };
      share = mkOption {
        type = pluginShareSubmodule;
        default = { };
        description = "File sharing plugin settings";
      };
      sms = mkOption {
        type = pluginSmsSubmodule;
        default = { };
        description = "SMS integration settings";
      };
      systemvolume = mkOption {
        type = pluginSystemVolumeSubmodule;
        default = { };
        description = "System volume control settings";
      };
      telephony = mkOption {
        type = pluginTelephonySubmodule;
        default = { };
        description = "Telephony integration settings";
      };
    };
  };

in
{
  meta = {
    description = "Configures the GSConnect GNOME extension for Android integration";
    longDescription = ''
      This module provides deep integration for **GSConnect**, a complete implementation 
      of the KDE Connect protocol for GNOME Shell.

      ### Features
      - **Notification Sync:** Receive and reply to Android notifications on your desktop.
      - **File Transfer:** Wireless sharing of files and URLs between devices.
      - **Media Control:** Remotely control your desktop's media players or vice versa.
      - **Telephony:** See incoming calls and SMS messages on your computer.
      - **Remote Input:** Use your mobile device as a touchpad or keyboard for your PC.

      Integrates with the `zenos.desktops.gnome` ecosystem.
    '';
    maintainers = with lib.maintainers; [ doromiert ];
    license = lib.licenses.napl;
    platforms = lib.platforms.zenos;
  };

  options.zenos.desktops.gnome.extensions.gsconnect = {
    enable = mkEnableOption "GSConnect GNOME extension configuration";

    enabled = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the GSConnect extension functionality";
    };

    show-indicators = mkOption {
      type = types.bool;
      default = false;
      description = "Show connection status indicators in the top bar";
    };

    keep-alive-when-locked = mkOption {
      type = types.bool;
      default = true;
      description = "Maintain device connections while the screen is locked";
    };

    create-native-messaging-hosts = mkOption {
      type = types.bool;
      default = true;
      description = "Enable browser integration for sharing links directly to devices";
    };

    id = mkOption {
      type = types.str;
      default = "";
      description = "The unique identifier for this machine's GSConnect service";
    };

    name = mkOption {
      type = types.str;
      default = "";
      description = "The display name for this machine (shown on mobile devices)";
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable verbose debug logging for troubleshooting";
    };

    discoverable = mkOption {
      type = types.bool;
      default = true;
      description = "Make this machine visible to other devices on the network";
    };

    device-defaults = mkOption {
      type = deviceDefaultsSubmodule;
      default = { };
      description = "Default plugin settings applied to all paired devices via dconf";
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
        # Helper to write if changed
        set_val() {
          ${pkgs.dconf}/bin/dconf write "$1" "$2"
        }

        # Get list of devices
        DEVICES_RAW=$(${pkgs.dconf}/bin/dconf read /org/gnome/shell/extensions/gsconnect/devices)

        if [ -z "$DEVICES_RAW" ] || [ "$DEVICES_RAW" = "@as []" ]; then
          exit 0
        fi

        # Clean string to space-separated list
        DEVICES=$(echo "$DEVICES_RAW" | sed "s/[[']//g;s/,/ /g;s/]//g")

        for ID in $DEVICES; do
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
          set_val "$BASE/plugin/notification/applications" "${escapeShellArg cfg.device-defaults.notification.applications}"

          # RunCommand
          set_val "$BASE/plugin/runcommand/command-list" "${escapeShellArg (serializeCommandList cfg.device-defaults.runcommand.command-list)}"

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
