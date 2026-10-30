"""Exercise upstream writers without touching the real user's home or ADB server."""
import os
from pathlib import Path
import subprocess
import sys
import tempfile

adb, recorder = sys.argv[1:]
with tempfile.TemporaryDirectory() as directory:
    home = Path(directory)
    android = home / '.private/Config/android'
    android.mkdir(parents=True)
    public = home / 'public-working-directory'
    public.mkdir()
    env = dict(os.environ, HOME=str(home), ANDROID_USER_HOME=str(android),
               ADB_MDNS_AUTO_CONNECT='none', ADB_LIBUSB='0')
    subprocess.run([adb, 'keygen', str(android / 'adbkey')], env=env, cwd=public,
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
    subprocess.run([adb, 'keygen', 'relative-key'], env=env, cwd=public,
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
    assert (public / 'relative-key').is_file(), 'ADB must preserve the caller working directory'
    identity = (android / 'adbkey').read_bytes()
    # An isolated filesystem socket cannot collide with the user's server.
    server = ['-L', 'localfilesystem:' + str(home / 'adb-test.sock')]
    try:
        subprocess.run([adb, *server, 'devices'], env=env, cwd=public,
                       check=True, timeout=15, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        assert not (home / '.android').exists()
        assert (android / 'adbkey').read_bytes() == identity
        assert (home / '.private/Packages/android-tools/.android').resolve() == android
    finally:
        subprocess.run([adb, *server, 'kill-server'], env=env, timeout=10,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    subprocess.run([recorder, '--help'], env=env, cwd=public, timeout=10,
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    assert not (home / '.nv').exists()
    profile = home / '.private/Packages/gpu-screen-recorder/.nv/nvidia-application-profiles-rc.d/10-gsr-cuda-no-stable-perf-limit'
    assert profile.is_file()
    assert public.is_dir()
print('ADB identity and recorder profiles remain private')
