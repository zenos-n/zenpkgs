import os
import glob
import shutil
import subprocess
import sys
import re

# Envs passed from the bash wrapper
ESP_MOUNT = os.environ.get("ESP_MOUNT", "/boot")
PROFILE_DIR = os.environ.get("PROFILE_DIR", "/nix/var/nix/profiles/system")
OS_ICON = os.environ.get("OS_ICON", "zenos")
GEN_COUNT = int(os.environ.get("GEN_COUNT", "10"))
SHARE_DIR = os.environ.get("ZENBOOT_SHARE", "/run/current-system/sw/share/zenboot")

REFIND_DIR = os.path.join(ESP_MOUNT, "EFI", "refind")
ENTRIES_FILE = os.path.join(REFIND_DIR, "zenboot-entries.conf")

def log(msg):
    print(f"[zenboot] {msg}")

def ensure_refind_installed():
    """Checks if refind is installed in EFI, installs if missing."""
    efi_boot = os.path.join(REFIND_DIR, "refind_x64.efi")
    
    if not os.path.exists(efi_boot):
        log("rEFInd binary not found. Installing...")
        # Assuming 'refind-install' is in PATH via the derivation's nativeBuildInputs
        try:
            subprocess.check_call(["refind-install", "--yes"])
        except subprocess.CalledProcessError:
            log("CRITICAL: Failed to install rEFInd. Check EFIVARS access.")
            sys.exit(1)
    else:
        log("rEFInd is already installed.")

def update_config_files():
    """Copies refind.conf and themes from the package store to ESP."""
    log("Updating configuration and themes...")
    
    # 1. Install main config
    pkg_config = os.path.join(SHARE_DIR, "refind.conf")
    target_config = os.path.join(REFIND_DIR, "refind.conf")
    
    if os.path.exists(pkg_config):
        shutil.copy2(pkg_config, target_config)
    else:
        log(f"WARNING: Source config {pkg_config} not found.")

    # 2. Install Theme
    # We copy from store to ESP/EFI/refind/theme
    pkg_theme = os.path.join(SHARE_DIR, "theme")
    target_theme = os.path.join(REFIND_DIR, "theme")
    
    if os.path.exists(target_theme):
        shutil.rmtree(target_theme)
    
    if os.path.exists(pkg_theme):
        shutil.copytree(pkg_theme, target_theme)
    else:
        log("WARNING: Theme directory not found in package.")

def get_kernel_params(generation_path):
    """
    Attempts to retrieve kernel params. 
    On standard NixOS, this is hard to get for old generations without metadata.
    We fall back to a safe default if specific params file isn't found.
    """
    params_path = os.path.join(generation_path, "kernel-params")
    if os.path.exists(params_path):
        with open(params_path, 'r') as f:
            return f.read().strip()
    
    # Fallback: Look at init script to find init path, generic params
    # This is a simplification. For robust usage, your OS module should 
    # generate a 'kernel-params' file in the generation output.
    return "init=/nix/var/nix/profiles/system/init loglevel=4"

def generate_entries():
    """Scans profiles and generates the refind sub-config."""
    log(f"Scanning up to {GEN_COUNT} generations...")
    
    profiles = sorted(glob.glob(f"{PROFILE_DIR}-*-link"), key=lambda p: int(p.split('-')[-2]), reverse=True)
    profiles = profiles[:GEN_COUNT]
    
    entries = []
    
    for profile in profiles:
        try:
            gen_num = profile.split('-')[-2]
            kernel_path = os.path.realpath(os.path.join(profile, "kernel"))
            initrd_path = os.path.realpath(os.path.join(profile, "initrd"))
            
            # Map /nix/store paths to EFI paths if they aren't on the ESP.
            # rEFInd driver for ext4/btrfs can read /nix/store if partition is accessible.
            # We assume rEFInd has filesystem drivers loaded.
            
            params = get_kernel_params(profile)
            
            entry = f"""
menuentry "ZenOS Generation {gen_num}" {{
    icon {REFIND_DIR}/theme/icons/{OS_ICON}.png
    loader {kernel_path}
    initrd {initrd_path}
    options "{params}"
    submenuentry "Boot to Terminal" {{
        add_options "systemd.unit=multi-user.target"
    }}
}}
"""
            entries.append(entry)
        except Exception as e:
            log(f"Skipping generation {gen_num}: {e}")

    with open(ENTRIES_FILE, "w") as f:
        f.write("\n".join(entries))
    
    log(f"Generated {len(entries)} boot entries in {ENTRIES_FILE}")

def main():
    if not os.path.exists(REFIND_DIR):
        os.makedirs(REFIND_DIR, exist_ok=True)
        
    ensure_refind_installed()
    update_config_files()
    generate_entries()

if __name__ == "__main__":
    main()