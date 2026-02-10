import json
import re
import sys
import os

# --- GLOBALS ---
STATS = {
    "options": 0,
    "maps": 0,
    "packages": 0
}

VALIDATION_ERRORS = []

def load_json(path):
    with open(path, 'r') as f:
        return json.load(f)

# --- VALIDATION LOGIC ---

def validate_node(node, brief, path, is_package=False):
    """
    Enforces METADATA_STANDARDS.md on a processed node.
    """
    errors = []
    
    # 1. First Line Rule (Summary)
    if not brief or brief == "No description.":
        errors.append("Description is missing or empty.")
    else:
        # Length Constraint
        if len(brief) > 80:
            errors.append(f"Summary exceeds 80 chars (Len: {len(brief)}): '{brief[:60]}...'")
        
        # Capitalization
        if brief and brief[0].isalpha() and not brief[0].isupper():
            errors.append(f"Summary must start with a capital letter: '{brief}'")
            
        # Punctuation
        if brief.endswith('.'):
            errors.append(f"Summary must NOT end with a period: '{brief}'")

    # 2. Package Specifics
    if is_package:
        if not node.get("maintainers"):
            errors.append("Missing required field: 'maintainers'")

    if errors:
        VALIDATION_ERRORS.append({
            "path": path,
            "errors": errors
        })

# --- NORMALIZERS ---

def normalize_type(type_obj):
    if isinstance(type_obj, dict):
        type_str = str(type_obj.get('name', 'unknown')).lower()
    else:
        type_str = str(type_obj).lower()
    
    if "one of" in type_str:
        try:
            remainder = type_str.split("one of", 1)[1]
            raw_opts = remainder.split(',')
            clean_opts = []
            for opt in raw_opts:
                opt = opt.replace(" or ", " ").strip().strip('"').strip("'")
                if opt:
                    clean_opts.append(opt)
            return { "enum": clean_opts }
        except:
            return { "enum": [] }

    if any(x in type_str for x in ["boolean", "bool"]): return "boolean"
    if any(x in type_str for x in ["list of", "list"]): return "array"
    if any(x in type_str for x in ["attribute set", "submodule", "package", "derivation"]): return "set"
    if any(x in type_str for x in ["int", "float", "number", "integer"]): return "number"
    if any(x in type_str for x in ["string", "path", "str"]): return "string"
    if "function" in type_str: return "function"
    if "null" in type_str: return "null"
    
    return "unknown"

def clean_default(val):
    if isinstance(val, dict) and val.get('_type') == 'literalExpression':
        return str(val.get('text', ''))
    if val is None:
        return "none"
    return str(val)

# --- STANDARD FORMATTERS ---

def create_meta(node_type="container", brief="", description="", default="none", maintainers=None, platforms=None, dependencies=None):
    return {
        "type": node_type,
        "brief": brief,
        "description": description,
        "default": default,
        "maintainers": maintainers,
        "platforms": platforms,
        "dependencies": dependencies or [] # [NEW]
    }

# --- TREE RECONSTRUCTION ---

def unflatten_options(flat_options):
    """
    Converts {'a.b.c': data} -> {'a': {'b': {'c': data}}}
    Fixed to merge data into existing containers (Hybrid Nodes).
    """
    root = {}
    
    for dot_path, data in flat_options.items():
        parts = dot_path.split('.')
        current = root
        
        for i, part in enumerate(parts[:-1]):
            if part not in current:
                current[part] = {}
            if not isinstance(current[part], dict):
                current[part] = {} 
            current = current[part]
        
        leaf_key = parts[-1]
        data["_type"] = "zen_option"
        
        # Merge if exists, otherwise assign
        if leaf_key in current and isinstance(current[leaf_key], dict):
            current[leaf_key].update(data)
        else:
            current[leaf_key] = data
        
    return root

# --- PROCESSORS ---

def process_option_node(node, in_legacy=False, current_path="", override_desc=None):
    """Converts a raw option dict to the Meta/Sub format."""
    
    if override_desc:
        full_desc = override_desc
        using_override = True
    else:
        raw_desc = node.get("description", "")
        if isinstance(raw_desc, dict):
            full_desc = str(raw_desc.get("text", "")) if "text" in raw_desc else str(raw_desc)
        else:
            full_desc = str(raw_desc)
        using_override = False

    is_auto_alias = bool(re.search(r"Alias of.*`", full_desc)) if not using_override else False

    if in_legacy or is_auto_alias:
        brief = "Legacy maps don't support briefs, read the documentation below" 
        description_rest = full_desc
    else:
        lines = full_desc.split("\n")
        brief = lines[0].strip() if lines else "No description."
        description_rest = "\n".join(lines[1:]).strip() if len(lines) > 1 else ""

    raw_type = node.get("type", "unknown")
    norm_type = normalize_type(raw_type)
    raw_default = node.get("default", "none")
    clean_def = clean_default(raw_default)
    
    should_validate = not in_legacy and (not is_auto_alias or using_override)
    
    if should_validate:
        is_pkg = norm_type == "package" or (isinstance(norm_type, str) and "package" in norm_type)
        validate_node(node, brief, current_path, is_package=is_pkg)

    result = {
        "meta": create_meta(
            node_type=norm_type,
            brief=brief,
            description=description_rest,
            default=clean_def,
            maintainers=node.get("maintainers"),
            platforms=node.get("platforms")
        )
    }
    return result

