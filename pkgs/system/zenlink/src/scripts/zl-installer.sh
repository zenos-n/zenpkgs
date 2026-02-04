#!/usr/bin/env bash
# ==============================================================================
# ZBridge Installer (zb-installer.sh)
# Role: Deploys Python Receiver to Phone (Reliability Optimized)
# Protocol: Heartbeats + Soft Restart + Passive Mode
# ==============================================================================

PHONE_IP=$1
[[ -z "$PHONE_IP" ]] && { echo "Usage: $0 <PHONE_IP>"; exit 1; }

echo ":: Connecting to $PHONE_IP..."
adb connect "$PHONE_IP"
adb -s "$PHONE_IP" wait-for-device

# --- 1. Generate Python Payload (Updated Logic) ---
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

# Constants: Timeouts
PING_INTERVAL = 1.0
TIMEOUT_SEC = 4.0
MAX_RETRIES = 5

# State
pc_ip = None
running = True
gst_process = None
current_session_id = None

# Connection State
last_ack_time = 0
retry_count = 0
is_passive_mode = False

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
        print(":: [Recv] Stopping GStreamer...")
        gst_process.terminate()
        try:
            gst_process.wait(timeout=1)
        except:
            gst_process.kill()
        gst_process = None

# --- Main Loop ---
print(":: [Recv] ZBridge Receiver Started (Protocol V2)")

pc_ip = load_cached_ip()
if pc_ip:
    print(f":: [Recv] Loaded cached PC IP: {pc_ip}")

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
try:
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 131072)
except: pass 

sock.bind(('0.0.0.0', UDP_LISTEN))
sock.settimeout(1.0) 

last_ping_sent = 0

while running:
    current_time = time.time()
    
    # --- 1. SEND PING (If Active) ---
    if pc_ip and not is_passive_mode:
        if current_time - last_ping_sent > PING_INTERVAL:
            try:
                sock.sendto(b"PING", (pc_ip, UDP_SEND))
                last_ping_sent = current_time
            except Exception as e:
                print(f":: [Error] Ping failed: {e}")

    # --- 2. LISTEN ---
    try:
        data, addr = sock.recvfrom(1024)
        msg = data.decode('utf-8').strip()
        sender_ip = addr[0]

        if "SYNC" in msg:
            # Wake Up Call from PC
            new_ip = msg.split(':')[1] if ':' in msg else sender_ip
            print(f":: [Recv] SYNC (Wake Up) from {new_ip}")
            pc_ip = new_ip
            save_ip(pc_ip)
            
            # Reset State
            is_passive_mode = False
            retry_count = 0
            last_ack_time = current_time # Treat sync as ack
            
            # Immediate Response
            sock.sendto(b"PING", (pc_ip, UDP_SEND))
            
        elif "PONG" in msg or "ACK" in msg:
            # Heartbeat Response
            last_ack_time = current_time
            retry_count = 0
            
            # Session Check
            parts = msg.split(':')
            received_sid = parts[1] if len(parts) > 1 else "legacy"
            
            if received_sid != "legacy" and received_sid != current_session_id:
                print(f":: [Recv] New Session ({received_sid}). Resyncing...")
                stop_gst()
                current_session_id = received_sid
            
            start_gst()
            
        elif "BYE" in msg:
            print(":: [Recv] Server Shutdown (BYE). Going Passive.")
            stop_gst()
            is_passive_mode = True

    except socket.timeout:
        pass
    except Exception as e:
        print(f":: [Error] Loop error: {e}")

    # --- 3. WATCHDOG ---
    if pc_ip and not is_passive_mode:
        if current_time - last_ack_time > TIMEOUT_SEC:
            # Timeout detected
            if gst_process:
                print(":: [Recv] Connection Lost (Timeout). Stopping Audio.")
                stop_gst()
            
            if retry_count < MAX_RETRIES:
                retry_count += 1
                print(f":: [Recv] Retry attempt {retry_count}/{MAX_RETRIES}...")
                # We will send PING on next loop iteration
            else:
                print(":: [Recv] Max retries reached. Entering PASSIVE mode.")
                is_passive_mode = True
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

echo ":: DONE. Re-run zl-config to connect."
rm zb_receiver.py zreceiver_setup.sh

echo ":: IMPORTANT! if you see a \"java.lang.SecurityException\" enable \"USB Debugging (Security Settings)\"."