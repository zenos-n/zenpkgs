import os
import glob
import sys
import re

# Environment Variables
ESP_MOUNT = os.environ.get("ESP_MOUNT", "/boot")
PROFILE_DIR = os.environ.get("PROFILE_DIR", "/nix/var/nix/profiles/system")
OS_ICON = os.environ.get("OS_ICON", "zenos")
GEN_COUNT = int(os.environ.get("GEN_COUNT", "10"))

# Paths
REFIND_DIR = os.path.join(ESP_MOUNT, "EFI", "refind")
OUTPUT_FILE = os.path.join(REFIND_DIR, "zenboot-entries.conf")
ICON_PATH = f"{REFIND_DIR}/themes/zenos-refind-theme/icons/{OS_ICON}.png"

# Default kernel options usually required for NixOS/ZenOS
# We use systemd.unit=multi-user.target for the main boot, 
# but you can adjust this if you want graphical by default.

def log(msg):
    print(f"[zenboot] {msg}")

def get_gens():
    """
    Finds generation links, sorts them by version number (descending).
    Returns a list of full paths.
    """
    # Glob patterns: /nix/var/nix/profiles/system-*-link
    pattern = f"{PROFILE_DIR}-*-link"
    gens = glob.glob(pattern)
    
    def extract_gen_num(path):
        match = re.search(r'system-(\d+)-link', path)
        return int(match.group(1)) if match else 0

    return sorted(gens, key=extract_gen_num, reverse=True)[:GEN_COUNT]

def resolve_esp_path(path, type_label):
    """
    Resolves the path for the loader. 
    Since rEFInd with the btrfs/ext4 drivers can read /nix/store directly,
    we return the absolute path.
    """
    if not os.path.exists(path):
        log(f"WARNING: {type_label} path does not exist: {path}")
    return path

def generate_config():
    gens = get_gens()
    if not gens:
        log("No generations found in profile dir.")
        return

    log(f"Generating {OUTPUT_FILE} for {len(gens)} generations...")

    with open(OUTPUT_FILE, "w") as f:
        # Start the main entry block
        f.write(f'menuentry "ZenOS" {{\n')
        f.write(f'    icon {ICON_PATH}\n')
        
        for i, gen in enumerate(gens):
            # Extract generation number from filename
            match = re.search(r'system-(\d+)-link', gen)
            gen_num = match.group(1) if match else "0"
            
            # Resolve the symlink to the actual store path
            target = os.readlink(gen)
            
            # Construct paths to kernel/initrd/init inside the store path
            kernel_link = os.path.join(target, "kernel")
            initrd_link = os.path.join(target, "initrd")
            init_path = os.path.join(target, "init")
            
            # Resolve physical files (keep as absolute paths for rEFInd drivers)
            loader_final = resolve_esp_path(kernel_link, "kernel")
            initrd_final = resolve_esp_path(initrd_link, "initrd")
            
            # Read built-in params from the generation's kernel-params file
            params_file = os.path.join(target, "kernel-params")
            params = ""
            if os.path.exists(params_file):
                with open(params_file, "r") as p:
                    params = p.read().strip()

            # Combine init path, built-in params, and forced flags
            full_options = f"init={init_path} {params}"

            # Main Entry Logic (Latest Generation)
            # This sets the default action when hitting Enter on the icon
            if i == 0:
                f.write(f'    loader {loader_final}\n')
                f.write(f'    initrd {initrd_final}\n')
                f.write(f'    options "{full_options}"\n')
            
            # Submenus for specific generations (including the current one)
            # This allows rolling back via the F2/Submenu key
            f.write(f'    submenuentry "Generation {gen_num}" {{\n')
            f.write(f'        loader {loader_final}\n')
            f.write(f'        initrd {initrd_final}\n')
            f.write(f'        options "{full_options}"\n')
            f.write(f'    }}\n')
            
        f.write(f'}}\n')
    
    log("Done.")

if __name__ == "__main__":
    generate_config()