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

  mkVariant = v: "<${v}>";
  mkString = v: "'${v}'";

  serializeCommandList =
    commands:
    if commands == { } then
      "@a{sv} {}"
    else
      let
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

  pluginBatterySubmodule = types.submodule {
    options = {
      send-statistics = mkOption {
        type = types.bool;
        default = false;
        description = "Transmit battery health data to connected device";
      };
      low-battery-notification = mkOption {
        type = types.bool;
        default = true;
        description = "Alert when the remote battery level is critically low";
      };
      custom-battery-notification = mkOption {
        type = types.bool;
        default = false;
        description = "Enable alerts for specific battery percentage thresholds";
      };
      custom-battery-notification-value = mkOption {
        type = types.int;
        default = 80;
        description = "Trigger threshold for custom battery alerts";
      };
      full-battery-notification = mkOption {
        type = types.bool;
        default = false;
        description = "Alert when remote battery reaches full charge";
      };
    };
  };

  pluginClipboardSubmodule = types.submodule {
    options = {
      receive-content = mkOption {
        type = types.bool;
        default = false;
        description = "Accept incoming clipboard data from external devices";
      };
      send-content = mkOption {
        type = types.bool;
        default = false;
        description = "Broadcast local clipboard data to external devices";
      };
    };
  };

  pluginContactsSubmodule = types.submodule {
    options = {
      contacts-source = mkOption {
        type = types.bool;
        default = true;
        description = "Permit contact list synchronization with remote devices";
      };
    };
  };

  pluginMousepadSubmodule = types.submodule {
    options = {
      share-control = mkOption {
        type = types.bool;
        default = true;
        description = "Allow remote cursor and input manipulation";
      };
    };
  };

  pluginMprisSubmodule = types.submodule {
    options = {
      share-players = mkOption {
        type = types.bool;
        default = true;
        description = "Export media player controls to connected devices";
      };
    };
  };

  pluginNotificationSubmodule = types.submodule {
    options = {
      send-notifications = mkOption {
        type = types.bool;
        default = true;
        description = "Forward desktop notifications to connected devices";
      };
      send-active = mkOption {
        type = types.bool;
        default = true;
        description = "Restrict notification forwarding to active session state";
      };
      applications = mkOption {
        type = types.str;
        default = "{}";
        description = "JSON configuration for per-application notification rules";
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
                description = "Display label for the remote command";
              };
              command = mkOption {
                type = types.str;
                description = "System command string to be executed";
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
        description = ''
          Managed set of executable remote commands

          Dictionary of commands that can be triggered from a connected 
          Android or iOS device.
        '';
      };
    };
  };

  pluginSftpSubmodule = types.submodule {
    options = {
      automount = mkOption {
        type = types.bool;
        default = true;
        description = "Mount remote filesystem automatically upon connection";
      };
    };
  };

  pluginShareSubmodule = types.submodule {
    options = {
      receive-files = mkOption {
        type = types.bool;
        default = true;
        description = "Allow remote devices to push files to the desktop";
      };
      receive-directory = mkOption {
        type = types.str;
        default = "";
        description = "Destination path for incoming wireless transfers";
      };
      launch-urls = mkOption {
        type = types.bool;
        default = false;
        description = "Automatically open received links in the default browser";
      };
    };
  };

  pluginSmsSubmodule = types.submodule {
    options = {
      legacy-sms = mkOption {
        type = types.bool;
        default = false;
        description = "Enable compatibility mode for older Android SMS stacks";
      };
    };
  };

  pluginSystemVolumeSubmodule = types.submodule {
    options = {
      share-sinks = mkOption {
        type = types.bool;
        default = true;
        description = "Permit remote control of desktop audio outputs";
      };
    };
  };

  pluginTelephonySubmodule = types.submodule {
    options = {
      ringing-volume = mkOption {
        type = types.str;
        default = "lower";
        description = "Audio behavior during incoming call events";
      };
      ringing-pause = mkOption {
        type = types.bool;
        default = false;
        description = "Suspend media playback when phone is ringing";
      };
      talking-volume = mkOption {
        type = types.str;
        default = "mute";
        description = "Audio behavior during active call events";
      };
      talking-microphone = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically mute local mic during voice calls";
      };
      talking-pause = mkOption {
        type = types.bool;
        default = true;
        description = "Suspend media playback during active calls";
      };
    };
  };

  deviceDefaultsSubmodule = types.submodule {
    options = {
      battery = mkOption {
        type = pluginBatterySubmodule;
        default = { };
        description = "Battery plugin default configuration";
      };
      clipboard = mkOption {
        type = pluginClipboardSubmodule;
        default = { };
        description = "Clipboard plugin default configuration";
      };
      contacts = mkOption {
        type = pluginContactsSubmodule;
        default = { };
        description = "Contacts plugin default configuration";
      };
      mousepad = mkOption {
        type = pluginMousepadSubmodule;
        default = { };
        description = "Mousepad plugin default configuration";
      };
      mpris = mkOption {
        type = pluginMprisSubmodule;
        default = { };
        description = "Media player plugin default configuration";
      };
      notification = mkOption {
        type = pluginNotificationSubmodule;
        default = { };
        description = "Notification plugin default configuration";
      };
      runcommand = mkOption {
        type = pluginRunCommandSubmodule;
        default = { };
        description = "Remote command plugin default configuration";
      };
      sftp = mkOption {
        type = pluginSftpSubmodule;
        default = { };
        description = "SFTP plugin default configuration";
      };
      share = mkOption {
        type = pluginShareSubmodule;
        default = { };
        description = "File sharing plugin default configuration";
      };
      sms = mkOption {
        type = pluginSmsSubmodule;
        default = { };
        description = "SMS plugin default configuration";
      };
      systemvolume = mkOption {
        type = pluginSystemVolumeSubmodule;
        default = { };
        description = "Volume control plugin default configuration";
      };
      telephony = mkOption {
        type = pluginTelephonySubmodule;
        default = { };
        description = "Telephony plugin default configuration";
      };
    };
  };

