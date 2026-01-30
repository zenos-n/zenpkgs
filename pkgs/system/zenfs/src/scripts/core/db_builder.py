# File: src/scripts/core/db_builder.py
import os
import shutil
from pathlib import Path
from common import load_ignore_list, is_ignored

def rebuild_drive_db(mount_point, uuid):
    """
    Scans a physical drive's /Users directory and generates the 'Ghost Database' 
    structure inside /System/ZenFS/Database on that drive.
    """
    drive_root = Path(mount_point)
    db_root = drive_root / "System/ZenFS/Database"
    users_root = drive_root / "Users"
    ignore_list = load_ignore_list()
    
    print(f"Rebuilding DB for {uuid} at {mount_point}...")
    
    # Clean slate for the DB on the drive
    if db_root.exists():
        shutil.rmtree(db_root)
    db_root.mkdir(parents=True, exist_ok=True)
    
    if not users_root.exists():
        print("No /Users found on drive, skipping DB generation.")
        return

    # Iterate users (e.g., /Users/doromiert)
    for user_dir in users_root.iterdir():
        if not user_dir.is_dir(): continue
        
        user_db_target = db_root / user_dir.name
        user_db_target.mkdir(parents=True, exist_ok=True)

        # Create Ghost Files
        for item in user_dir.iterdir():
            if is_ignored(item, user_dir, ignore_list): 
                continue
            
            ghost_path = user_db_target / item.name
            
            if item.is_dir():
                ghost_path.mkdir(exist_ok=True)
                # Directories contain a marker file with the UUID
                (ghost_path / ".zenfs-folder").write_text(uuid)
            else:
                # Files are represented by a file containing the UUID
                ghost_path.write_text(uuid)

    print(f"Database build complete for {uuid}.")