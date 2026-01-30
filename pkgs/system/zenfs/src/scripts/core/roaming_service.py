# File: src/scripts/core/roaming_service.py
import shutil
import os
from pathlib import Path
from common import DB_ROOT, ROAMING_ROOT, MISSING_ROOT, ZENFS_ROOT, notify

def ensure_missing_placeholder(uuid, relative_path):
    target_dir = MISSING_ROOT / uuid / relative_path.parent
    target_dir.mkdir(parents=True, exist_ok=True)
    
    placeholder = MISSING_ROOT / uuid / relative_path
    if not placeholder.exists():
        if placeholder.suffix == "": 
             placeholder.mkdir(exist_ok=True)
             (placeholder / "README_INSERT_DRIVE.txt").write_text(f"Drive {uuid} missing.")
        else:
             placeholder.write_text(f"File unavailable. Connect drive {uuid}.")
    return placeholder

def sync_symlinks():
    # SKIPS if /Users is not a symlink (i.e. we are in FUSE mode).
    users_mount = Path("/Users")
    if not users_mount.is_symlink() and users_mount.is_dir():
        print("FUSE Mode detected (or /Users is a real dir). Skipping Symlink generation.")
        return

    print("Syncing Symlinks in /Users...")
    if not DB_ROOT.exists(): return

    # --- Phase 1: Create/Update Links ---
    for user_path in DB_ROOT.iterdir():
        if not user_path.is_dir(): continue
        
        user_name = user_path.name
        real_home = Path(f"/home/{user_name}") 
        if not real_home.exists(): continue
        
        for ghost_item in user_path.iterdir():
            ghost_name = ghost_item.name
            target_link = real_home / ghost_name
            
            uuid = None
            is_dir = ghost_item.is_dir()
            try:
                if is_dir: uuid = (ghost_item / ".zenfs-folder").read_text().strip()
                else: uuid = ghost_item.read_text().strip()
            except: continue

            link_source = None
            if uuid == "." or uuid == "system":
                if target_link.is_symlink(): target_link.unlink()
                continue
            else:
                roaming_mount = ROAMING_ROOT / uuid
                if roaming_mount.exists():
                    link_source = roaming_mount / "Users" / user_name / ghost_name
                else:
                    rel_path = Path(user_name) / ghost_name
                    link_source = ensure_missing_placeholder(uuid, rel_path)

            if target_link.exists():
                if not target_link.is_symlink(): continue
                if target_link.readlink() == link_source: continue
                target_link.unlink()
            
            try: target_link.symlink_to(link_source)
            except Exception as e: print(f"Failed to link {ghost_name}: {e}")

    # --- Phase 2: Cleanup Dead Links ---
    for user_path in DB_ROOT.iterdir():
        if not user_path.is_dir(): continue
        user_name = user_path.name
        real_home = Path(f"/home/{user_name}")
        if not real_home.exists(): continue

        for item in real_home.iterdir():
            if item.is_symlink():
                try:
                    target = item.readlink()
                    is_zenfs_link = str(target).startswith(str(ROAMING_ROOT)) or \
                                    str(target).startswith(str(MISSING_ROOT))
                    
                    if is_zenfs_link:
                        db_entry = DB_ROOT / user_name / item.name
                        if not db_entry.exists():
                            print(f"Removing dead ZenFS link: {item.name}")
                            item.unlink()
                except OSError: pass

def main():
    print("ZenFS Roaming: Syncing Databases...")
    
    # 1. Merge Roaming Databases into System DB
    for drive_dir in ROAMING_ROOT.iterdir():
        if drive_dir.is_dir():
            roaming_db = drive_dir / "System/ZenFS/Database"
            if roaming_db.exists():
                try: shutil.copytree(roaming_db, DB_ROOT, dirs_exist_ok=True)
                except: pass
    
    # 2. Build the Union View (Symlink Mode Only)
    sync_symlinks()
    notify("ZenFS", "Filesystem Sync Complete")