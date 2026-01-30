#!/usr/bin/env python3
import os
import sys
import time
import json
import logging
import shutil
import subprocess
import glob

# --- Configuration Constants ---
CONFIG_DIR = "/System/ZenClean"
LOG_DIR = "/System/Logs"
STATE_FILE = os.path.join(CONFIG_DIR, "state.json")
CONFIG_FILE = os.path.join(CONFIG_DIR, "config.json")
LOG_FILE = os.path.join(LOG_DIR, "zenos_maintenance.log")

# Ensure directories exist
for path in [CONFIG_DIR, LOG_DIR]:
    if not os.path.exists(path):
        os.makedirs(path, mode=0o755, exist_ok=True)

# Setup Logging
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
console = logging.StreamHandler()
console.setLevel(logging.INFO)
logging.getLogger('').addHandler(console)

class ZenMaintainer:
    def __init__(self):
        self.config = self.load_config()
        self.state = self.load_state()
        self.inhibit_fd = None
        self.inhibit_process = None

    def load_config(self):
        defaults = {
            "garbage_age": "14d",
            "notification_freq_days": 7,
            "update_command": "nixos-rebuild switch --upgrade"
        }
        if os.path.exists(CONFIG_FILE):
            try:
                with open(CONFIG_FILE, 'r') as f:
                    user_config = json.load(f)
                    defaults.update(user_config)
            except Exception as e:
                logging.error(f"Failed to load config: {e}")
        return defaults

    def load_state(self):
        defaults = {
            "last_run": 0,
            "first_run_notified": False
        }
        if os.path.exists(STATE_FILE):
            try:
                with open(STATE_FILE, 'r') as f:
                    saved = json.load(f)
                    defaults.update(saved)
            except Exception as e:
                logging.error(f"Failed to load state: {e}")
        return defaults

    def save_state(self):
        try:
            with open(STATE_FILE, 'w') as f:
                json.dump(self.state, f, indent=4)
        except Exception as e:
            logging.error(f"Failed to save state: {e}")

    # --- Notification System ---
    def get_active_user(self):
        """Attempts to find the primary active user to send notifications to."""
        try:
            result = subprocess.run(['loginctl', 'list-sessions', '--no-legend'], capture_output=True, text=True)
            for line in result.stdout.splitlines():
                parts = line.split()
                if len(parts) >= 3:
                    user_id = parts[2]
                    try:
                        uid = int(subprocess.run(['id', '-u', user_id], capture_output=True, text=True).stdout.strip())
                        if uid >= 1000:
                            return user_id, uid
                    except:
                        continue
        except Exception as e:
            logging.error(f"Error finding active user: {e}")
        return None, None

    def notify(self, title, body, urgency='normal'):
        """Sends a notification to the active user's desktop."""
        user, uid = self.get_active_user()
        if not user:
            logging.warning("No active user found to notify.")
            return

        logging.info(f"Sending notification to {user}: {title}")
        
        dbus_address = f"unix:path=/run/user/{uid}/bus"
        
        cmd = [
            'sudo', '-u', user,
            'env', f'DBUS_SESSION_BUS_ADDRESS={dbus_address}',
            'notify-send', 
            '-u', urgency,
            '-i', 'zenos-symbolic',
            '-a', 'ZenOS Maintenance',
            title, body
        ]
        
        try:
            subprocess.run(cmd, check=False)
        except Exception as e:
            logging.error(f"Notification failed: {e}")

    # --- Idle Detection ---
    def is_system_idle(self, idle_threshold_seconds=300):
        # 1. Load Average Check
        load_1, _, _ = os.getloadavg()
        if load_1 > 1.5:
            logging.debug(f"System busy (Load: {load_1})")
            return False

        # 2. Input Device Check (Root Only)
        last_input_time = 0
        try:
            input_devices = glob.glob("/dev/input/event*")
            for dev in input_devices:
                try:
                    stats = os.stat(dev)
                    last_input_time = max(last_input_time, stats.st_atime, stats.st_mtime)
                except:
                    pass
            
            time_since_input = time.time() - last_input_time
            if time_since_input < idle_threshold_seconds:
                logging.debug(f"User active (Input detected {int(time_since_input)}s ago)")
                return False
                
        except Exception as e:
            logging.warning(f"Failed to check input devices: {e}")
            pass

        return True

    # --- Sleep Inhibition ---
    def inhibit_sleep(self):
        if self.inhibit_process:
            return 

        logging.info("Inhibiting system sleep...")
        try:
            self.inhibit_process = subprocess.Popen(
                ['systemd-inhibit', '--what=sleep', '--who=ZenOS', '--why=System Maintenance', '--mode=block', 'sleep', 'infinity']
            )
            logging.info("Sleep inhibited.")
        except Exception as e:
            logging.error(f"Failed to inhibit sleep: {e}")

    def release_inhibit(self):
        if self.inhibit_process:
            logging.info("Releasing sleep inhibition...")
            self.inhibit_process.terminate()
            self.inhibit_process = None

    # --- Core Tasks ---
    def perform_maintenance(self):
        logging.info("Starting maintenance routine...")
        
        # 1. Update Packages
        logging.info("Updating NixOS packages...")
        try:
            cmd = self.config['update_command'].split()
            subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            logging.info("Update successful.")
        except subprocess.CalledProcessError as e:
            logging.error(f"Update failed: {e.stderr.decode() if e.stderr else 'Unknown error'}")

        # 2. Collect Garbage
        logging.info(f"Collecting garbage (older than {self.config['garbage_age']})...")
        try:
            subprocess.run(
                ['nix-collect-garbage', '--delete-older-than', self.config['garbage_age']], 
                check=True
            )
        except Exception as e:
            logging.error(f"Garbage collection failed: {e}")

        # 3. Optimize Store
        logging.info("Optimizing Nix store...")
        try:
            subprocess.run(['nix-store', '--optimise'], check=True)
        except Exception as e:
            logging.error(f"Optimization failed: {e}")

        # 4. Clean Logs
        self.clean_old_logs()

        # Update State
        self.state['last_run'] = time.time()
        self.save_state()
        logging.info("Maintenance routine completed.")
        
        self.notify("ZenOS Maintenance", "System optimization and cleanup complete.")

    def clean_old_logs(self):
        logging.info("Cleaning old logs...")
        now = time.time()
        cutoff = 30 * 86400
        try:
            for f in os.listdir(LOG_DIR):
                fpath = os.path.join(LOG_DIR, f)
                if os.path.isfile(fpath):
                    if os.stat(fpath).st_mtime < (now - cutoff):
                        os.remove(fpath)
                        logging.info(f"Deleted old log: {f}")
        except Exception as e:
            logging.error(f"Log cleanup failed: {e}")

    # --- Main Logic ---
    def run_check_loop(self):
        days_since_run = (time.time() - self.state['last_run']) / 86400
        if days_since_run > self.config['notification_freq_days'] and self.state['last_run'] > 0:
             self.notify(
                 "Maintenance Required", 
                 f"System has not been optimized in {int(days_since_run)} days. Please leave your device idle soon.",
                 urgency='critical'
             )

        if days_since_run < 1.0:
            logging.info("Maintenance already ran in the last 24h. Exiting.")
            sys.exit(0)

        if not self.state['first_run_notified']:
            self.notify(
                "ZenOS Maintenance Initialized",
                "I will automatically optimize your system when you leave it idle.",
                urgency='normal'
            )
            self.state['first_run_notified'] = True
            self.save_state()

        logging.info("Maintenance due. Entering idle wait loop.")
        
        self.inhibit_sleep()
        
        wait_start = time.time()
        max_wait = 3600 * 4 
        idle_counter = 0
        required_idle_ticks = 10 
        
        try:
            while True:
                if self.is_system_idle():
                    idle_counter += 1
                    logging.debug(f"Idle tick {idle_counter}/{required_idle_ticks}")
                else:
                    idle_counter = 0
                
                if idle_counter >= required_idle_ticks:
                    break
                
                time.sleep(30)
                
                if (time.time() - wait_start) > max_wait:
                    logging.warning("Timed out waiting for idle. Aborting maintenance.")
                    self.release_inhibit()
                    sys.exit(0)

            self.perform_maintenance()

        finally:
            self.release_inhibit()

def main():
    maintainer = ZenMaintainer()
    
    if len(sys.argv) > 1:
        mode = sys.argv[1]
        if mode == "--shutdown":
            logging.info("Running shutdown cleanup...")
            subprocess.run(['nix-collect-garbage', '--delete-older-than', maintainer.config['garbage_age']])
            return
        elif mode == "--reboot":
            logging.info("Running reboot cleanup...")
            subprocess.run(['nix-collect-garbage', '--delete-older-than', maintainer.config['garbage_age']])
            return

    maintainer.run_check_loop()

if __name__ == "__main__":
    main()