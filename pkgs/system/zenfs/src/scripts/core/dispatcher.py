# File: src/scripts/core/dispatcher.py
import sys
import core_service
import roaming_service
import checker
import mint
import attach
import detach
import watcher
import offload

def main():
    if len(sys.argv) < 2:
        print("Usage: zenfs <command> [args]")
        return

    cmd = sys.argv[1]
    
    if cmd == "core":
        core_service.main()
    elif cmd == "roaming":
        roaming_service.main()
    elif cmd == "checker":
        checker.main()
    elif cmd == "watcher":
        watcher.main()
    elif cmd == "offload":
        # Usage: zenfs offload -c config.json
        if len(sys.argv) > 3 and sys.argv[2] == "-c":
            with open(sys.argv[3]) as f:
                cfg_str = f.read()
            offload.main(cfg_str)
        else:
            print("Usage: zenfs offload -c <config_path>")
    elif cmd == "mint":
        if len(sys.argv) < 4:
            print("Usage: zenfs mint <dev> <label> [type]")
            return
        dtype = sys.argv[4] if len(sys.argv) > 4 else "roaming"
        mint.mint(sys.argv[2], sys.argv[3], dtype)
    elif cmd == "attach":
        if len(sys.argv) < 3: return
        attach.attach(sys.argv[2])
    elif cmd == "detach":
        if len(sys.argv) < 3: return
        detach.detach(sys.argv[2])
    else:
        print(f"Unknown command: {cmd}")

if __name__ == "__main__":
    main()