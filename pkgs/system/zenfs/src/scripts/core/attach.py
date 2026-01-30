# File: src/scripts/core/attach.py
import sys
import json
import shutil
import time
import subprocess
from pathlib import Path
from common import run_command, notify, LIVE_TEMP, ROAMING_ROOT, get_system_uuid
from db_builder import rebuild_drive_db

def attach(dev_node):
    dev_name = Path(dev_node).name
    dev_full_path = Path(f"/dev/{dev_name}").resolve()
    
    # 0. Check Pre-existing Mounts (Skip Root/Already Mounted)
    try:
        # findmnt lists where this source device is mounted
        res = subprocess.run(
            ["findmnt", "-n", "--source", str(dev_full_path), "-o", "TARGET"], 
            capture_output=True, text=True
        )
        existing_mounts = [m for m in res.stdout.strip().split('\n') if m]
        
        for mnt in existing_mounts:
            if mnt == "/":
                print(f"Skipping {dev_name}: Is System Root.")
                return
            if mnt.startswith("/Mount/Roaming"):
                print(f"Skipping {dev_name}: Already attached at {mnt}.")
                return
            # If mounted somewhere else critical (like /home not via ZenFS), skip
            if not mnt.startswith("/Live/Temp") and not mnt.startswith("/Mount"):
                print(f"Skipping {dev_name}: In use at {mnt}.")
                return
    except Exception:
        # If findmnt fails (e.g. not mounted), we proceed
        pass

    temp_mount = LIVE_TEMP / get_system_uuid() / dev_name
    temp_mount.mkdir(parents=True, exist_ok=True)
    
    try:
        # 1. Mount to Live/Temp if not already mounted
        if not any(p.mountpoint == str(temp_mount) for p in shutil.disk_usage(str(temp_mount)) if p.mountpoint == str(temp_mount)):
             run_command(f"mount /dev/{dev_name} {temp_mount}")
        
        # 2. Validation Logic
        json_path = temp_mount / "System/ZenFS/drive.json"
        zenfs_structure = temp_mount / "System/ZenFS"
        valid = False
        uuid = None
        drive_type = "roaming"
        
        if json_path.exists():
            try:
                data = json.load(open(json_path))
                if "uuid" in data: 
                    u = data["uuid"]
                    # Validation: Must be 16 chars and alphanumeric
                    if isinstance(u, str) and len(u) == 16 and u.isalnum():
                        valid = True
                        uuid = u
                        drive_type = data.get("type", "roaming")
            except: pass
        
        # 3. Self Healing: Stricter Heuristic
        if not valid and zenfs_structure.exists() and zenfs_structure.is_dir():
             print(f"Healing invalid ZenFS drive {dev_name} (Found /System/ZenFS structure)...")
             from common import generate_zenfs_uuid
             uuid = generate_zenfs_uuid()
             
             data = {
                 "uuid": uuid, 
                 "label": "RestoredDrive", 
                 "type": "roaming", 
                 "createdAt": int(time.time())
             }
             json_path.parent.mkdir(parents=True, exist_ok=True)
             with open(json_path, "w") as f: json.dump(data, f)
             rebuild_drive_db(temp_mount, uuid)
             valid = True
             drive_type = "roaming"

        # 4. Bind to Roaming (Only if NOT a system drive)
        if valid:
            if drive_type == "system":
                print(f"Validated System Drive {uuid}. Skipping bind mount.")
                run_command(f"umount {temp_mount}")
                try: temp_mount.rmdir() 
                except: pass
                run_command("zenfs roaming")
            else:
                target = ROAMING_ROOT / uuid
                target.mkdir(parents=True, exist_ok=True)
                
                # Double check target isn't already mounted (idempotency)
                if not any(p.mountpoint == str(target) for p in shutil.disk_usage(str(target)) if p.mountpoint == str(target)):
                    run_command(f"mount --bind {temp_mount} {target}")
                    notify("ZenFS", f"Attached {uuid}")
                    run_command("zenfs roaming")
        else:
            run_command(f"umount {temp_mount}")
            try: temp_mount.rmdir() 
            except: pass

    except Exception as e:
        print(f"Attach failed on {dev_name}: {e}")
        # Only cleanup if we actually mounted it and failed mid-way
        if temp_mount.exists():
             try: run_command(f"umount {temp_mount}")
             except: pass