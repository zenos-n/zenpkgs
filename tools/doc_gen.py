import json
import sys
import os

def load_json(path):
    with open(path, 'r') as f:
        return json.load(f)

def create_legacy_stub():
    return {
        "description": "Standard NixOS/Home-Manager legacy options.",
        "type": "attrs",
        "_is_legacy_stub": True
    }

def process_node(node):
    if isinstance(node, dict):
        # Leaf node (Option)
        if node.get("_type") == "zen_option":
            # Skip internal options if you want to hide them
            if node.get("internal") == True:
                return None 
            
            return {
                "description": node.get("description", ""),
                "type": str(node.get("type", "unknown")),
                "default": str(node.get("default", "none"))
            }
        
        # Submodule Schema
        if node.get("_type") == "submodule_schema":
            return process_tree(node.get("options", {}))

        # Recursive step
        cleaned = {}
        for k, v in node.items():
            res = process_node(v)
            if res is not None:
                cleaned[k] = res
        return cleaned
    return node

def process_tree(raw_root):
    processed = {}
    for key, value in raw_root.items():
        res = process_node(value)
        if res is not None:
            processed[key] = res
    return processed

def transform_structure(root_options):
    zenos_root = root_options.get("zenos", {})
    
    # 1. Output Base
    output = {
        "legacy": create_legacy_stub()
    }

    # 2. Flatten Zenos Namespaces
    for category in ["system", "desktops", "environment"]:
        if category in zenos_root:
            output[category] = process_node(zenos_root[category])

    # 3. Handle Users (Check root options.users.users OR zenos.users)
    users_raw = None
    
    # Path A: options.users.users (Standard NixOS structure used in your framework)
    if "users" in root_options and "users" in root_options["users"]:
        users_raw = root_options["users"]["users"]
    # Path B: options.zenos.users
    elif "users" in zenos_root:
        users_raw = zenos_root["users"]

    if users_raw:
        # Extract submodule schema
        user_type_info = users_raw.get("type", {})
        if isinstance(user_type_info, dict) and user_type_info.get("_type") == "submodule_schema":
            user_schema = process_tree(user_type_info.get("options", {}))
            
            # Ensure legacy stub exists in user scope
            if "legacy" in user_schema:
                 user_schema["legacy"] = create_legacy_stub()
                 
            output["users"] = { "<name>": user_schema }
        else:
             output["users"] = { "error": "User submodule schema not found." }
    else:
        output["users"] = { "status": "No user options defined." }

    return output

def main():
    if len(sys.argv) < 2:
        print("Usage: python doc_gen.py <json_path>")
        sys.exit(1)

    raw_data = load_json(sys.argv[1])
    final_struct = transform_structure(raw_data)

    output_path = "zenos-options.json"
    with open(output_path, 'w') as f:
        json.dump(final_struct, f, indent=2)

if __name__ == "__main__":
    main()