# [NEW] Package Catalog Processor
def process_package_catalog(raw_tree, path_prefix="pkgs"):
    """
    Recursively transforms the raw zen-packages.json tree into the standard Doc format.
    """
    processed = {}
    
    for key, value in raw_tree.items():
        current_path = f"{path_prefix}.{key}"
        
        # Check if it's a leaf package
        if isinstance(value, dict) and value.get("_type") == "zen_package":
            # Extract fields
            raw_desc = value.get("meta", {}).get("description", "")
            lines = str(raw_desc).split("\n")
            brief = lines[0].strip() if lines else "No description."
            description_rest = "\n".join(lines[1:]).strip() if len(lines) > 1 else ""
            
            # Metadata from Nix JSON
            maintainers = value.get("meta", {}).get("maintainers", [])
            platforms = value.get("meta", {}).get("platforms", [])
            deps = value.get("dependencies", [])
            
            # Validation
            validate_node(value.get("meta", {}), brief, current_path, is_package=True)
            
            processed[key] = {
                "meta": create_meta(
                    node_type="package",
                    brief=brief,
                    description=description_rest,
                    maintainers=maintainers,
                    platforms=platforms,
                    dependencies=deps # Pass dependencies
                )
            }
            STATS["packages"] += 1
            
        # It's a category/directory
        elif isinstance(value, dict):
            children = process_package_catalog(value, current_path)
            if children:
                processed[key] = {
                    "meta": create_meta(node_type="container", brief=f"Category: {key}"),
                    "sub": children
                }
                
    return processed


def find_node(root, dot_path):
    parts = dot_path.split('.')
    current = root
    for part in parts:
        if part in current:
            current = current[part]
        elif "sub" in current and part in current["sub"]:
            current = current["sub"][part]
        else:
            return None
    return current

def process_tree(raw_root, full_root=None, in_legacy=False, count_stats=True, path_prefix=""):
    if full_root is None: full_root = raw_root

    processed = {}
    
    meta_override = None
    if "_zenpkgs-meta" in raw_root:
        meta_node = raw_root["_zenpkgs-meta"]
        raw_desc = meta_node.get("description", "")
        if isinstance(raw_desc, dict): raw_desc = raw_desc.get("text", "")
        meta_override = str(raw_desc)
        
    if "_meta" in raw_root:
        meta_node = raw_root["_meta"]
        raw_desc = meta_node.get("description", "")
        if isinstance(raw_desc, dict): raw_desc = raw_desc.get("text", "")
        if not meta_override: 
            meta_override = str(raw_desc)

    # 1. HYBRID PROCESSING
    if raw_root.get("_type") == "zen_option":
        processed_node = process_option_node(raw_root, in_legacy=in_legacy, current_path=path_prefix, override_desc=meta_override)
        
        original_desc = raw_root.get("description", "")
        if isinstance(original_desc, dict): original_desc = original_desc.get("text", "")
        
        match = re.search(r"Alias of.*`([a-zA-Z0-9\._-]+)`", str(original_desc))
        
        if match:
            if count_stats and not in_legacy: STATS["maps"] += 1 
            target_path = match.group(1)
            target_node = find_node(full_root, target_path)
            if target_node:
                if isinstance(target_node, dict) and "sub" in target_node:
                    processed_node["sub"] = target_node["sub"]
                elif isinstance(target_node, dict):
                        processed_target = process_tree(target_node, full_root, in_legacy=True, count_stats=False, path_prefix=path_prefix)
                        if processed_target:
                            processed_node["sub"] = processed_target
        else:
            if count_stats and not in_legacy: STATS["options"] += 1

        for k, v in raw_root.items():
            if k in ["_meta", "_zenpkgs-meta"] or not isinstance(v, dict): continue
            # Recursion needed for hybrid children if strict structure required
            pass 
        
        return processed_node

    # 2. STANDARD CONTAINER PROCESSING
    for key, value in raw_root.items():
        if key in ["_meta", "_zenpkgs-meta"]: continue
        
        current_path = f"{path_prefix}.{key}" if path_prefix else key
        is_legacy = in_legacy or (key == "legacy")
        
        if isinstance(value, dict):
            child_result = process_tree(value, full_root, in_legacy=is_legacy, count_stats=count_stats, path_prefix=current_path)
            
            if "meta" in child_result:
                processed[key] = child_result
            else:
                desc = meta_override if meta_override else ""
                brief = desc.split("\n")[0]
                
                if child_result:
                    processed[key] = {
                        "meta": create_meta(node_type="container", brief=brief, description=desc),
                        "sub": child_result
                    }

    return processed

