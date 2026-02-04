#!/usr/bin/env bash

PHONE_IP=$1
[[ -z "$PHONE_IP" ]] && { echo "Usage: $0 <PHONE_IP>"; exit 1; }

echo ":: Connecting to $PHONE_IP..."
adb connect "$PHONE_IP"
adb -s "$PHONE_IP" wait-for-device

echo ":: ---------------------------------------------------------------- ::"
echo ":: PREPARING DEBUG SESSION                                        ::"
echo ":: Please UNLOCK your phone screen and keep it visible.           ::"
echo ":: ---------------------------------------------------------------- ::"

# --- 1. Generate Debug Payload ---
# We write a temporary script that contains the full logic with EXTRA LOGGING
cat << 'EOF' > zdebug_wrapper.sh
#!/data/data/com.termux/files/usr/bin/sh
PREFIX="/data/data/com.termux/files/usr"
SVDIR="$PREFIX/var/service"

echo ""
echo ":: [Debug] Stopping background zreceiver service..."
sv down zreceiver 2>/dev/null

echo ":: [Debug] Starting zreceiver logic (DEBUG MODE)."
echo ":: [Debug] Watch for 'TARGET IP' below..."
echo ":: [Debug] Press Volume Down + C (Ctrl+C) to stop."
echo "---------------------------------------------------"

STATE="WAIT_SYNC"
PC_IP=""

while true; do
    if [ "$STATE" = "WAIT_SYNC" ]; then
        echo ":: Waiting for SYNC poke on UDP:5002..."
        POKE=$(nc -u -l -p 5002 -W 1 -w 5)
        
        if echo "$POKE" | grep -q "SYNC:"; then
            PC_IP=$(echo "$POKE" | cut -d: -f2)
            echo ":: [!!!] RECEIVED SYNC. PC IP: $PC_IP"
            STATE="HANDSHAKE"
        fi
        
    elif [ "$STATE" = "HANDSHAKE" ]; then
        echo ":: Sending READY..."
        echo "READY" | nc -u -w 1 "$PC_IP" 5001
        
        echo ":: Listening for ACK..."
        ACK=$(nc -u -l -p 5002 -W 1 -w 2)
        
        if echo "$ACK" | grep -q "ACK"; then
             echo ":: [!!!] HANDSHAKE SUCCESS! RECEIVED ACK."
             STATE="CONNECTED"
             
             # Start GStreamer in Debug Mode (Foreground)
             echo ":: Launching GStreamer..."
             gst-launch-1.0 -q udpsrc port=5000 ! \
             application/x-rtp,media=audio,clock-rate=48000,encoding-name=OPUS,payload=96 ! \
             rtpjitterbuffer latency=100 ! \
             rtpopusdepay ! opusdec ! \
             openslessink buffer-time=80000 latency-time=20000 &
             GST_PID=$!
        fi
        
    elif [ "$STATE" = "CONNECTED" ]; then
        sleep 5
        echo ":: Sending Heartbeat..."
        echo "READY" | nc -u -w 1 "$PC_IP" 5001
        
        if ! kill -0 "$GST_PID" 2>/dev/null; then
             echo ":: GStreamer died."
             STATE="WAIT_SYNC"
        fi
    fi
    sleep 0.1
done

# If user cancels, offer to restart
echo ""
echo ":: [Debug] Process stopped."
echo -n ":: Restart background service? (y/n): "
read ans
if [ "$ans" = "y" ]; then
    sv up zreceiver
    echo ":: Service restarted."
fi
EOF

# --- 2. Push & Execute on Phone ---
echo ":: Pushing debug wrapper to phone..."
adb -s "$PHONE_IP" push zdebug_wrapper.sh /sdcard/Download/zdebug_wrapper.sh

echo ":: Launching Termux on Phone..."
# We force start to ensure it's in foreground
adb -s "$PHONE_IP" shell am start -n com.termux/.app.TermuxActivity
sleep 2

echo ":: Injecting command..."
# Type: sh /sdcard/Download/zdebug_wrapper.sh
# We escape the space for ADB input
adb -s "$PHONE_IP" shell input text "sh\\ /sdcard/Download/zdebug_wrapper.sh"
adb -s "$PHONE_IP" shell input keyevent 66 

echo ":: ---------------------------------------------------------------- ::"
echo ":: CHECK YOUR PHONE SCREEN NOW.                                   ::"
echo ":: Verify the IP address shown in '[!!!] RECEIVED SYNC PACKET'    ::"
echo ":: ---------------------------------------------------------------- ::"

rm zdebug_wrapper.sh