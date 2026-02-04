#!/usr/bin/env bash
# ==============================================================================
# ZBridge Controller (zb-config.sh)
# Role: Client / State Writer / List Manager
# ==============================================================================

CONFIG_DIR="$HOME/.config/zenlink"
CONFIG_FILE="$CONFIG_DIR/state.conf"
IPS_FILE="$CONFIG_DIR/saved_ips"
PORTS_FILE="$CONFIG_DIR/saved_ports"
CONFIG_PID_FILE="/tmp/zenlink_config_pid"
SERVICE_NAME="zenlink"

mkdir -p "$CONFIG_DIR"
[[ ! -f "$CONFIG_FILE" ]] && touch "$CONFIG_FILE"
[[ ! -f "$IPS_FILE" ]] && touch "$IPS_FILE"
[[ ! -f "$PORTS_FILE" ]] && touch "$PORTS_FILE"

# --- Confirmation Mechanism ---
CONFIRMED=false
trap 'CONFIRMED=true' SIGUSR2

# --- Helpers ---

is_valid_ip() {
    local input=$1
    if [[ $input =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS; IFS='.'; local octets=($input); IFS=$OIFS
        if [[ ${octets[0]} -le 255 && ${octets[1]} -le 255 && \
              ${octets[2]} -le 255 && ${octets[3]} -le 255 ]]; then
            return 0
        fi
    fi
    return 1
}

is_valid_port() {
    local port=$1
    if [[ "$port" =~ ^[0-9]+$ ]] && ((port >= 1 && port <= 65535)); then
        return 0
    fi
    return 1
}

is_valid_number() {
    [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]
}

get_config() {
    local key="$1"
    grep "^$key=" "$CONFIG_FILE" | cut -d'=' -f2 | tr -d '"'
}

set_config() {
    local key="$1"
    local value="$2"
    if grep -q "^$key=" "$CONFIG_FILE"; then
        sed -i "s/^$key=.*/$key=\"$value\"/" "$CONFIG_FILE"
    else
        echo "$key=\"$value\"" >> "$CONFIG_FILE"
    fi
}

send_signal_and_wait() {
    if ! systemctl --user is-active --quiet "$SERVICE_NAME"; then
        echo "[!] Daemon is NOT running. Start it with -t or systemctl."
        return 1
    fi

    echo -n "[*] Updating Daemon... "
    echo "$$" > "$CONFIG_PID_FILE"
    systemctl --user kill -s USR1 "$SERVICE_NAME"
    
    local timeout=50 
    while [[ "$CONFIRMED" == "false" && $timeout -gt 0 ]]; do
        sleep 0.1
        ((timeout--))
    done

    rm -f "$CONFIG_PID_FILE"
    if [[ "$CONFIRMED" == "true" ]]; then
        echo "Done."
    else
        echo -e "\n[!] Timed out waiting for Daemon response."
    fi
}

toggle_setting() {
    local key="$1"
    local input_arg="$2"
    local current=$(get_config "$key")
    [[ -z "$current" ]] && current="off"

    local target=""
    if [[ "$input_arg" == "toggle" ]]; then
        [[ "$current" == "on" ]] && target="off" || target="on"
    else
        target="$input_arg"
    fi

    if [[ "$current" == "$target" ]]; then
        echo "[*] $key is already $target."
    else
        echo "[*] Setting $key to $target"
        set_config "$key" "$target"
        send_signal_and_wait
    fi
}

# --- List Management ---

list_saved() {
    [[ -f "$IPS_FILE" ]] && cat "$IPS_FILE"
}

add_saved_ip() {
    local ip="$1"
    if ! is_valid_ip "$ip"; then
        echo "ERROR: Invalid IP format"
        exit 1
    fi
    if ! grep -Fxq "$ip" "$IPS_FILE"; then
        echo "$ip" >> "$IPS_FILE"
        echo "Saved $ip"
    else
        echo "IP already saved"
    fi
}

add_saved_port() {
    local port="$1"
    if ! is_valid_port "$port"; then
        echo "ERROR: Invalid Port"
        exit 1
    fi
    if ! grep -Fxq "$port" "$PORTS_FILE"; then
        echo "$port" >> "$PORTS_FILE"
        echo "Saved port $port"
    else
        echo "Port already saved"
    fi
}

remove_saved_ip() {
    local ip="$1"
    if [[ -f "$IPS_FILE" ]]; then
        grep -Fxv "$ip" "$IPS_FILE" > "$IPS_FILE.tmp" && mv "$IPS_FILE.tmp" "$IPS_FILE"
        echo "Removed $ip"
    fi
}

remove_saved_port() {
    local port="$1"
    if [[ -f "$PORTS_FILE" ]]; then
        grep -Fxv "$port" "$PORTS_FILE" > "$PORTS_FILE.tmp" && mv "$PORTS_FILE.tmp" "$PORTS_FILE"
        echo "Removed port $port"
    fi
}

show_status() {
    echo ":: ZeroBridge State ::"
    echo "   IP: $(get_config PHONE_IP)"
    echo "   Port: $(get_config PHONE_PORT)"
    
    local cam=$(get_config CAM_FACING)
    echo "   Cam: ${cam:-back}"
    
    if ! grep -qi "CAM_FACING=\"none\"" "$CONFIG_FILE"; then
        local orient=$(get_config CAM_ORIENT)
        if [[ -z "$orient" ]]; then
            local df=$(get_config DEF_ORIENT_FRONT)
            local db=$(get_config DEF_ORIENT_BACK)
            [[ -z "$df" ]] && df="flip90"
            [[ -z "$db" ]] && db="flip270"
            if [[ "$cam" == "front" ]]; then orient="$df (Default)"; else orient="$db (Default)"; fi
        fi
        echo "   Camera orientation: $orient"
    fi
    
    local mon_conf=$(get_config MONITOR)
    local mon_act=$(pw-dump Node | jq -r '.[] | select(.info.props["node.name"] | strings | contains("ZBridge_Monitor")) | .id' | head -n 1)
    echo -n "   Monitor: [${mon_conf:-off}] "
    [[ -n "$mon_act" && "$mon_act" != "null" ]] && echo -e "\033[32m[ACTIVE]\033[0m" || echo -e "\033[31m[INACTIVE]\033[0m"

    local dsk_conf=$(get_config DESKTOP)
    local dsk_act=$(pw-dump Node | jq -r '.[] | select(.info.props["node.name"] | strings | contains("ZBridge_Desktop")) | .id' | head -n 1)
    echo -n "   Desktop: [${dsk_conf:-off}] "
    [[ -n "$dsk_act" && "$dsk_act" != "null" ]] && echo -e "\033[32m[ACTIVE]\033[0m" || echo -e "\033[31m[INACTIVE]\033[0m"

    local mic_gain=$(get_config MIC_GAIN)
    local aud_gain=$(get_config AUDIO_GAIN)
    echo "   Mic Gain: ${mic_gain:-1.0}"
    echo "   Audio Out Gain: ${aud_gain:-1.0}"

    local active=$(systemctl --user is-active "$SERVICE_NAME")
    echo "   Daemon: $active"
}

# --- Main ---

if [[ $# -eq 0 ]]; then show_status; exit 0; fi

while getopts "i:p:c:m:d:o:g:G:F:B:I:r:P:R:Ltk" opt; do
    case $opt in
        i) 
            if is_valid_ip "$OPTARG"; then
                set_config "PHONE_IP" "$OPTARG"; send_signal_and_wait
            else
                echo "[!] Error: Invalid IP."; exit 1
            fi
            ;;
        p)
            if is_valid_port "$OPTARG"; then
                set_config "PHONE_PORT" "$OPTARG"; send_signal_and_wait
            else
                echo "[!] Error: Invalid Port."; exit 1
            fi
            ;;
        g)
            if is_valid_number "$OPTARG"; then
                set_config "MIC_GAIN" "$OPTARG"; send_signal_and_wait
            else
                echo "[!] Error: Gain must be a number (e.g., 1.0, 0.5, 2.5)."
            fi
            ;;
        G)
            if is_valid_number "$OPTARG"; then
                set_config "AUDIO_GAIN" "$OPTARG"; send_signal_and_wait
            else
                echo "[!] Error: Gain must be a number (e.g., 1.0, 0.5, 2.5)."
            fi
            ;;
        I) add_saved_ip "$OPTARG" ;;
        r) remove_saved_ip "$OPTARG" ;;
        P) add_saved_port "$OPTARG" ;; 
        R) remove_saved_port "$OPTARG" ;;
        L) list_saved ;;
        c) 
            set_config "CAM_FACING" "$OPTARG"
            set_config "CAM_ORIENT" ""
            send_signal_and_wait 
            ;;
        o) 
            if grep -qi "CAM_FACING=\"none\"" "$CONFIG_FILE"; then
                echo "[!] Camera is disabled."
            else
                if [[ "$OPTARG" =~ ^(0|flip0|90|flip90|180|flip180|270|flip270)$ ]]; then 
                    set_config "CAM_ORIENT" "$OPTARG"; send_signal_and_wait
                else 
                    echo "[!] Invalid orientation."
                fi
            fi
        ;;
        F) 
            if [[ "$OPTARG" =~ ^(0|flip0|90|flip90|180|flip180|270|flip270)$ ]]; then 
                set_config "DEF_ORIENT_FRONT" "$OPTARG"
                send_signal_and_wait
            fi
            ;;
        B) 
            if [[ "$OPTARG" =~ ^(0|flip0|90|flip90|180|flip180|270|flip270)$ ]]; then 
                set_config "DEF_ORIENT_BACK" "$OPTARG"
                send_signal_and_wait
            fi
            ;;
        m) toggle_setting "MONITOR" "$OPTARG" ;;
        d) toggle_setting "DESKTOP" "$OPTARG" ;;
        t)
            if systemctl --user is-active --quiet "$SERVICE_NAME"; then
                systemctl --user stop "$SERVICE_NAME"
            else
                systemctl --user start "$SERVICE_NAME"
            fi
            ;;
        k)
            systemctl --user stop "$SERVICE_NAME"
            pkill -f "scrcpy"
            pkill -f "pw-loopback.*ZBridge"
            ;;
        \?) echo "Invalid option"; exit 1 ;;
    esac
done