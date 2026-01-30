# File: src/scripts/core/core_service.py
import json
from pathlib import Path
from common import CONFIG_ROOT, CONFIG_MAP_FILE

def main():
    print("Starting ZenFS Core Service...")
    CONFIG_ROOT.mkdir(exist_ok=True)
    
    if not CONFIG_MAP_FILE.exists(): 
        print("No config map found.")
        return

    with open(CONFIG_MAP_FILE) as f:
        mapping = json.load(f)
        
    for category, targets in mapping.items():
        cat_path = CONFIG_ROOT / category
        cat_path.mkdir(parents=True, exist_ok=True)
        
        # ZenOS folder is managed by user/nix, skip content management
        if category == "ZenOS": continue

        for target in targets:
            t_path = Path(target)
            if t_path.exists():
                link = cat_path / t_path.name
                
                # Create symlink if it doesn't exist
                if not link.exists():
                    try:
                        link.symlink_to(t_path)
                    except Exception as e:
                        print(f"Failed to link {target}: {e}")