in
{
  meta = {
    description = ''
      Mobile device integration via GSConnect and KDE Connect

      This module provides deep integration for **GSConnect**, a complete implementation 
      of the KDE Connect protocol for GNOME Shell.

      ### Features
      - **Notification Sync:** Receive and reply to Android notifications on your desktop.
      - **File Transfer:** Wireless sharing of files and URLs between devices.
      - **Media Control:** Remotely control your desktop's media players or vice versa.
      - **Telephony:** See incoming calls and SMS messages on your computer.
      - **Remote Input:** Use your mobile device as a touchpad or keyboard for your PC.
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
      description = ''
        Master switch for extension functionality

        Enables or disables the GSConnect background service and shell integration.
      '';
    };

    show-indicators = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Display connection status in top bar

        Whether to show the persistent connection status and device 
        indicators in the GNOME panel.
      '';
    };

    keep-alive-when-locked = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Maintain background connections during lock

        Ensures that devices remain paired and reachable even when the 
        desktop session is locked.
      '';
    };

    create-native-messaging-hosts = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable browser integration features

        Configures native messaging manifests to allow sharing links 
        directly from web browsers to remote devices.
      '';
    };

    id = mkOption {
      type = types.str;
      default = "";
      description = ''
        Unique machine identifier

        The UUID or identifier used to register this machine within 
        the KDE Connect network.
      '';
    };

    name = mkOption {
      type = types.str;
      default = "";
      description = ''
        Network broadcast name

        The human-readable label shown to other devices when 
        discovering this machine on the local network.
      '';
    };

    debug = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable verbose troubleshooting logs

        Activates detailed logging for diagnostic purposes.
      '';
    };

    discoverable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Make machine visible on local network

        Whether this system should announce itself via MDNS for 
        remote device discovery.
      '';
    };

    device-defaults = mkOption {
      type = deviceDefaultsSubmodule;
      default = { };
      description = ''
        Default plugin policies for paired devices

        A set of default plugin settings that are automatically 
        pushed to dconf for every newly paired device.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.gsconnect ];
    programs.dconf.profiles.user.databases = [
      {
        settings."org/gnome/shell/extensions/gsconnect" = {
          inherit (cfg)
            enabled
            show-indicators
            keep-alive-when-locked
            create-native-messaging-hosts
            id
            name
            debug
            discoverable
            ;
        };
      }
    ];

    systemd.user.services.gsconnect-device-config = {
      description = "Apply GSConnect device defaults";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        set_val() { ${pkgs.dconf}/bin/dconf write "$1" "$2"; }
        DEVICES_RAW=$(${pkgs.dconf}/bin/dconf read /org/gnome/shell/extensions/gsconnect/devices)
        if [ -z "$DEVICES_RAW" ] || [ "$DEVICES_RAW" = "@as []" ]; then exit 0; fi
        DEVICES=$(echo "$DEVICES_RAW" | sed "s/[[']//g;s/,/ /g;s/]//g")

        for ID in $DEVICES; do
          BASE="/org/gnome/shell/extensions/gsconnect/device/$ID"
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
          set_val "$BASE/plugin/clipboard/receive-content" "${
            if cfg.device-defaults.clipboard.receive-content then "true" else "false"
          }"
          set_val "$BASE/plugin/clipboard/send-content" "${
            if cfg.device-defaults.clipboard.send-content then "true" else "false"
          }"
          set_val "$BASE/plugin/contacts/contacts-source" "${
            if cfg.device-defaults.contacts.contacts-source then "true" else "false"
          }"
          set_val "$BASE/plugin/mousepad/share-control" "${
            if cfg.device-defaults.mousepad.share-control then "true" else "false"
          }"
          set_val "$BASE/plugin/mpris/share-players" "${
            if cfg.device-defaults.mpris.share-players then "true" else "false"
          }"
          set_val "$BASE/plugin/notification/send-notifications" "${
            if cfg.device-defaults.notification.send-notifications then "true" else "false"
          }"
          set_val "$BASE/plugin/notification/send-active" "${
            if cfg.device-defaults.notification.send-active then "true" else "false"
          }"
          set_val "$BASE/plugin/notification/applications" "${escapeShellArg cfg.device-defaults.notification.applications}"
          set_val "$BASE/plugin/runcommand/command-list" "${escapeShellArg (serializeCommandList cfg.device-defaults.runcommand.command-list)}"
          set_val "$BASE/plugin/sftp/automount" "${
            if cfg.device-defaults.sftp.automount then "true" else "false"
          }"
          set_val "$BASE/plugin/share/receive-files" "${
            if cfg.device-defaults.share.receive-files then "true" else "false"
          }"
          set_val "$BASE/plugin/share/receive-directory" "'${cfg.device-defaults.share.receive-directory}'"
          set_val "$BASE/plugin/share/launch-urls" "${
            if cfg.device-defaults.share.launch-urls then "true" else "false"
          }"
          set_val "$BASE/plugin/sms/legacy-sms" "${
            if cfg.device-defaults.sms.legacy-sms then "true" else "false"
          }"
          set_val "$BASE/plugin/systemvolume/share-sinks" "${
            if cfg.device-defaults.systemvolume.share-sinks then "true" else "false"
          }"
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
