import json
import re
import sys
import os

STATS = {
    "system_options": 0,
    "program_options": 0,
    "user_options": 0,
    "maps": 0,
    "packages": 0,
    "legacy_options": 0,
    "legacy_packages": 0
}

VALIDATION_ERRORS = []

def load_json(path):
    with open(path, 'r') as f:
        return json.load(f)

# --- VALIDATION ---
def validate_node(node, brief, path, is_package=False):
    errors = []
    if not brief or brief == "No description.":
        errors.append("Description is missing or empty.")
    else:
        if len(brief) > 80: errors.append(f"Summary exceeds 80 chars.")
        if brief and brief[0].isalpha() and not brief[0].isupper(): errors.append(f"Summary must start with capital.")
        if brief.endswith('.'): errors.append(f"Summary must NOT end with a period.")

    if is_package:
        if not node.get("maintainers"): errors.append("Missing 'maintainers'.")

    if errors:
        VALIDATION_ERRORS.append({ "path": path, "errors": errors })

# --- NORMALIZERS ---
def normalize_type(type_obj):
    if isinstance(type_obj, dict): type_str = str(type_obj.get('name', 'unknown')).lower()
    else: type_str = str(type_obj).lower()
    
    if "one of" in type_str:
        try:
            return { "enum": [x.strip().strip('"').strip("'") for x in type_str.split("one of", 1)[1].split(',') if x.strip()] }
        except: return { "enum": [] }
    if any(x in type_str for x in ["boolean", "bool"]): return "boolean"
    if any(x in type_str for x in ["list of", "list"]): return "array"
    if any(x in type_str for x in ["attribute set", "submodule"]): return "set"
    if any(x in type_str for x in ["int", "float", "number"]): return "number"
    if any(x in type_str for x in ["string", "path"]): return "string"
    return "unknown"

def clean_default(val):
    if isinstance(val, dict) and val.get('_type') == 'literalExpression': return str(val.get('text', ''))
    return "none" if val is None else str(val)

def create_meta(node_type="container", brief="", description="", default="none", maintainers=None, platforms=None, dependencies=None):
    return {
        "type": node_type, "brief": brief, "description": description,
        "default": default, "maintainers": maintainers, "platforms": platforms,
        "dependencies": dependencies or [] 
    }

def get_description_text(node):
    """Safely extracts description text from string or dict."""
    desc = node.get("description", "")
    if isinstance(desc, dict):
        return str(desc.get("text", ""))
    return str(desc)

# --- PROCESSORS ---
def process_option_node(node, in_legacy=False, current_path="", override_desc=None):
    using_override = bool(override_desc)
    full_desc = override_desc if using_override else get_description_text(node)
    
    is_auto_alias = bool(re.search(r"Alias of.*`", full_desc)) if not using_override else False
    
    if in_legacy or is_auto_alias:
        brief, description_rest = full_desc, ""
    else:
        lines = full_desc.split("\n")
        brief = lines[0].strip() if lines else "No description."
        description_rest = "\n".join(lines[1:]).strip() if len(lines) > 1 else ""

    norm_type = normalize_type(node.get("type", "unknown"))
    
    if not in_legacy and (not is_auto_alias or using_override):
        is_pkg = norm_type == "package" or (isinstance(norm_type, str) and "package" in norm_type)
        validate_node(node, brief, current_path, is_package=is_pkg)

    return {
        "meta": create_meta(
            node_type=norm_type, brief=brief, description=description_rest,
            default=clean_default(node.get("default")), maintainers=node.get("maintainers"),
            platforms=node.get("platforms")
        )
    }

def process_package_catalog(raw_tree, path_prefix="pkgs"):
    processed = {}
    for key, value in raw_tree.items():
        current_path = f"{path_prefix}.{key}"
        if isinstance(value, dict) and value.get("_type") == "zen_package":
            raw_desc = value.get("meta", {}).get("description", "")
            lines = str(raw_desc).split("\n")
            brief = lines[0].strip() if lines else "No description."
            desc = "\n".join(lines[1:]).strip()
            validate_node(value.get("meta", {}), brief, current_path, is_package=True)
            processed[key] = {
                "meta": create_meta("package", brief, desc, maintainers=value.get("meta", {}).get("maintainers"),
                platforms=value.get("meta", {}).get("platforms"), dependencies=value.get("dependencies"))
            }
            STATS["packages"] += 1
        elif isinstance(value, dict):
            children = process_package_catalog(value, current_path)
            if children: processed[key] = { "meta": create_meta("container", f"Category: {key}"), "sub": children }
    return processed

