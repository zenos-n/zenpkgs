# File: src/scripts/janitor/ml.py
import sys
import time
import json
import logging
from pathlib import Path
from common import BATCH_DIR, log_history

logging.basicConfig(level=logging.INFO)

# Placeholder for actual model inference
class ModelTier1:
    def predict(self, filename):
        # Dumb heuristic for demonstration
        l = filename.lower()
        if "receipt" in l or "invoice" in l: return "Documents/Financial"
        if "screenshot" in l: return "Pictures/Screenshots"
        return None

def run_tier1(config):
    """
    Daemon that watches the Batches for 'Residue' (files left over after Dumb sort).
    Also scans Home Root?
    """
    logging.info("ML Tier 1: Scanning...")
    
    if not BATCH_DIR.exists(): return
    
    model = ModelTier1()
    
    for batch in BATCH_DIR.iterdir():
        if not batch.is_dir(): continue
        
        # Files here are residues
        for item in batch.iterdir():
            if item.is_dir(): continue
            
            dest_rel = model.predict(item.name)
            if dest_rel:
                target = Path.home() / dest_rel
                target.mkdir(parents=True, exist_ok=True)
                
                try:
                    import shutil
                    final_path = target / item.name
                    shutil.move(str(item), str(final_path))
                    log_history(item, final_path, model="ml_tier1")
                    logging.info(f"ML T1 Moved {item.name} -> {target}")
                except Exception as e:
                    logging.error(f"ML T1 Error: {e}")

def main(config_path):
    with open(config_path) as f: cfg = json.load(f)
    if not cfg.get("ml", {}).get("enable", False): return
    
    # Daemon Loop
    try:
        while True:
            run_tier1(cfg)
            time.sleep(60) # Scan every minute
    except KeyboardInterrupt:
        pass

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1])