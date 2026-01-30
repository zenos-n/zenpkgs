# File: src/scripts/janitor/music_fuse.py
import os
import sys
import errno
import fuse
import time
import re
import threading
from pathlib import Path
import mutagen
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class MusicIndexer:
    def __init__(self, source_dir, split_symbols):
        self.source_dir = Path(source_dir)
        self.split_symbols = split_symbols # List of delimiters/regex
        self.tree = {} # { virtual_path_str: real_path_str }
        self.dirs = set() # { virtual_dir_str }
        self.lock = threading.Lock()
        
    def _parse_artist(self, tag_artist):
        if not tag_artist: return ["Unknown"]
        # Normalize delimiters
        artists = [tag_artist]
        
        for sym in self.split_symbols:
            new_list = []
            is_regex = sym.startswith("zenfs-reg:")
            pattern = sym[10:] if is_regex else re.escape(sym)
            
            for art in artists:
                # split
                parts = re.split(pattern, art)
                new_list.extend([p.strip() for p in parts if p.strip()])
            artists = new_list
            
        return artists if artists else ["Unknown"]

    def _add_to_tree(self, v_path, r_path):
        # Add file
        self.tree[str(v_path)] = str(r_path)
        # Add parent dirs
        parent = v_path.parent
        while str(parent) != ".":
            self.dirs.add(str(parent))
            parent = parent.parent

    def scan(self):
        print("Scanning Music Library...")
        new_tree = {}
        new_dirs = set()
        
        for root, _, files in os.walk(self.source_dir):
            for f in files:
                real_path = Path(root) / f
                try:
                    audio = mutagen.File(real_path, easy=True)
                    if not audio: continue
                    
                    # Tags
                    # easy=True gives standard keys: artist, album, title, date, genre, albumartist
                    title = audio.get('title', [f.rsplit('.', 1)[0]])[0]
                    album = audio.get('album', ['Unknown'])[0]
                    # Dates often come as lists or strings "2024-01-01"
                    date = audio.get('date', ['0000'])[0]
                    year = date[:4]
                    genre = audio.get('genre', ['Unknown'])[0]
                    
                    # Artists
                    artist_raw = audio.get('artist', ['Unknown'])[0]
                    album_artist_raw = audio.get('albumartist', [''])[0]
                    
                    artists = self._parse_artist(artist_raw)
                    album_artist = album_artist_raw if album_artist_raw else (artists[0] if artists else "Unknown")
                    
                    ext = f.split('.')[-1]
                    filename = f"{title}.{ext}" # Simplified filename logic
                    
                    # 1. Artists/{Artist}/...
                    for art in artists:
                        # Logic:
                        # Singles: AlbumArtist empty OR Album == Title
                        # Features: Art != AlbumArtist
                        # Albums: Standard
                        
                        v_base = Path("Artists") / art
                        
                        is_single = (not album_artist_raw) or (album == title)
                        is_feat = (art != album_artist) and (not is_single)
                        
                        if is_single:
                            v_path = v_base / "Singles" / filename
                        elif is_feat:
                            v_path = v_base / "Features" / filename
                        else:
                            v_path = v_base / "Albums" / album / filename
                            
                        # Add to local temporary structures
                        new_tree[str(v_path)] = str(real_path)
                        # Helper for dirs logic (duplicated below for thread safety later)
                        p = v_path.parent
                        while str(p) != ".":
                            new_dirs.add(str(p))
                            p = p.parent

                    # 2. Genres
                    new_tree[str(Path("Genres") / genre / filename)] = str(real_path)
                    
                    # 3. Years
                    # Need month? 'date' usually YYYY-MM-DD
                    month = "Unknown"
                    if len(date) >= 7: month = date[5:7]
                    new_tree[str(Path("Years") / year / month / filename)] = str(real_path)
                    
                    # 4. Soundtracks
                    if "Soundtrack" in genre:
                        new_tree[str(Path("Soundtracks") / album / filename)] = str(real_path)

                except Exception as e:
                    # print(f"Error parsing {f}: {e}")
                    pass
        
        # Atomic swap
        with self.lock:
            self.tree = new_tree
            self.dirs = new_dirs
        print(f"Scan complete. {len(self.tree)} virtual files.")

class ZenMusicFS(fuse.Operations):
    def __init__(self, indexer):
        self.indexer = indexer

    def getattr(self, path, fh=None):
        path = path.lstrip("/")
        with self.indexer.lock:
            # Root
            if path == "":
                return dict(st_mode=(0o40000 | 0o755), st_nlink=2)
            
            # Directory
            if path in self.indexer.dirs:
                return dict(st_mode=(0o40000 | 0o755), st_nlink=2)
            
            # File
            if path in self.indexer.tree:
                real_path = self.indexer.tree[path]
                st = os.lstat(real_path)
                return dict(st_mode=(0o100000 | 0o444), st_nlink=1, size=st.st_size, st_ctime=st.st_ctime, st_mtime=st.st_mtime, st_atime=st.st_atime)
        
        raise fuse.FuseOSError(errno.ENOENT)

    def readdir(self, path, fh):
        path = path.lstrip("/")
        dirents = ['.', '..']
        
        with self.indexer.lock:
            # We need to find all keys in tree/dirs that are immediate children of path
            # This is O(N) where N is total nodes. Inefficient for huge libs, but acceptable for Python prototype.
            # Optimization: Pre-calculate children in Indexer.
            
            # Check Dirs
            for d in self.indexer.dirs:
                p = Path(d)
                if str(p.parent) == path or (path == "" and str(p.parent) == "."):
                    dirents.append(p.name)
            
            # Check Files
            for f in self.indexer.tree.keys():
                p = Path(f)
                if str(p.parent) == path or (path == "" and str(p.parent) == "."):
                    dirents.append(p.name)
                    
        return list(set(dirents))

    def open(self, path, flags):
        path = path.lstrip("/")
        with self.indexer.lock:
            if path in self.indexer.tree:
                return os.open(self.indexer.tree[path], flags)
        raise fuse.FuseOSError(errno.ENOENT)

    def read(self, path, length, offset, fh):
        os.lseek(fh, offset, os.SEEK_SET)
        return os.read(fh, length)

    def release(self, path, fh):
        return os.close(fh)

class WatchHandler(FileSystemEventHandler):
    def __init__(self, indexer):
        self.indexer = indexer
    def on_any_event(self, event):
        # Debounce or just trigger?
        # For music lib, full re-scan is heavy. 
        # Ideally we patch the tree, but lazy approach: re-scan on separate thread.
        threading.Thread(target=self.indexer.scan).start()

def main(config_path):
    import json
    with open(config_path) as f:
        full_config = json.load(f)
    
    music_cfg = full_config.get("music", {})
    if not music_cfg.get("enable", False): return

    source = music_cfg.get("sourceDir")
    mount = music_cfg.get("mountPoint")
    splits = music_cfg.get("artistSplitSymbols", [";"])
    
    if not source or not mount: return
    
    if not os.path.exists(mount):
        os.makedirs(mount)
    
    indexer = MusicIndexer(source, splits)
    indexer.scan()
    
    # Watcher
    obs = Observer()
    obs.schedule(WatchHandler(indexer), source, recursive=True)
    obs.start()
    
    # FUSE
    fuse.FUSE(ZenMusicFS(indexer), mount, nothreads=False, foreground=True, allow_other=True)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1])