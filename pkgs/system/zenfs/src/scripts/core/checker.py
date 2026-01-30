# File: src/scripts/core/checker.py
import os
import multiprocessing
from pathlib import Path
from common import run_command

def check_device(dev_name):
    """Worker function to attach a single device."""
    print(f"Checking {dev_name}...")
    try:
        run_command(f"zenfs attach {dev_name}")
    except Exception as e:
        # Fail silently to avoid journal spam on non-ZenFS drives
        pass

def main():
    print("ZenFS Checker: Scanning block devices (Parallel)...")
    dev_root = Path("/dev")
    devices = []
    
    # Scan for sd* (SATA/USB) and nvme* (NVMe) block devices
    for item in dev_root.iterdir():
        name = item.name
        if (name.startswith("sd") or name.startswith("nvme")) and name[-1].isdigit():
            devices.append(name)
    
    if not devices: return

    # Use multiprocessing to attach drives in parallel to speed up boot
    count = min(len(devices), os.cpu_count() or 4)
    with multiprocessing.Pool(processes=count) as pool:
        pool.map(check_device, devices)