# File: src/scripts/core/watcher.py
import sys
import time
import shutil
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from common import DB_ROOT, ROAMING_ROOT, get_system_uuid, load_ignore_list, is_ignored

class ZenFSHandler(FileSystemEventHandler):
    def __init__(self):
        self.ignore_list = load_ignore_list()

    def _get_db_target(self, src_path):
        """
        Calculates the corresponding Ghost DB path for a given real file path.
        Returns: (db_path, uuid) or (None, None)
        """
        path = Path(src_path)
        
        # 1. Identify Context (Roaming vs Local)
        # Check if path is inside /Mount/Roaming
        if str(path).startswith(str(ROAMING_ROOT)):
            # Path: /Mount/Roaming/<UUID>/Users/<User>/...
            try:
                rel = path.relative_to(ROAMING_ROOT)
                parts = rel.parts
                if len(parts) < 3 or parts[1] != "Users": 
                    return None, None # Not a user file
                
                uuid = parts[0]
                user = parts[2]
                rest = Path(*parts[3:])
                
                # DB Target: /Mount/Roaming/<UUID>/System/ZenFS/Database/<User>/<Rest>
                # NOTE: We write to the DRIVE'S DB, not the System DB directly.
                # The System DB syncs from the Drive DB.
                # Actually, for "instant" missing drive support, we should probably update BOTH 
                # or rely on the roaming_service sync. 
                # Let's write to the Drive DB (so it persists) AND the System DB (for instant effect).
                
                drive_db = ROAMING_ROOT / uuid / "System/ZenFS/Database" / user / rest
                return drive_db, uuid
            except:
                return None, None
        
        return None, None

    def _update_db(self, path, is_dir, event_type):
        db_path, uuid = self._get_db_target(path)
        if not db_path or not uuid: return

        # Check ignores
        # We need a relative root to check ignores. For roaming: /Mount/Roaming/<UUID>/Users/<User>
        # Constructing that from the logic above is a bit duplicated, simplified here:
        try:
            # Re-parsing for ignore check context
            if str(path).startswith(str(ROAMING_ROOT)):
                parts = path.relative_to(ROAMING_ROOT).parts
                user_root = ROAMING_ROOT / parts[0] / "Users" / parts[2]
                if is_ignored(Path(path), user_root, self.ignore_list):
                    return
        except: pass

        try:
            if event_type == 'created':
                if is_dir:
                    db_path.mkdir(parents=True, exist_ok=True)
                    (db_path / ".zenfs-folder").write_text(uuid)
                else:
                    db_path.parent.mkdir(parents=True, exist_ok=True)
                    db_path.write_text(uuid)
                
                # Mirror to System DB for instant reaction
                # System DB Path: /System/ZenFS/Database/<User>/<Rest>
                # Extract User/Rest from db_path
                # Drive DB: .../System/ZenFS/Database/<User>/<Rest>
                # We can verify the part after "Database"
                parts = db_path.parts
                if "Database" in parts:
                    idx = parts.index("Database")
                    rel_db = Path(*parts[idx+1:])
                    sys_db_target = DB_ROOT / rel_db
                    
                    if is_dir:
                        sys_db_target.mkdir(parents=True, exist_ok=True)
                        (sys_db_target / ".zenfs-folder").write_text(uuid)
                    else:
                        sys_db_target.parent.mkdir(parents=True, exist_ok=True)
                        sys_db_target.write_text(uuid)

            elif event_type == 'deleted':
                # Remove from Drive DB
                if db_path.exists():
                    if db_path.is_dir(): shutil.rmtree(db_path)
                    else: db_path.unlink()
                
                # Remove from System DB
                parts = db_path.parts
                if "Database" in parts:
                    idx = parts.index("Database")
                    rel_db = Path(*parts[idx+1:])
                    sys_db_target = DB_ROOT / rel_db
                    if sys_db_target.exists():
                        if sys_db_target.is_dir(): shutil.rmtree(sys_db_target)
                        else: sys_db_target.unlink()

            elif event_type == 'moved':
                # Handled by separate delete/create events usually, 
                # but watchdog sends moved event.
                # For simplicity in this specialized DB, treat as delete old + create new
                pass

        except Exception as e:
            print(f"Watcher Error ({event_type}): {e}")

    def on_created(self, event):
        self._update_db(event.src_path, event.is_directory, 'created')

    def on_deleted(self, event):
        self._update_db(event.src_path, event.is_directory, 'deleted')

    def on_moved(self, event):
        self._update_db(event.src_path, event.is_directory, 'deleted')
        self._update_db(event.dest_path, event.is_directory, 'created')

def main():
    print("Starting ZenFS Watcher...")
    observer = Observer()
    event_handler = ZenFSHandler()
    
    # Watch Roaming Drives
    # Recursive=True is needed to catch files inside subfolders
    if ROAMING_ROOT.exists():
        observer.schedule(event_handler, str(ROAMING_ROOT), recursive=True)
    
    # Option: Watch /home for local file tracking (Optional, heavier)
    # real_home = Path("/home")
    # if real_home.exists():
    #     observer.schedule(event_handler, str(real_home), recursive=True)

    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()