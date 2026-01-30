# File: src/scripts/janitor/common.py
import os
import json
import hashlib
from pathlib import Path

# --- XDG Base Directories ---
def get_xdg_cache():
    return Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache"))

def get_xdg_data():
    return Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))

def get_xdg_state():
    return Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))

# --- Janitor Paths ---
JANITOR_CACHE = get_xdg_cache() / "zenfs" / "janitor"
BATCH_DIR = JANITOR_CACHE / "batches"
JANITOR_DATA = get_xdg_data() / "zenfs" / "janitor"
METADATA_DIR = JANITOR_DATA / "metadata"
JANITOR_STATE = get_xdg_state() / "zenfs" / "janitor"
HISTORY_DIR = JANITOR_STATE / "history"

# --- Utils ---
def ensure_dirs():
    BATCH_DIR.mkdir(parents=True, exist_ok=True)
    METADATA_DIR.mkdir(parents=True, exist_ok=True)
    HISTORY_DIR.mkdir(parents=True, exist_ok=True)

def load_config(path):
    with open(path) as f:
        return json.load(f)

def get_file_hash(path):
    """Simple hash for sidecar filename generation."""
    return hashlib.md5(str(path).encode('utf-8')).hexdigest()

def create_sidecar(src_path, dest_path):
    """Creates a metadata sidecar for a moved file."""
    import time
    meta = {
        "original_path": str(src_path),
        "moved_to": str(dest_path),
        "timestamp": time.time(),
        "provenance": "unknown" # Placeholder for future expansion
    }
    file_id = get_file_hash(src_path)
    # Ensure dirs exist
    METADATA_DIR.mkdir(parents=True, exist_ok=True)
    with open(METADATA_DIR / f"{file_id}.json", "w") as f:
        json.dump(meta, f, indent=2)

def log_history(original, current, model="dumb"):
    """Logs the move to the history tree."""
    # Mirror the path structure in HISTORY_DIR
    # e.g. /home/user/Downloads/file.txt -> HISTORY_DIR/Downloads/file.txt.json
    try:
        rel_path = Path(current).relative_to(Path.home())
        hist_path = HISTORY_DIR / rel_path
        hist_path.parent.mkdir(parents=True, exist_ok=True)
        
        data = {
            "original": str(original),
            "current": str(current),
            "model": model,
            "timestamp": os.path.getmtime(current)
        }
        with open(f"{hist_path}.json", "w") as f:
            json.dump(data, f)
    except Exception as e:
        print(f"Failed to log history: {e}")