#!/usr/bin/env python3

import socket
import time
import subprocess
import os
import signal
import sys
import json
import threading
import logging
import argparse
from logging.handlers import SysLogHandler

# --- Configuration ---
CONFIG_DIR = os.path.expanduser("~/.config/zenlink")
CONFIG_FILE = os.path.join(CONFIG_DIR, "state.conf")
READY_FLAG = "/tmp/zenlink_ready"
CONFIG_PID_FILE = "/tmp/zenlink_config_pid"
LOG_TAG = "zenlink-daemon"

UDP_PORT_LISTEN = 5001
UDP_PORT_SEND = 5002

# Globals
running = True
current_state = "DISCONNECTED"
phone_ip = ""
last_heartbeat = 0
gst_process = None
scrcpy_process = None
placeholder_process = None
current_scrcpy_cmd = [] 
session_id = str(int(time.time())) 
lock = threading.Lock()
scrcpy_last_crash = 0

# Gain State
current_mic_gain = "1.0"
current_audio_gain = "1.0"

# Track loopback processes to prevent infinite spawning
virtual_sinks = {} 

# Args
args = None

# Setup Logging
logger = logging.getLogger(LOG_TAG)
logger.setLevel(logging.INFO)
try:
    syslog = SysLogHandler(address='/dev/log')
    formatter = logging.Formatter('%(name)s: [%(levelname)s] %(message)s')
    syslog.setFormatter(formatter)
    logger.addHandler(syslog)
except: pass 
console = logging.StreamHandler()
formatter = logging.Formatter('%(name)s: [%(levelname)s] %(message)s')
console.setFormatter(formatter)
logger.addHandler(console)

def log(msg):
    logger.info(msg)

def error(msg):
    logger.error(msg)

# --- Helpers ---

