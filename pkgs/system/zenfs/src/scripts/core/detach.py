# File: src/scripts/core/detach.py
import sys
from pathlib import Path
from common import run_command, notify, ROAMING_ROOT

def detach(target):
    print(f"Detaching {target}...")
    mount_point = Path(target)
    
    if not mount_point.is_absolute():
        mount_point = ROAMING_ROOT / target
        
    if mount_point.exists():
        try:
            run_command(f"umount {mount_point}")
            notify("ZenFS", f"Detached {mount_point.name}")
            # Trigger roaming to update symlinks (removes dead files)
            run_command("zenfs roaming")
        except Exception as e:
            notify("ZenFS Error", f"Detach failed: {e}")