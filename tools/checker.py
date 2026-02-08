import json
import os
import sys
import subprocess
import re

RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
RESET = "\033[0m"
BOLD = "\033[1m"

def highlight_errors(text):
    return re.sub(r'(error:)', f'{RED}\\1{RESET}', text)

def log_err(path, msg):
    print(f"{RED}[FAIL]{RESET} {BOLD}{path}{RESET}: {msg}")

def log_warn(path, msg):
    print(f"{YELLOW}[WARN]{RESET} {BOLD}{path}{RESET}: {msg}")

def log_pass(path):
    pass

def check_first_line_rule(text, path):
    if not text:
        log_err(path, "Description is empty")
        return False

    lines = text.split('\n')
    summary = lines[0].strip()
    errors = []
    
    if not summary:
        log_err(path, "Summary line is empty")
        return False

    if len(summary) > 80:
        errors.append(f"Summary exceeds 80 chars (Length: {len(summary)})")
    
    if not summary[0].isupper() and summary[0].isalpha():
        errors.append("Summary must start with a capital letter")
    
    if summary.endswith('.'):
        errors.append("Summary must NOT end with a period")
        
    if len(lines) > 1:
        if lines[1].strip() != "":
            errors.append("Summary must be followed by a blank line (First Line Rule)")

    if errors:
        for e in errors:
            log_err(path, e)
        return False
    return True

def get_data():
    print(f"{BOLD}:: Evaluating ZenPkgs Structure...{RESET}")
    nix_expr = r"""
    let
      # --- INLINED BUILDER LOGIC ---
      buildTree = pkgs: dir:
        if !builtins.pathExists dir then {} else
        let
           inherit (builtins) readDir pathExists;
           inherit (pkgs.lib) filterAttrs mapAttrs' nameValuePair hasSuffix removeSuffix;
           
           entries = readDir dir;
           
           tree = mapAttrs' (name: type:
             let
               nodePath = dir + "/" + name;
               isNix = hasSuffix ".nix" name;
               baseName = removeSuffix ".nix" name;
             in
               if type == "directory" then
                 if pathExists (nodePath + "/default.nix") then
                   nameValuePair name (pkgs.callPackage nodePath { })
                 else
                   nameValuePair name (buildTree pkgs nodePath)
               else if type == "regular" && isNix && name != "default.nix" then
                  nameValuePair baseName (pkgs.callPackage nodePath { })
               else
                  nameValuePair name null
           ) entries;
        in filterAttrs (n: v: v != null) tree;

      # --- OVERLAY SETUP ---
      pkgsOverlay = final: prev: {
        zenos = buildTree final ./pkgs;
      };

      pkgs = import <nixpkgs> { 
        config.allowUnfree = true; 
        overlays = [ pkgsOverlay ];
      };
      lib = pkgs.lib;
      
      # --- MODULE EVAL ---
      mockLoaders = { loadModules = dir: []; loadLib = dir: {}; };

      eval = lib.evalModules {
        modules = [ 
            @MODULES@ 
            ({ ... }: { system.stateVersion = "24.05"; })
        ];
        specialArgs = { loaders = mockLoaders; };
        check = false;
      };
      
      options = eval.options;

      # --- WALKERS ---
      walkOptions = opts: prefix:
        lib.mapAttrs (name: opt: 
          let currPath = if prefix == "" then name else prefix + "." + name; in
          if lib.isOption opt then
             {
               _type = "option";
               path = currPath;
               description = opt.description or null;
               longDescription = if (builtins.hasAttr "longDescription" opt) then opt.longDescription else null;
             }
          else 
             walkOptions opt currPath
        ) opts;

      walkPackages = tree: prefix:
        lib.mapAttrs (name: val:
          let currPath = if prefix == "" then name else prefix + "." + name; in
          if lib.isDerivation val then
            {
              _type = "package";
              path = currPath;
              description = val.meta.description or null;
              longDescription = val.meta.longDescription or null;
              maintainers = val.meta.maintainers or [];
              license = val.meta.license or null;
              platforms = val.meta.platforms or [];
            }
          else if builtins.isAttrs val then
            walkPackages val currPath
          else
            null
        ) tree;
      
    in
      # FIXED: Removed builtins.toJSON wrapper to prevent double-encoding
      {
        options = walkOptions options "";
        packages = walkPackages pkgs.zenos "zenos";
      }
    """
    
    cmd = ["nix-instantiate", "--eval", "--strict", "--json", "-E", nix_expr]
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    if result.returncode != 0:
        print(f"{RED}[CRITICAL]{RESET} Mathematical Soundness Failure: Nix Evaluation Failed.")
        print(f"This implies infinite recursion, syntax errors, or invalid module imports.")
        print(f"\n{YELLOW}Nix Error Log:{RESET}\n{highlight_errors(result.stderr)}")
        sys.exit(1)
    
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as e:
        print(f"{RED}[FATAL]{RESET} Failed to parse Nix output as JSON.")
        print(f"Output preview: {result.stdout[:200]}...")
        print(f"Error: {e}")
        sys.exit(1)

def flatten_tree(node, acc=None):
    if acc is None: acc = []
    if isinstance(node, dict):
        if "_type" in node and (node["_type"] == "option" or node["_type"] == "package"):
            acc.append(node)
        else:
            for k, v in node.items():
                flatten_tree(v, acc)
    return acc

def main():
    try:
        data = get_data()
    except Exception as e:
        print(f"{RED}[FATAL]{RESET} An unexpected error occurred: {e}")
        sys.exit(1)

    print(f"{BOLD}:: Verifying Metadata Guidelines...{RESET}")
    
    all_items = flatten_tree(data.get("options", {})) + flatten_tree(data.get("packages", {}))
    
    # Filter: Only check 'zenos' namespace items
    items_to_check = [i for i in all_items if i["path"].startswith("zenos")]
    
    print(f"Checking {len(items_to_check)} items (Options & Packages)...")
    
    failed = 0
    
    for item in items_to_check:
        path = item["path"]
        
        # 1. Mandatory Description
        if not item.get("description"):
            log_err(path, "Missing mandatory 'description'")
            failed += 1
            continue

        # 2. Forbidden longDescription (First Line Rule Enforcement)
        if item.get("longDescription"):
            log_err(path, "Contains forbidden attribute 'longDescription'. Merge into 'description'.")
            failed += 1

        # 3. First Line Rule
        if not check_first_line_rule(item["description"], path):
            failed += 1
            
        # 4. Package Specific Checks
        if item.get("_type") == "package":
            if not item.get("maintainers"):
                log_err(path, "Missing mandatory 'meta.maintainers' list")
                failed += 1
            if not item.get("license"):
                 pass # Warning optional

    print("-" * 40)
    if failed > 0:
        print(f"{RED}FAILED{RESET}: {failed} violations found.")
        sys.exit(1)
    else:
        print(f"{GREEN}SUCCESS{RESET}: All Zenos artifacts passed integrity checks.")
        print(f"{GREEN}SOUNDNESS{RESET}: Tree evaluated without errors.")

if __name__ == "__main__":
    main()