def get_local_ip_for_target(target_ip):
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect((target_ip, 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return None

def read_config():
    config = {}
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as f:
            for line in f:
                if '=' in line:
                    key, val = line.strip().split('=', 1)
                    config[key] = val.strip('"')
    return config

def get_node_id(node_name):
    try:
        output = subprocess.check_output(["pw-dump", "Node"], stderr=subprocess.DEVNULL)
        nodes = json.loads(output)
        for node in nodes:
            if node.get("info", {}).get("props", {}).get("node.name") == node_name:
                return str(node["id"])
    except Exception as e:
        pass
    return None

def run_command(cmd_list, bg=False):
    try:
        if bg:
            return subprocess.Popen(cmd_list, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        else:
            subprocess.run(cmd_list, check=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            return None
    except Exception as e:
        error(f"Command failed: {cmd_list} -> {e}")
        return None

def set_pactl_volume(node_name, gain_str):
    """
    Safely sets volume using pactl if available.
    Expects gain_str like "1.5" (150%).
    """
    try:
        gain_float = float(gain_str)
        pct = int(gain_float * 100)
        # Use set-sink-volume because zlin_void is a Null Sink
        subprocess.run(["pactl", "set-sink-volume", node_name, f"{pct}%"], 
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except Exception as e:
        # If pactl is missing or fails, we fail silently to preserve robustness
        pass

def send_notification(title, message):
    try:
        subprocess.Popen(["notify-send", "-a", "zerobridge", "-u", "critical", "-i", "phone", title, message])
    except Exception as e:
        error(f"Failed to send notification: {e}")

def get_camera_icon_path():
    search_paths = [
        "/usr/share/icons/Adwaita/symbolic/status",
        "/usr/share/icons/Adwaita/scalable/status",
        "/usr/share/icons/hicolor/symbolic/status",
        "/usr/share/icons/hicolor/scalable/status",
        "/usr/share/icons/Papirus/symbolic/status"
    ]
    target_names = ["camera-disabled-symbolic.svg", "camera-off-symbolic.svg", "camera-web-off-symbolic.svg"]
    
    for path in search_paths:
        if os.path.isdir(path):
            for name in target_names:
                full_path = os.path.join(path, name)
                if os.path.exists(full_path):
                    return full_path
    return None

def ensure_adb_connection(target_ip):
    try:
        output = subprocess.check_output(["adb", "devices"], text=True)
        if target_ip in output:
            return True
        log(f":: [Daemon] ADB not connected to {target_ip}. Connecting...")
        res = subprocess.run(["adb", "connect", target_ip], timeout=5, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if "connected to" in res.stdout:
            log(f":: [Daemon] ADB Connected: {res.stdout.strip()}")
            return True
        else:
            error(f":: [Daemon] ADB Connect Failed: {res.stdout.strip()}")
            return False
    except Exception as e:
        error(f":: [Daemon] ADB Error: {e}")
        return False

def spawn_loopback_sink(node_name, description, target_node):
    global virtual_sinks

    client_name = f"zenlink_loopback_{node_name}"

    if node_name in virtual_sinks:
        proc = virtual_sinks[node_name]
        if proc.poll() is None:
            return 
        else:
            log(f":: [Daemon] Virtual Sink {node_name} died unexpectedly. Respawning...")
            del virtual_sinks[node_name]

    if subprocess.run(["pgrep", "-f", f"pw-loopback.*--name {client_name}"], stdout=subprocess.DEVNULL).returncode == 0:
        subprocess.run(["pkill", "-f", f"pw-loopback.*--name {client_name}"])
        time.sleep(0.2)

    log(f":: [Daemon] Spawning Virtual Sink: {node_name} -> {target_node}")
    
    capture_props = {
        "media.class": "Audio/Sink",
        "node.name": node_name,
        "node.description": description,
        "audio.position": ["FL", "FR"]
    }
    
    playback_props = {
        "node.target": target_node,
        "audio.position": ["FL", "FR"],
        "node.dont-reconnect": True
    }
    
    cmd = [
        "pw-loopback",
        "--name", client_name, 
        "--capture-props", json.dumps(capture_props),
        "--playback-props", json.dumps(playback_props)
    ]
    
    virtual_sinks[node_name] = subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def setup_audio_graph():
    # 1. Create Internal VOID nodes
    void_nodes = ["zlout_void", "zbin_void", "zmic"]
    void_descs = ["zenlink_Out_Internal", "zenlink_In_Internal", "ZeroBridge_Microphone"]
    void_types = ["Audio/Sink", "Audio/Sink", "Audio/Source/Virtual"]
    
    for i, node in enumerate(void_nodes):
        if not get_node_id(node):
            cmd = [
                "pw-cli", "create-node", "adapter",
                "factory.name=support.null-audio-sink",
                f"node.name={node}",
                f"media.class={void_types[i]}",
                f"node.description={void_descs[i]}",
                "object.linger=true"
            ]
            run_command(cmd)
    
    time.sleep(0.5)

    # 2. Spawn Loopback Sinks
    spawn_loopback_sink("zlout", "ZeroBridge_To_Phone", "zbout_void")
    spawn_loopback_sink("zlin", "ZeroBridge_Phone_Mic", "zbin_void")

    # 3. Enforce Routing (Reverted to Safe pw-link Logic)
    try:
        # A. Link zlin_void -> zmic (Restored)
        run_command(["pw-link", "zlin_void:monitor_FL", "zmic:input_FL"])
        run_command(["pw-link", "zlin_void:monitor_FR", "zmic:input_FR"])

        # B. Route Scrcpy/SDL to zlin
        sources = ["SDL Application", "scrcpy"]
        for src in sources:
            run_command(["pw-link", f"{src}:output_FL", "zlin:playback_FL"])
            run_command(["pw-link", f"{src}:output_FR", "zlin:playback_FR"])
            
            # Anti-Feedback
            run_command(["pw-link", "-d", f"{src}:output_FL", "zlout:playback_FL"])
            run_command(["pw-link", "-d", f"{src}:output_FR", "zlout:playback_FR"])

        # C. Loopback Cleanups
        run_command(["pw-link", "-d", "output.zenlink_Monitor:output_FL", "zlout:playback_FL"])
        run_command(["pw-link", "-d", "output.zenlink_Monitor:output_FR", "zlout:playback_FR"])
        
        # Anti-Feedback for Desktop Capture
        run_command(["pw-link", "-d", "zmic:capture_FL", "input.zenlink_Desktop:input_FL"])
        run_command(["pw-link", "-d", "zmic:capture_FR", "input.zenlink_Desktop:input_FR"])
    except:
        pass

def manage_loopback(name, active, source=None, sink=None):
    is_running = subprocess.run(["pgrep", "-f", f"pw-loopback.*--name {name}"], stdout=subprocess.DEVNULL).returncode == 0
    if active == "on" and not is_running:
        log(f"Enabling Loopback: {name}")
        cmd = ["pw-loopback", "--name", name]
        if source and source != "0": cmd.append(f"--capture-props={{ \"node.target\": \"{source}\" }}")
        if sink and sink != "0": cmd.append(f"--playback-props={{ \"node.target\": \"{sink}\" }}")
        subprocess.Popen(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    elif active != "on" and is_running:
        log(f"Disabling Loopback: {name}")
        run_command(["pkill", "-f", f"pw-loopback.*--name {name}"])

def handle_reload(signum, frame):
    log(":: [Daemon] Reload signal (SIGUSR1). Parsing config... ::")
    if os.path.exists(CONFIG_PID_FILE):
        try:
            with open(CONFIG_PID_FILE, 'r') as f:
                pid = int(f.read().strip())
            os.kill(pid, signal.SIGUSR2)
        except Exception as e:
            error(f"Failed to ACK zl-config: {e}")
        finally:
            try: os.remove(CONFIG_PID_FILE)
            except: pass

# --- Threads ---

def network_listener():
    global current_state, last_heartbeat, phone_ip, session_id
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_RCVBUF, 262144)
    sock.bind(('0.0.0.0', UDP_PORT_LISTEN))
    sock.settimeout(1.0)
    
    log(f"Listening on UDP {UDP_PORT_LISTEN}...")
    
    while running:
        try:
            data, addr = sock.recvfrom(1024)
            msg = data.decode('utf-8').strip()
            if "READY" in msg:
                with lock:
                    last_heartbeat = time.time()
                    if current_state != "CONNECTED":
                        log(f"Handshake received from {addr[0]}. Connected.")
                        current_state = "CONNECTED"
                        with open(READY_FLAG, 'w') as f: f.write("1")
                    
                    ack_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                    ack_msg = f"ACK:{session_id}"
                    ack_sock.sendto(ack_msg.encode('utf-8'), (addr[0], UDP_PORT_SEND))
        except socket.timeout: pass
        except Exception as e:
            error(f"Listener Error: {e}")
            time.sleep(1)

def connection_manager():
    global current_state, gst_process, scrcpy_process, placeholder_process, phone_ip, last_heartbeat 
    global current_scrcpy_cmd, scrcpy_last_crash
    global current_mic_gain, current_audio_gain
    
    start_time = time.time()
    startup_notified = False

    while running:
        setup_audio_graph()
        cfg = read_config()
        
        new_ip = cfg.get("PHONE_IP", "")
        monitor = cfg.get("MONITOR", "off")
        desktop = cfg.get("DESKTOP", "off")
        cam_facing = cfg.get("CAM_FACING", "back")
        cam_orient = cfg.get("CAM_ORIENT", "")
        def_front = cfg.get("DEF_ORIENT_FRONT", "flip90")
        def_back = cfg.get("DEF_ORIENT_BACK", "flip270")
        
        # Gain Updates
        new_mic_gain = cfg.get("MIC_GAIN", "1.0")
        new_audio_gain = cfg.get("AUDIO_GAIN", "1.0")
        
        # Apply Mic Gain via Pactl (Does not require graph restart)
        if new_mic_gain != current_mic_gain:
            log(f":: [Daemon] Mic Gain changing: {current_mic_gain} -> {new_mic_gain}")
            current_mic_gain = new_mic_gain
            set_pactl_volume("zlin_void", current_mic_gain)

        # Apply Audio Gain (Requires Stream Restart)
        if new_audio_gain != current_audio_gain:
            log(f":: [Daemon] Audio Out Gain changing: {current_audio_gain} -> {new_audio_gain}")
            current_audio_gain = new_audio_gain
            if gst_process: 
                gst_process.terminate()
                gst_process = None

        if new_ip != phone_ip:
            log(f"Target IP Changed: {new_ip}")
            phone_ip = new_ip
            current_state = "DISCONNECTED"
            if gst_process: gst_process.terminate(); gst_process = None
            if scrcpy_process: scrcpy_process.terminate(); scrcpy_process = None
            if placeholder_process: placeholder_process.terminate(); placeholder_process = None
            if os.path.exists(READY_FLAG): os.remove(READY_FLAG)

        manage_loopback("zenlink_Monitor", monitor, "zmic", "0")
        manage_loopback("zenlink_Desktop", desktop, "0", "zlout")

        target_ip_clean = phone_ip.split(':')[0]
        if not target_ip_clean or target_ip_clean == "127.0.0.1":
            time.sleep(1)
            continue

        # if current_state == "CONNECTED" and (time.time() - last_heartbeat > 10):
        #     log("Heartbeat timed out.")
        #     current_state = "DISCONNECTED"
        #     if os.path.exists(READY_FLAG): os.remove(READY_FLAG)
        #     if gst_process: gst_process.terminate(); gst_process = None
        #     if scrcpy_process: scrcpy_process.terminate(); scrcpy_process = None
        #     if placeholder_process: placeholder_process.terminate(); placeholder_process = None

        if current_state == "DISCONNECTED":
            if args.debug_notify and not startup_notified and (time.time() - start_time > 5.0):
                send_notification("ZeroBridge", "No response from phone. Run sv restart zreceiver in termux.")
                startup_notified = True
            
            my_ip = get_local_ip_for_target(target_ip_clean)
            if my_ip:
                try:
                    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                    sock.sendto(f"SYNC:{my_ip}".encode('utf-8'), (target_ip_clean, UDP_PORT_SEND))
                except: pass
            time.sleep(1)

        elif current_state == "CONNECTED":
            startup_notified = True 
            
            # --- AUDIO STREAM (PC -> Phone) ---
            if desktop == "on":
                if gst_process is None or gst_process.poll() is not None:
                    zlout_void_id = get_node_id("zbout_void")
                    if zlout_void_id:
                        log(f"Starting Stream -> {target_ip_clean}:5000 (Gain: {current_audio_gain})")
                        cmd = [
                            "gst-launch-1.0", "-q", 
                            "pipewiresrc", f"path={zlout_void_id}", "do-timestamp=true", "!",
                            "audioconvert", "!",
                            "volume", f"volume={current_audio_gain}", "!",
                            "opusenc", "bitrate=96000", "audio-type=voice", "frame-size=10",
                            "inband-fec=true", "packet-loss-percentage=10", "!",
                            "rtpopuspay", "!",
                            "udpsink", f"host={target_ip_clean}", "port=5000", "sync=false", "async=false"
                        ]
                        gst_process = subprocess.Popen(cmd)
            elif desktop == "off":
                if gst_process:
                    log(":: [Daemon] Stopping Audio Stream (Desktop disabled)...")
                    gst_process.terminate()
                    gst_process = None
            
            # --- VIDEO / PLACEHOLDER LOGIC ---
            target_cmd = ["scrcpy", "--serial", phone_ip, "--no-window"]
            
            if monitor == "on":
                target_cmd += ["--audio-source=mic", "--audio-codec=opus", "--audio-bit-rate=128K"]
            else:
                target_cmd += ["--no-audio"]
            
            if cam_facing == "none":
                target_cmd += ["--no-video"]
            else:
                target_cmd.append("--camera-fps=30")
                safe_cam = cam_facing if cam_facing in ["front", "back"] else "back"
                final_orient = cam_orient if cam_orient else (def_front if safe_cam == "front" else def_back)
                target_cmd += ["--video-source=camera", f"--camera-facing={safe_cam}", f"--capture-orientation={final_orient}"]
                if os.path.exists("/dev/video9"):
                    target_cmd += ["--v4l2-sink=/dev/video9"]
            
            if scrcpy_process and current_scrcpy_cmd and target_cmd != current_scrcpy_cmd:
                log(":: [Daemon] Scrcpy config changed. Hot-swapping...")
                scrcpy_process.terminate()
                try: scrcpy_process.wait(timeout=2)
                except: scrcpy_process.kill()
                scrcpy_process = None
                log(":: [Daemon] Safety Pause (1.0s) for Camera HAL...")
                time.sleep(1.0) 

            use_placeholder = (cam_facing == "none" and os.path.exists("/dev/video9"))
            if use_placeholder:
                if not placeholder_process or placeholder_process.poll() is not None:
                    log(":: [Daemon] Starting Placeholder Stream...")
                    icon_path = get_camera_icon_path()
                    gst_cmd = ["gst-launch-1.0", "videotestsrc", "pattern=black", "!", "video/x-raw,width=1920,height=1080,framerate=30/1"]
                    if icon_path:
                        gst_cmd += ["!", "gdkpixbufoverlay", f"location={icon_path}", "overlay-height=300", "overlay-width=300"]
                    else:
                        gst_cmd += ["!", "textoverlay", "text=CAMERA DISABLED", "valignment=center", "halignment=center", "font-desc=Sans 40"]
                    gst_cmd += ["!", "v4l2sink", "device=/dev/video9"]
                    placeholder_process = subprocess.Popen(gst_cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            else:
                if placeholder_process:
                    placeholder_process.terminate()
                    try: placeholder_process.wait(timeout=1)
                    except: placeholder_process.kill()
                    placeholder_process = None

            if scrcpy_process and scrcpy_process.poll() is not None:
                scrcpy_last_crash = time.time()
                _, err = scrcpy_process.communicate()
                error(f"Scrcpy CRASHED. Stderr: {err}")
                scrcpy_process = None

            if scrcpy_process is None or scrcpy_process.poll() is not None:
                if time.time() - scrcpy_last_crash < 3.0:
                    pass 
                else:
                    if ensure_adb_connection(phone_ip):
                        log(f"Starting Scrcpy ({cam_facing})...")
                        env = os.environ.copy()
                        scrcpy_process = subprocess.Popen(target_cmd, env=env, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True)
                        current_scrcpy_cmd = target_cmd
            
            # Initial Gain Set for fresh loops
            if current_state == "CONNECTED" and time.time() % 5 < 0.6:
                set_pactl_volume("zlin_void", current_mic_gain)

        time.sleep(0.5)

def cleanup_handler(signum, frame):
    global running
    log("Shutting down...")
    running = False
    if gst_process: gst_process.terminate()
    if scrcpy_process: scrcpy_process.terminate()
    if placeholder_process: placeholder_process.terminate()
    if os.path.exists(READY_FLAG): os.remove(READY_FLAG)
    subprocess.run(["pkill", "-f", "pw-loopback.*--name zenlink_"])
    for name, proc in virtual_sinks.items():
        if proc.poll() is None: proc.terminate()
    subprocess.run(["pkill", "-f", "pw-loopback.*zenlink_loopback_"])
    sys.exit(0)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="ZeroBridge Daemon")
    parser.add_argument("-d", "--debug-notify", action="store_true", help="Send desktop notification if no handshake in 5s")
    args = parser.parse_args()

    signal.signal(signal.SIGINT, cleanup_handler)
    signal.signal(signal.SIGTERM, cleanup_handler)
    signal.signal(signal.SIGUSR1, handle_reload)
    
    if not os.path.exists(CONFIG_DIR): os.makedirs(CONFIG_DIR)
    
    t = threading.Thread(target=network_listener, daemon=True)
    t.start()
    
    connection_manager()