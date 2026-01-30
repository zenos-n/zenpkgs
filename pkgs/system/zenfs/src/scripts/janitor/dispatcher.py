import sys
import dumb
import music_fuse
import ml

def main():
    if len(sys.argv) < 3:
        print("Usage: zenfs-janitor <submodule> <config_path>")
        return

    module = sys.argv[1]
    config = sys.argv[2]
    
    if module == "dumb":
        dumb.main(config)
    elif module == "music":
        music_fuse.main(config)
    elif module == "ml":
        ml.main(config)
    else:
        print("Unknown submodule")

if __name__ == "__main__":
    main()