# --- THE TRANSFORM LOGIC ---

def transform_structure(root_tree, package_catalog_raw=None):
    # 1. CUT OFF ZENOS
    zenos_tree = root_tree.pop("zenos", {})

    # 2. CUT USER LEGACY
    user_legacy_tree = {}
    if "users" in root_tree and "users" in root_tree["users"]:
        users_map = root_tree["users"]["users"]
        placeholder_key = None
        for k in users_map.keys():
            if k in ["<name>", "*", "name"]:
                placeholder_key = k
                break
        
        if placeholder_key:
            user_legacy_tree = users_map.pop(placeholder_key)
            if not users_map:
                root_tree["users"].pop("users")

    # 3. ATTACH USER LEGACY
    if "users" in zenos_tree:
        z_users = zenos_tree["users"]
        z_placeholder = None
        for k in z_users.keys():
            if k in ["<name>", "*", "name"]:
                z_placeholder = k
                break
        
        if z_placeholder:
            if not isinstance(z_users[z_placeholder], dict):
                z_users[z_placeholder] = {}
            z_users[z_placeholder]["legacy"] = user_legacy_tree

    # 4. ATTACH LEGACY
    zenos_tree["legacy"] = root_tree

    # 5. PROCESS OPTIONS
    processed_zenos = process_tree(zenos_tree, root_tree, path_prefix="zenos")
    
    # 6. PROCESS PACKAGES
    # [NEW] Process the package catalog from the second JSON file
    processed_packages = {}
    if package_catalog_raw:
        processed_packages = process_package_catalog(package_catalog_raw)

    # 7. OUTPUT
    final_output = {
        "maintainers": {},
        "pkgs": {},
        "options": {}
    }

    if "maintainers" in processed_zenos:
        final_output["maintainers"] = processed_zenos.pop("maintainers").get("sub", {})
    
    # [UPDATED] Populate 'catalog' with the scanned packages
    final_output["pkgs"]["catalog"] = processed_packages

    # Keep 'system-packages' option if it exists (for reference of what is INSTALLED)
    if "system" in processed_zenos and "sub" in processed_zenos["system"]:
        sys_sub = processed_zenos["system"]["sub"]
        if "packages" in sys_sub:
             # Just move it, don't count it as 'packages' since we have a catalog now
             final_output["pkgs"]["system-packages"] = sys_sub.pop("packages")
        if "programs" in sys_sub:
             final_output["pkgs"]["programs"] = sys_sub.pop("programs")

    final_output["options"] = processed_zenos

    return final_output

def main():
    if len(sys.argv) < 2:
        sys.exit(1)

    try:
        raw_data = load_json(sys.argv[1])
        
        # [NEW] Load Packages JSON if provided
        package_catalog_raw = None
        if len(sys.argv) > 2:
            package_catalog_raw = load_json(sys.argv[2])

        is_flat = any("." in k for k in list(raw_data.keys())[:100])
        if is_flat:
            root_tree = unflatten_options(raw_data)
        else:
            root_tree = raw_data

        final_struct = transform_structure(root_tree, package_catalog_raw)
        
        print(":: ZenPkgs Doc Generation Stats ::")
        print(f"   - Native Options: {STATS['options']}")
        print(f"   - Legacy Maps:    {STATS['maps']}")
        print(f"   - Packages:       {STATS['packages']}")
        
        if VALIDATION_ERRORS:
            print("\n" + "="*50)
            print(" [ ! ] METADATA STANDARDS VIOLATION [ ! ]")
            print("="*50)
            for item in VALIDATION_ERRORS:
                print(f"\n>> {item['path']}")
                for err in item['errors']:
                    print(f"   - {err}")
            print("\nBuild FAILED due to strict metadata guidelines.")
            sys.exit(1)

        with open("options.json", 'w') as f:
            json.dump(final_struct, f, indent=2)
            
    except Exception as e:
        sys.stderr.write(f"Error during transform: {str(e)}\n")
        sys.exit(1)

if __name__ == "__main__":
    main()