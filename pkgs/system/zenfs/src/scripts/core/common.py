# File: src/scripts/core/common.py
import os
import sys
import json
import subprocess
import random
import string
import fnmatch
from pathlib import Path

# --- Constants ---
ZENFS_ROOT = Path("/System/ZenFS")
DB_ROOT = ZENFS_ROOT / "Database"
MOUNT_ROOT = Path("/Mount")
ROAMING_ROOT = MOUNT_ROOT / "Roaming"
MISSING_ROOT = ZENFS_ROOT / "MissingDrives"
LIVE_TEMP = Path("/Live/Temp")
CONFIG_ROOT = Path("/Config")
IGNORE_FILE = ZENFS_ROOT / "ignore_list.json"
CONFIG_MAP_FILE = ZENFS_ROOT / "config_categories.json"

# --- Identifiers ---
def get_system_uuid():
    """Retrieves the local system UUID or defaults to 'system'."""
    uuid_file = ZENFS_ROOT / "system_uuid"
    if uuid_file.exists():
        return uuid_file.read_text().strip()
    return "system"

def generate_zenfs_uuid():
    """Generates a standard 16-char alphanumeric ZenFS UUID."""
    chars = string.ascii_letters + string.digits
    return ''.join(random.choices(chars, k=16))

# --- System Interactions ---
def notify(summary, body=""):
    """Sends a desktop notification via libnotify."""
    try:
        subprocess.run(["notify-send", "-a", "ZenFS", summary, body])
    except: 
        pass

def run_command(cmd):
    """Executes a shell command, raising an error on failure."""
    subprocess.run(cmd, check=True, shell=True)

# --- Filtering Logic ---
def load_ignore_list():
    """Loads the JSON ignore list for DB generation."""
    if not IGNORE_FILE.exists(): return []
    try:
        with open(IGNORE_FILE) as f: return json.load(f)
    except: return []

def is_ignored(path_obj, relative_root, ignore_list):
    """
    Determines if a file should be excluded from the ZenFS Database.
    
    Args:
        path_obj (Path): The full path of the file being checked.
        relative_root (Path): The root against which the path is relative (e.g., /Users/user).
        ignore_list (list): List of patterns/paths to ignore.
    """
    try:
        rel_path = path_obj.relative_to(relative_root)
        rel_str = str(rel_path)
        name = path_obj.name
        
        for rule in ignore_list:
            # Handle user-provided wildcard prefix if present
            clean_rule = rule[1:] if rule.startswith("*") else rule
            
            if "/" in clean_rule:
                # Path-based ignore (e.g., "Downloads/Temp")
                if rel_str.startswith(clean_rule): return True
            else:
                # Pattern-based ignore (e.g., ".config", "*.tmp")
                if rule == name or fnmatch.fnmatch(name, rule): return True
    except: 
        pass
    return False