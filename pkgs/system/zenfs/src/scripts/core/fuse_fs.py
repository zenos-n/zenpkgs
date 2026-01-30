# File: src/scripts/core/fuse_fs.py
import os
import sys
import errno
import fuse
from pathlib import Path
from common import ROAMING_ROOT

class ZenFS(fuse.Operations):
    def __init__(self, source, mountpoint):
        self.source = source
        self.mountpoint = mountpoint
        # Enable Union Logic only for /Users
        self.is_union = (mountpoint == "/Users")

    def _get_real_path(self, path):
        # path is relative to mount point (e.g., /Documents/file.txt)
        
        # 1. Check Local Source (Mirror)
        # e.g. /home/Documents/file.txt or /nix/store/...
        local_path = os.path.join(self.source, path.lstrip("/"))
        
        # If simple mirror, or if file exists locally, return local
        if not self.is_union:
            return local_path, "local"
        
        if os.path.exists(local_path):
            return local_path, "local"

        # 2. Check Roaming Logic (Union Mode Only)
        # Check all mounted roaming drives for the file
        parts = path.strip("/").split("/")
        if len(parts) >= 1:
            if ROAMING_ROOT.exists():
                for drive in ROAMING_ROOT.iterdir():
                    # Check: /Mount/Roaming/<UUID>/Users/<path>
                    # Note: We hardcode 'Users' here because Union mode is specifically for /Users
                    roaming_target = drive / "Users" / path.lstrip("/")
                    if roaming_target.exists():
                        return str(roaming_target), "roaming"

        return local_path, "missing"

    # --- Filesystem Operations ---

    def getattr(self, path, fh=None):
        real_path, source = self._get_real_path(path)
        
        if source == "missing":
            raise fuse.FuseOSError(errno.ENOENT)

        st = os.lstat(real_path)
        return dict((key, getattr(st, key)) for key in ('st_atime', 'st_ctime',
                     'st_gid', 'st_mode', 'st_mtime', 'st_nlink', 'st_size', 'st_uid'))

    def readdir(self, path, fh):
        dirents = ['.', '..']
        
        # 1. List Local Files
        local_path = os.path.join(self.source, path.lstrip("/"))
        if os.path.exists(local_path):
            dirents.extend(os.listdir(local_path))
            
        # 2. List Roaming Files (Union Mode Only)
        if self.is_union and ROAMING_ROOT.exists():
            for drive in ROAMING_ROOT.iterdir():
                roaming_target = drive / "Users" / path.lstrip("/")
                if roaming_target.exists() and roaming_target.is_dir():
                    dirents.extend(os.listdir(roaming_target))
        
        return list(set(dirents))

    def readlink(self, path):
        real_path, _ = self._get_real_path(path)
        # For symlinks, we read the target of the *real* file
        if os.path.islink(real_path):
            target = os.readlink(real_path)
            # If the link is relative, it should still work relative to the FUSE mount
            return target
        return path

    # --- File Methods (Passthrough) ---

    def open(self, path, flags):
        real_path, source = self._get_real_path(path)
        if source == "missing": raise fuse.FuseOSError(errno.ENOENT)
        return os.open(real_path, flags)

    def read(self, path, length, offset, fh):
        os.lseek(fh, offset, os.SEEK_SET)
        return os.read(fh, length)

    def write(self, path, buf, offset, fh):
        os.lseek(fh, offset, os.SEEK_SET)
        return os.write(fh, buf)

    def release(self, path, fh):
        return os.close(fh)
    
    def create(self, path, mode, fi=None):
        real_path, _ = self._get_real_path(path)
        return os.open(real_path, os.O_WRONLY | os.O_CREAT, mode)

    def unlink(self, path):
        real_path, _ = self._get_real_path(path)
        return os.unlink(real_path)

    def rmdir(self, path):
        real_path, _ = self._get_real_path(path)
        return os.rmdir(real_path)

    def mkdir(self, path, mode):
        real_path, _ = self._get_real_path(path)
        return os.mkdir(real_path, mode)

def main():
    if len(sys.argv) < 3:
        print("Usage: zenfs-fuse <mirror_source> <mount_point>")
        sys.exit(1)
    
    source = sys.argv[1]
    mountpoint = sys.argv[2]
    
    # allow_other is crucial for system visibility
    fuse.FUSE(ZenFS(source, mountpoint), mountpoint, nothreads=True, foreground=True, allow_other=True)

if __name__ == '__main__':
    main()