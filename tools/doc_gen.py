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

def create_meta(node_type="container", brief="", description="", default="none", maintainers=None, platforms=None):
    return {
        "type": node_type,
        "brief": brief,
        "description": description,
        "default": default,
        "maintainers": maintainers,
        "platforms": platforms
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
        
        # [FIX] Merge if exists, otherwise assign
        if leaf_key in current and isinstance(current[leaf_key], dict):
            current[leaf_key].update(data)
        else:
            current[leaf_key] = data
        
    return root

# --- PROCESSORS ---

def process_option_node(node, in_legacy=False, current_path="", override_desc=None):
    """Converts a raw option dict to the Meta/Sub format."""
    
    # [LOGIC] If override provided, use it. Otherwise use node description.
    if override_desc:
        full_desc = override_desc
        # If we have an override, we treat it as a native ZenOS description (clean formatted)
        using_override = True
    else:
        raw_desc = node.get("description", "")
        if isinstance(raw_desc, dict):
            full_desc = str(raw_desc.get("text", "")) if "text" in raw_desc else str(raw_desc)
        else:
            full_desc = str(raw_desc)
        using_override = False

    # Check for Auto-Generated Alias (only if NOT overridden)
    is_auto_alias = bool(re.search(r"Alias of.*`", full_desc)) if not using_override else False

    # Formatting Logic
    if in_legacy or is_auto_alias:
        brief = full_desc
        description_rest = ""
    else:
        lines = full_desc.split("\n")
        brief = lines[0].strip() if lines else "No description."
        description_rest = "\n".join(lines[1:]).strip() if len(lines) > 1 else ""

    raw_type = node.get("type", "unknown")
    norm_type = normalize_type(raw_type)
    raw_default = node.get("default", "none")
    clean_def = clean_default(raw_default)
    
    # Validation
    # We validate if:
    # 1. It is NOT legacy
    # 2. AND (It is NOT an auto-alias OR We are using a manual override)
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
    
    # [NEW] Look for _zenpkgs-meta in children
    # This allows aliases (or any option) to have a sibling defining custom metadata.
    meta_override = None
    if "_zenpkgs-meta" in raw_root:
        meta_node = raw_root["_zenpkgs-meta"]
        raw_desc = meta_node.get("description", "")
        if isinstance(raw_desc, dict): raw_desc = raw_desc.get("text", "")
        meta_override = str(raw_desc)
        
    # Also handle standard _meta for containers (backwards compat)
    if "_meta" in raw_root:
        meta_node = raw_root["_meta"]
        raw_desc = meta_node.get("description", "")
        if isinstance(raw_desc, dict): raw_desc = raw_desc.get("text", "")
        if not meta_override: # _zenpkgs-meta takes precedence
            meta_override = str(raw_desc)

    # 1. HYBRID PROCESSING (Node is both Option and Container)
    if raw_root.get("_type") == "zen_option":
        
        # Process the node itself using the override if present
        processed_node = process_option_node(raw_root, in_legacy=in_legacy, current_path=path_prefix, override_desc=meta_override)
        
        # LINKING LOGIC:
        # We need the ORIGINAL description to find the alias target, 
        # because we might have just overwritten 'brief' with custom text.
        original_desc = raw_root.get("description", "")
        if isinstance(original_desc, dict): original_desc = original_desc.get("text", "")
        
        # Check for alias link in original text
        match = re.search(r"Alias of.*`([a-zA-Z0-9\._-]+)`", str(original_desc))
        
        if match:
            # It IS an alias map
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
            # It is a standard option
            if count_stats and not in_legacy: STATS["options"] += 1

        # Merge other children (if any)
        # Note: We skip _meta/_zenpkgs-meta here as they are helpers
        children_processed = {}
        for k, v in raw_root.items():
            if k in ["_meta", "_zenpkgs-meta"] or not isinstance(v, dict): continue
            # Recursive call
            child_prefix = f"{path_prefix}.{k}" if path_prefix else k
            # Pass legacy=True if we are inside a legacy map alias? No, we are in a hybrid.
            child_res = process_tree(v, full_root, in_legacy, count_stats, child_prefix)
            if child_res:
                pass
        

        
        return processed_node

    # 2. STANDARD CONTAINER PROCESSING
    for key, value in raw_root.items():
        if key in ["_meta", "_zenpkgs-meta"]: continue
        
        current_path = f"{path_prefix}.{key}" if path_prefix else key

        # Recurse
        is_legacy = in_legacy or (key == "legacy")
        
        # Check if child is Option or Container
        if isinstance(value, dict):
            child_result = process_tree(value, full_root, in_legacy=is_legacy, count_stats=count_stats, path_prefix=current_path)
            
            # Now we determine if child_result is a "Container Dict" or a "Node Object"
            # Node Object has "meta" key. Container Dict has keys that are option names.
            
            if "meta" in child_result:
                # It's an Option Node (Leaf or Hybrid)
                processed[key] = child_result
            else:
                # It's a Container. We need to wrap it.
                # Use inherited meta if available
                desc = meta_override if meta_override else ""
                brief = desc.split("\n")[0]
                
                # Only wrap if it has content
                if child_result:
                    processed[key] = {
                        "meta": create_meta(node_type="container", brief=brief, description=desc),
                        "sub": child_result
                    }

    return processed

# --- THE TRANSFORM LOGIC ---

def transform_structure(root_tree):
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

    # 5. PROCESS
    processed_zenos = process_tree(zenos_tree, root_tree, path_prefix="zenos")
    
    # 6. OUTPUT (Handle case where processed_zenos is a Node vs Dict)
    # Since zenos_tree is a container, process_tree returns a dict of children, wrapped?
    # No, process_tree on a container returns a dict of processed children (wrapped or nodes).
    # Wait, my logic in Loop B returns: `processed[key] = { meta:..., sub: ...}`
    # So `processed_zenos` is { "system": { meta:..., sub:...}, "desktops": ... }
    
    final_output = {
        "maintainers": {},
        "pkgs": {},
        "options": {}
    }

    if "maintainers" in processed_zenos:
        # maintainers is a Node { meta:..., sub:... }
        final_output["maintainers"] = processed_zenos.pop("maintainers").get("sub", {})
    
    if "system" in processed_zenos and "sub" in processed_zenos["system"]:
        sys_sub = processed_zenos["system"]["sub"]
        if "packages" in sys_sub:
            pkgs_node = sys_sub["packages"]
            # pkgs_node is a Node { meta:..., sub:... } OR a Dict?
            # It's a Node.
            pkg_count = len(pkgs_node.get("sub", {}))
            STATS["packages"] += pkg_count
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
        is_flat = any("." in k for k in list(raw_data.keys())[:100])
        
        if is_flat:
            root_tree = unflatten_options(raw_data)
        else:
            root_tree = raw_data

        final_struct = transform_structure(root_tree)
        
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