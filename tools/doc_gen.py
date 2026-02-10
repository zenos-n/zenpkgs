import json
import sys
import os

def load_json(path):
    with open(path, 'r') as f:
        return json.load(f)

# --- STANDARD FORMATTERS ---

def create_meta(node_type="container", brief="", description="", default="none", maintainers=None, platforms=None):
    """Helper to generate the standard meta block."""
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
        current[leaf_key] = data
        
    return root

# --- PROCESSORS ---

def process_option_node(node):
    """Converts a raw option dict to the Meta/Sub format."""
    # Defensive check for description type
    raw_desc = node.get("description", "")
    if isinstance(raw_desc, dict):
        # Handle cases where description might be a complex object (e.g. literal MD)
        full_desc = str(raw_desc.get("text", "")) if "text" in raw_desc else str(raw_desc)
    else:
        full_desc = str(raw_desc)

    lines = full_desc.split("\n")
    brief = lines[0].strip() if lines else "No description."
    description_rest = "\n".join(lines[1:]).strip() if len(lines) > 1 else ""

    type_str = str(node.get("type", "unknown"))
    
    result = {
        "meta": create_meta(
            node_type=type_str,
            brief=brief,
            description=description_rest,
            default=str(node.get("default", "none")),
            maintainers=node.get("maintainers"),
            platforms=node.get("platforms")
        )
    }
    return result

def process_tree(raw_root):
    """Recursively applies Meta/Sub formatting to the tree."""
    processed = {}
    
    # [NEW] 1. Check for Meta-Injection
    # We look for a child key named "_meta". If it exists, we extract its 
    # description to use as the container's brief.
    container_brief = ""
    container_desc = ""
    
    if "_meta" in raw_root:
        meta_node = raw_root["_meta"]
        # In the unflattened tree, this node is a dict with _type="zen_option"
        # We assume the description field holds the text we want.
        raw_desc = meta_node.get("description", "")
        
        # Handle dict descriptions (common in NixOS JSON)
        if isinstance(raw_desc, dict):
            raw_desc = raw_desc.get("text", "")
            
        container_brief = str(raw_desc).split("\n")[0]
        container_desc = str(raw_desc)
    
    for key, value in raw_root.items():
        # [NEW] 2. Skip processing _meta as a regular child
        if key == "_meta":
            continue

        # A. Leaf Option
        if isinstance(value, dict) and value.get("_type") == "zen_option":
            processed[key] = process_option_node(value)
        
        # B. Container
        elif isinstance(value, dict):
            children = process_tree(value)
            if children:
                # [NEW] 3. Apply the injected meta if available, else fallback to key
                brief_text = container_brief if container_brief else f"Category: {key}"
                full_desc = container_desc if container_desc else ""
                
                processed[key] = {
                    "meta": create_meta(
                        node_type="container", 
                        brief=brief_text,
                        description=full_desc
                    ),
                    "sub": children
                }
                
    return processed

# --- THE "FAKE IT" LOGIC ---

def transform_structure(root_tree):
    # 1. CUT OFF ZENOS
    zenos_tree = root_tree.pop("zenos", {})

    # 2. CUT USER LEGACY (users.users.<name>)
    user_legacy_tree = {}
    if "users" in root_tree and "users" in root_tree["users"]:
        users_map = root_tree["users"]["users"]
        placeholder_key = None
        
        # Identify the placeholder (standard NixOS options use "<name>")
        for k in users_map.keys():
            if k in ["<name>", "*", "name"]:
                placeholder_key = k
                break
        
        if placeholder_key:
            user_legacy_tree = users_map.pop(placeholder_key)
            # Remove empty users.users container if needed
            if not users_map:
                root_tree["users"].pop("users")

    # 3. ATTACH USER LEGACY -> zenos.users.<name>.legacy
    if "users" in zenos_tree:
        z_users = zenos_tree["users"]
        z_placeholder = None
        for k in z_users.keys():
            if k in ["<name>", "*", "name"]:
                z_placeholder = k
                break
        
        if z_placeholder:
            # Ensure the user node is a dict we can attach to
            if not isinstance(z_users[z_placeholder], dict):
                z_users[z_placeholder] = {}
            z_users[z_placeholder]["legacy"] = user_legacy_tree

    # 4. ATTACH THE REST -> zenos.legacy
    # Exclude ZenOS from the root before attaching (it's already popped)
    zenos_tree["legacy"] = root_tree

    # 5. META-IFY THE WHOLE ZENOS TREE
    processed_zenos = process_tree(zenos_tree)

    # 6. TOP-LEVEL KEYS SHUFFLE
    final_output = {
        "maintainers": {},
        "pkgs": {},
        "options": {}
    }

    # Extract Maintainers if they exist as a raw sub-tree
    if "maintainers" in processed_zenos:
        final_output["maintainers"] = processed_zenos.pop("maintainers").get("sub", {})
    
    # Extract Packages/Programs for the 'pkgs' view
    if "system" in processed_zenos and "sub" in processed_zenos["system"]:
        sys_sub = processed_zenos["system"]["sub"]
        if "packages" in sys_sub:
            final_output["pkgs"]["system-packages"] = sys_sub.pop("packages")
        if "programs" in sys_sub:
             final_output["pkgs"]["programs"] = sys_sub.pop("programs")

    # The rest remains in options
    final_output["options"] = processed_zenos

    return final_output

def main():
    if len(sys.argv) < 2:
        sys.exit(1)

    try:
        raw_data = load_json(sys.argv[1])
        
        # Check if flat (dots in keys)
        is_flat = any("." in k for k in list(raw_data.keys())[:100])
        
        if is_flat:
            root_tree = unflatten_options(raw_data)
        else:
            root_tree = raw_data

        final_struct = transform_structure(root_tree)

        with open("options.json", 'w') as f:
            json.dump(final_struct, f, indent=2)
            
    except Exception as e:
        sys.stderr.write(f"Error during transform: {str(e)}\n")
        sys.exit(1)

if __name__ == "__main__":
    main()