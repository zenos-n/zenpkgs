# File: src/scripts/core/offload.py
import sys
import shutil
import psutil
import json
import logging
from pathlib import Path
from common import ROAMING_ROOT, DB_ROOT, get_system_uuid, run_command

logging.basicConfig(level=logging.INFO)

def get_disk_usage_percent(path):
    try:
        return psutil.disk_usage(str(path)).percent
    except:
        return 100.0

def get_candidates(user_home):
    """
    Identifies files to offload. 
    Strategy: Largest files first? Oldest? 
    For now: Largest files in /home that are NOT symlinks (i.e. real local files).
    """
    candidates = []
    # Walk real home (resolve /Users symlink if needed, though usually /home is the target)
    # We assume the script runs as root or has access.
    # Note: In FUSE mode, /Users is virtual. We must scan the underlying storage (/home).
    
    # We need to find where the "Main Drive" storage for users is.
    # Usually /home.
    search_root = Path("/home") 
    
    for p in search_root.rglob("*"):
        if p.is_file() and not p.is_symlink():
            try:
                size = p.stat().st_size
                # Filter small files to avoid thrashing? > 50MB
                if size > 50 * 1024 * 1024: 
                    candidates.append((p, size))
            except: pass
    
    # Sort by size descending
    candidates.sort(key=lambda x: x[1], reverse=True)
    return [x[0] for x in candidates]

def find_target_drive(roaming_root, safe_limit):
    """
    Logic:
    1. Roaming Drives < Safe Limit
    2. Roaming Drives < 100% (Fill until full)
    3. None (Fail back to System/Main)
    """
    valid_drives = []
    full_drives = []
    
    if not roaming_root.exists(): return None

    for drive in roaming_root.iterdir():
        if not drive.is_dir(): continue
        
        usage = get_disk_usage_percent(drive)
        uuid = drive.name
        
        if usage < safe_limit:
            valid_drives.append((uuid, usage))
        elif usage < 99.0: # Leave tiny buffer
            full_drives.append((uuid, usage))
            
    # Priority 1: Safest drive (lowest usage)
    if valid_drives:
        valid_drives.sort(key=lambda x: x[1])
        return valid_drives[0][0] # Return UUID
        
    # Priority 2: Least full drive (even if unsafe)
    if full_drives:
        full_drives.sort(key=lambda x: x[1])
        return full_drives[0][0]
        
    return None

def move_to_drive(file_path, drive_uuid):
    """
    Moves file to /Mount/Roaming/UUID/Users/...
    Updates DB.
    """
    try:
        # 1. Calculate Destination
        # file_path: /home/user/Downloads/file.iso
        rel_path = file_path.relative_to("/home")
        
        target_root = ROAMING_ROOT / drive_uuid
        target_file = target_root / "Users" / rel_path
        
        target_file.parent.mkdir(parents=True, exist_ok=True)
        
        # 2. Update DB *Before* move? Or After? 
        # If we move first, file disappears from FUSE view momentarily if we aren't careful.
        # FUSE checks DB. 
        # Plan: Copy -> Update Drive DB -> Update System DB -> Delete Local
        
        logging.info(f"Offloading {file_path.name} to {drive_uuid}...")
        shutil.copy2(file_path, target_file)
        
        # 3. Update DBs
        # Drive DB
        drive_db = target_root / "System/ZenFS/Database" / rel_path
        if target_file.is_dir():
            drive_db.mkdir(parents=True, exist_ok=True)
            (drive_db / ".zenfs-folder").write_text(drive_uuid)
        else:
            drive_db.parent.mkdir(parents=True, exist_ok=True)
            drive_db.write_text(drive_uuid)
            
        # System DB (Mirror)
        sys_db = DB_ROOT / rel_path
        sys_db.parent.mkdir(parents=True, exist_ok=True)
        sys_db.write_text(drive_uuid)
        
        # 4. Delete Local
        file_path.unlink()
        return True
        
    except Exception as e:
        logging.error(f"Failed to offload {file_path}: {e}")
        return False

def main(config_str):
    cfg = json.loads(config_str)
    
    threshold = float(cfg.get("offloadThreshold", 80))
    safe_limit = float(cfg.get("roamingSafeLimit", 90))
    main_uuid = cfg.get("mainDrive") # Not strictly needed if scanning /home, but good for explicit logic
    
    # Check Main Drive Usage
    # Assuming /home is on main drive
    current_usage = get_disk_usage_percent("/home")
    
    if current_usage < threshold:
        logging.info(f"Main Drive usage {current_usage}% < {threshold}%. No action needed.")
        return

    logging.warning(f"Main Drive usage {current_usage}% > {threshold}%. Starting offload...")
    
    candidates = get_candidates(Path("/home"))
    
    for file_path in candidates:
        # Re-check usage after every move? (Expensive but safe)
        if get_disk_usage_percent("/home") < threshold:
            logging.info("Target usage reached.")
            break
            
        target_uuid = find_target_drive(ROAMING_ROOT, safe_limit)
        
        if not target_uuid:
            logging.critical("No suitable Roaming Drives found! System Drive is last resort (Saturation).")
            break
            
        move_to_drive(file_path, target_uuid)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1])