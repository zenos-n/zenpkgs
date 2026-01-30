# File: src/scripts/janitor/dumb.py
import os
import sys
import time
import shutil
import logging
from threading import Timer
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from common import create_sidecar, log_history, ensure_dirs

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

class BatchManager:
    def __init__(self, config):
        self.config = config
        self.interval = self._parse_time(config.get("batchInterval", "5m"))
        self.source_dir = Path(config["sourceDir"])
        
        # Local Waiting Directory: ~/Downloads/Waiting
        self.waiting_dir = self.source_dir / "Waiting"
        self.waiting_dir.mkdir(exist_ok=True)

        self.timer = None
        self.pending_files = set()

    def _parse_time(self, t_str):
        if t_str.endswith("m"): return int(t_str[:-1]) * 60
        if t_str.endswith("s"): return int(t_str[:-1])
        if t_str.endswith("h"): return int(t_str[:-1]) * 3600
        return 300 

    def reset_timer(self, file_path):
        p = Path(file_path)
        # Ignore symlinks and files already in Waiting
        if p.is_symlink(): return
        if str(self.waiting_dir) in str(p): return 
        
        self.pending_files.add(file_path)
        if self.timer: self.timer.cancel()
        
        self.timer = Timer(self.interval, self.create_batch)
        self.timer.start()
        logging.info(f"File added: {p.name}. Batch timer reset.")

    def create_batch(self):
        if not self.pending_files: return
        
        timestamp = time.strftime("%Y-%m-%d_%H-%M")
        batch_name = f"Batch_{timestamp}"
        target_dir = self.waiting_dir / batch_name
        target_dir.mkdir(parents=True, exist_ok=True)
        
        moved_count = 0
        for fpath in list(self.pending_files):
            p = Path(fpath)
            if p.exists() and not p.is_symlink():
                try:
                    dest = target_dir / p.name
                    shutil.move(str(p), str(dest))
                    create_sidecar(p, dest)
                    moved_count += 1
                except Exception as e:
                    logging.error(f"Failed to move {p}: {e}")
        
        self.pending_files.clear()
        if moved_count > 0:
            logging.info(f"Created batch {batch_name} in {self.waiting_dir}")
        else:
            try: target_dir.rmdir() 
            except: pass

class DumbHandler(FileSystemEventHandler):
    def __init__(self, manager):
        self.manager = manager

    def on_created(self, event):
        if not event.is_directory:
            self.manager.reset_timer(event.src_path)

    def on_modified(self, event):
        if not event.is_directory:
            self.manager.reset_timer(event.src_path)

def process_batches(config):
    grace_str = config.get("gracePeriod", "15m")
    if grace_str.endswith("m"): grace = int(grace_str[:-1]) * 60
    elif grace_str.endswith("h"): grace = int(grace_str[:-1]) * 3600
    else: grace = 300
    
    now = time.time()
    
    for w_path, w_cfg in config.get("watchedDirs", {}).items():
        waiting_dir = Path(w_path) / "Waiting"
        if not waiting_dir.exists(): continue
        
        # Build Rules
        dir_rules = []
        for dest, exts in w_cfg.get("rules", {}).items():
            for ext in exts:
                dir_rules.append((ext, dest))
        # Priority: Longest Suffix Match
        dir_rules.sort(key=lambda x: len(x[0]), reverse=True)
        
        # Process Batches
        for batch in waiting_dir.iterdir():
            if not batch.is_dir(): continue
            if batch.name.startswith("CONFLICT"): continue
            
            # Check Age
            if now - batch.stat().st_mtime > grace:
                logging.info(f"Processing mature batch {batch.name} in {w_path}")
                
                # Sort Files
                for item in batch.iterdir():
                    if item.is_dir(): continue
                    
                    sorted_match = None
                    name = item.name.lower()
                    
                    for ext, dest_rel in dir_rules:
                        clean_ext = ext if ext.startswith(".") else f".{ext}"
                        if name.endswith(clean_ext.lower()):
                            if Path(dest_rel).is_absolute():
                                sorted_match = Path(dest_rel)
                            else:
                                sorted_match = Path.home() / dest_rel
                            break
                    
                    if sorted_match:
                        sorted_match.mkdir(parents=True, exist_ok=True)
                        try:
                            final_dest = sorted_match / item.name
                            shutil.move(str(item), str(final_dest))
                            create_sidecar(item, final_dest)
                            log_history(item, final_dest, model="dumb")
                            logging.info(f"Sorted {item.name} -> {sorted_match}")
                        except Exception as e:
                            logging.error(f"Error sorting {item.name}: {e}")
                
                # Cleanup
                if not any(batch.iterdir()):
                    batch.rmdir()
                    logging.info(f"Removed empty batch {batch.name}")
                else:
                    new_name = f"CONFLICT_{batch.name}"
                    batch.rename(batch.parent / new_name)
                    logging.warning(f"Batch conflict. Renamed to {new_name}")

def main(config_path):
    import json
    with open(config_path) as f: full_config = json.load(f)
    dumb_config = full_config.get("dumb", {})
    if not dumb_config.get("enable", False): return

    ensure_dirs()
    observers = []
    
    for w_path, w_cfg in dumb_config.get("watchedDirs", {}).items():
        if os.path.exists(w_path):
            mgr_cfg = w_cfg.copy()
            mgr_cfg["batchInterval"] = dumb_config.get("batchInterval", "5m")
            mgr_cfg["sourceDir"] = w_path
            
            manager = BatchManager(mgr_cfg)
            handler = DumbHandler(manager)
            
            obs = Observer()
            obs.schedule(handler, w_path, recursive=False)
            obs.start()
            observers.append(obs)
            logging.info(f"Janitor watching: {w_path}")

    try:
        while True:
            time.sleep(10)
            process_batches(dumb_config)
    except KeyboardInterrupt:
        for o in observers: o.stop()
        for o in observers: o.join()

if __name__ == "__main__":
    if len(sys.argv) > 1: main(sys.argv[1])