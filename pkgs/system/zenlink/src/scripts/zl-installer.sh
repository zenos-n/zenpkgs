#!/usr/bin/env bash
# ==============================================================================
# ZBridge Installer (zb-installer.sh)
# Role: Deploys Python Receiver to Phone (Reliability Optimized)
# Updated: Session ID Syncing + Removed Hardcoded Volume
# ==============================================================================

PHONE_IP=$1
[[ -z "$PHONE_IP" ]] && { echo "Usage: $0 <PHONE_IP>"; exit 1; }

echo ":: Connecting to $PHONE_IP..."
adb connect "$PHONE_IP"
adb -s "$PHONE_IP" wait-for-device

# --- 1. Generate Python Payload (Updated with Session ID Logic) ---
cat << 'EOF' > zb_receiver.py
import socket
import time
import subprocess
import os
import sys

# Constants
CACHE_FILE = "/data/data/com.termux/files/usr/var/zbridge_last_ip"
UDP_LISTEN = 5002
UDP_SEND = 5001
GST_PORT = 5000

# State
pc_ip = None
running = True
gst_process = None
current_session_id = None

def load_cached_ip():
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, 'r') as f:
                return f.read().strip()
        except: pass
    return None

def save_ip(ip):
    try:
        with open(CACHE_FILE, 'w') as f:
            f.write(ip)
    except: pass

def start_gst():
    global gst_process
    if gst_process and gst_process.poll() is None:
        return # Already running
    
    print(":: [Recv] Starting GStreamer (Reliable Mode)...")
    # OPTIMIZATION:
    # 1. do-lost=true: Dropping late packets immediately
    # 2. mode=slave: Slave jitterbuffer to sender clock (Fixes drift/robotic audio)
    # 3. No Volume Plugin: Gain is controlled purely by PC Sender volume (zbout)
    cmd = [
        "gst-launch-1.0", "-q", "udpsrc", f"port={GST_PORT}", "!",
        "application/x-rtp,media=audio,clock-rate=48000,encoding-name=OPUS,payload=96", "!",
        "rtpjitterbuffer", "latency=100", "do-lost=true", "mode=slave", "!",
        "rtpopusdepay", "!", 
        "opusdec", "use-inband-fec=true", "plc=true", "!",
        "openslessink", "buffer-time=100000", "latency-time=20000"
    ]
    gst_process = subprocess.Popen(cmd)

def stop_gst():
    global gst_process
    if gst_process:
        print(":: [Recv] Stopping GStreamer for Sync...")
        gst_process.terminate()
        try:
            gst_process.wait(timeout=1)
        except:
            gst_process.kill()
        gst_process = None

# --- Main Loop ---
print(":: [Recv] ZBridge Receiver Started (Python/Reliable)")

# 1. Load Cache
pc_ip = load_cached_ip()
if pc_ip:
    print(f":: [Recv] Loaded cached PC IP: {pc_ip}. Advertising immediately.")

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# Socket Buffer Optimization
try:
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 131072)
except: pass # Might fail on some Android kernels

sock.bind(('0.0.0.0', UDP_LISTEN))
sock.settimeout(1.0) # Non-blocking listen

last_advert = 0

while running:
    current_time = time.time()
    
    # A. ADVERTISE / HEARTBEAT
    if pc_ip:
        if current_time - last_advert > 1.0: # Send every 1s
            try:
                sock.sendto(b"READY", (pc_ip, UDP_SEND))
                last_advert = current_time
            except Exception as e:
                print(f":: [Error] Send failed: {e}")

    # B. LISTEN
    try:
        data, addr = sock.recvfrom(1024)
        msg = data.decode('utf-8').strip()
        sender_ip = addr[0]

        if "SYNC" in msg:
            new_ip = msg.split(':')[1] if ':' in msg else sender_ip
            if new_ip != pc_ip:
                print(f":: [Recv] SYNC received. PC found at {new_ip}")
                pc_ip = new_ip
                save_ip(pc_ip)
            sock.sendto(b"READY", (pc_ip, UDP_SEND))
            
        elif "ACK" in msg:
            # Parse ACK:SessionID
            parts = msg.split(':')
            received_sid = parts[1] if len(parts) > 1 else "legacy"
            
            # If Session ID changed, RESTART GStreamer to resync clocks
            if received_sid != "legacy" and received_sid != current_session_id:
                print(f":: [Recv] New Session detected ({received_sid}). Resyncing...")
                stop_gst()
                current_session_id = received_sid
            
            start_gst()
            
    except socket.timeout:
        pass
    except Exception as e:
        print(f":: [Error] Loop error: {e}")

    # C. HEALTH CHECK / WATCHDOG
    if pc_ip and (not gst_process or gst_process.poll() is not None):
        pass 
EOF

# --- 2. Generate Wrapper Script ---
cat << 'EOF' > zreceiver_setup.sh
#!/data/data/com.termux/files/usr/bin/sh
PREFIX="/data/data/com.termux/files/usr"
SVDIR="$PREFIX/var/service"
SERVICE_DIR="$SVDIR/zreceiver"

echo ":: Installing Dependencies (Python)..."
yes | pkg update
yes | pkg install termux-services gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad python

echo ":: Configuring Service Files..."
mkdir -p "$SERVICE_DIR"
mkdir -p "$PREFIX/var" # For cache file

# Move python script
mv /sdcard/Download/zb_receiver.py "$SERVICE_DIR/receiver.py"

# Run Script
cat << 'RUN' > "$SERVICE_DIR/run"
#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
exec 2>&1
# Run the python script unbuffered
exec python3 -u "$SVDIR/zreceiver/receiver.py"
RUN

chmod +x "$SERVICE_DIR/run"
echo ":: Service Configured."
EOF

# --- 3. Push & Execute ---
echo ":: Pushing payloads..."
adb -s "$PHONE_IP" push zb_receiver.py /sdcard/Download/zb_receiver.py
adb -s "$PHONE_IP" push zreceiver_setup.sh /sdcard/Download/zreceiver_setup.sh

echo ":: Launching Termux..."
adb -s "$PHONE_IP" shell am start -n com.termux/.app.TermuxActivity
sleep 3
adb -s "$PHONE_IP" shell input text "sh\\ /sdcard/Download/zreceiver_setup.sh"
adb -s "$PHONE_IP" shell input keyevent 66 

echo ":: Waiting for installation (20s)..."
sleep 20
echo ":: Restarting Termux..."
adb -s "$PHONE_IP" shell am force-stop com.termux
adb -s "$PHONE_IP" shell am start -n com.termux/.app.TermuxActivity

echo ":: DONE. Re-run zb-config to connect."
rm zb_receiver.py zreceiver_setup.sh


echo ":: IMPORTANT! if you see a \"java.lang.SecurityException: Injecting input events requires the caller \(or the source of the instrumentation, if any\) to have the INJECT_EVENTS permission.\" it means that it hasn't installed itself. You have to go to Settings > Additional Settings > Developer Options and enable \"USB Debugging (Security Settings)\" (it might be named something else on your device so look for something akin to that) and toggle it on."
echo ":: IMPORTANT! if the installer didn't recognize the phone, you probably need to enable wireless debugging."