def process_tree(raw_root, path_prefix=""):
    processed = {}
    
    # Check for meta override
    meta_override = None
    if "_zenpkgs-meta" in raw_root:
        meta_override = get_description_text(raw_root["_zenpkgs-meta"])
    elif "_meta" in raw_root and not meta_override:
        meta_override = get_description_text(raw_root["_meta"])

    # Hybrid Option Check (Nodes that are Options AND Containers)
    if raw_root.get("_type") == "zen_option":
        processed_node = process_option_node(raw_root, in_legacy="legacy" in path_prefix, current_path=path_prefix, override_desc=meta_override)
        
        # [FIX] Recursively process children of hybrid options (e.g., programs, users)
        hybrid_sub = {}
        for key, value in raw_root.items():
            # Skip metadata and option attributes (strings/lists/dicts that aren't children)
            if key in ["_meta", "_zenpkgs-meta", "_type"]: continue
            if key in ["type", "default", "description", "example", "declarations", "loc", "relatedPackages", "readOnly", "visible", "internal", "apply"]: continue
            
            if isinstance(value, dict):
                current_path = f"{path_prefix}.{key}" if path_prefix else key
                child_result = process_tree(value, path_prefix=current_path)
                
                if "meta" in child_result:
                    hybrid_sub[key] = child_result
                else:
                    # It returned a container dict, wrap it
                    if key in ["<name>", "*"]:
                        normalized_key = "<name>"
                        hybrid_sub[normalized_key] = {
                            "meta": create_meta("container", "User specific configuration placeholder"),
                            "sub": child_result
                        }
                    elif child_result:
                         hybrid_sub[key] = { 
                             "meta": create_meta("container", f"Category: {key}"), 
                             "sub": child_result 
                         }
        
        if hybrid_sub:
            processed_node["sub"] = hybrid_sub

        # Stats logic - FIXED ORDER & LOGIC
        # 1. Check if we are inside legacy first
        if "legacy" in path_prefix: 
            # Differentiate Legacy Maps (Aliases) vs Legacy Options
            # Strict Map Check: Must have a custom override OR be a direct alias
            desc = processed_node["meta"]["description"] + processed_node["meta"]["brief"]
            is_map = bool(meta_override) or ("Alias of" in desc and "legacy" in path_prefix)
            
            if is_map:
                 STATS["maps"] += 1
            else:
                 STATS["legacy_options"] += 1
        
        # 2. Check for Program Modules (zenos.system.programs OR zenos.users.<name>.programs)
        # We must verify we are NOT in legacy to avoid counting legacy.programs.x
        elif ".programs." in path_prefix or path_prefix.endswith(".programs"): 
            STATS["program_options"] += 1
            
        # 3. Check for User Modules
        elif "zenos.users." in path_prefix: 
            STATS["user_options"] += 1
            
        # 4. Default to System Option
        else: 
            STATS["system_options"] += 1
        
        return processed_node

    # Standard Container Processing
    for key, value in raw_root.items():
        if key in ["_meta", "_zenpkgs-meta"]: continue
        
        current_path = f"{path_prefix}.{key}" if path_prefix else key
        
        if isinstance(value, dict):
            child_result = process_tree(value, path_prefix=current_path)
            
            if "meta" in child_result:
                processed[key] = child_result
            else:
                desc = meta_override if meta_override else ""
                brief = desc.split("\n")[0]
                
                if key in ["<name>", "*"]:
                     normalized_key = "<name>"
                     processed[normalized_key] = {
                        "meta": create_meta("container", "User specific configuration placeholder"),
                        "sub": child_result
                     }
                elif child_result:
                    processed[key] = { "meta": create_meta("container", brief, desc), "sub": child_result }

    return processed

def unflatten_options(flat_options):
    root = {}
    for dot_path, data in flat_options.items():
        parts = dot_path.split('.')
        current = root
        for part in parts[:-1]:
            if part not in current: current[part] = {}
            if not isinstance(current[part], dict): current[part] = {} 
            current = current[part]
        leaf = parts[-1]
        data["_type"] = "zen_option"
        if leaf in current and isinstance(current[leaf], dict): current[leaf].update(data)
        else: current[leaf] = data
    return root

def main():
    try:
        raw = load_json(sys.argv[1])
        pkgs_raw = load_json(sys.argv[2]) if len(sys.argv) > 2 else None
        
        root = unflatten_options(raw) if any("." in k for k in list(raw.keys())[:100]) else raw
        
        # 1. Clean Zenos Root
        zenos = root.pop("zenos", {})
        
        # 2. Handle Users (Remove standard NixOS users garbage)
        if "users" in root and "users" in root["users"]:
            u = root["users"]["users"]
            for k in ["<name>", "*", "name"]:
                 if k in u: 
                    u.pop(k)
                    if not u: root["users"].pop("users")
                    break

        zenos["legacy"] = root
        
        processed_opts = process_tree(zenos, path_prefix="zenos")
        processed_pkgs = process_package_catalog(pkgs_raw) if pkgs_raw else {}
        processed_pkgs["legacy"] = { "meta": create_meta("container", "Upstream NixPkgs", "Access via zenos.system.packages.legacy"), "sub": {} }
        
        # Stats for legacy packages (placeholder count)
        STATS["legacy_packages"] = 1 # Counting the 'legacy' container itself

        final = {
            "maintainers": processed_opts.pop("maintainers", {}).get("sub", {}) if "maintainers" in processed_opts else {},
            "pkgs": processed_pkgs,
            "options": processed_opts
        }

        print(":: ZenPkgs Doc Generation Stats ::")
        print(f"   - System Options:  {STATS['system_options']}")
        print(f"   - Program Options: {STATS['program_options']}")
        print(f"   - User Options:    {STATS['user_options']}")
        print(f"   - Legacy Maps:     {STATS['maps']}")
        print(f"   - Packages:        {STATS['packages']}")
        print(f"   - Legacy Options:  {STATS['legacy_options']}")
        print(f"   - Legacy Packages: {STATS['legacy_packages']}")

        with open("options.json", 'w') as f: json.dump(final, f, indent=2)

    except Exception as e:
        sys.stderr.write(f"Error: {str(e)}\n")
        sys.exit(1)

if __name__ == "__main__":
    main()