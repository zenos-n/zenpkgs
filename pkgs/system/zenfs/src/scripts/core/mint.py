# File: src/scripts/core/mint.py
import sys
import time
import json
from pathlib import Path
from common import generate_zenfs_uuid, run_command, notify
from db_builder import rebuild_drive_db

def mint(device, label, drive_type="roaming"):
    print(f"Minting {device} as {drive_type}...")
    temp_mount = Path("/tmp/zenfs_mint")
    temp_mount.mkdir(exist_ok=True)
    
    try:
        run_command(f"mount {device} {temp_mount}")
        
        uuid_str = generate_zenfs_uuid()
        data = {
            "uuid": uuid_str,
            "label": label,
            "type": drive_type,
            "createdAt": int(time.time())
        }
        
        json_path = temp_mount / "System/ZenFS/drive.json"
        json_path.parent.mkdir(parents=True, exist_ok=True)
        
        with open(json_path, "w") as f:
            json.dump(data, f, indent=2)
            
        # Immediately build DB so the drive is ready for use
        rebuild_drive_db(temp_mount, uuid_str)
            
        print(f"Drive minted with UUID: {uuid_str}")
        notify("ZenFS Mint", f"Minted {label}")
        
    except Exception as e:
        print(f"Mint error: {e}")
        notify("ZenFS Error", f"Mint failed: {e}")
    finally:
        run_command(f"umount {temp_mount}")