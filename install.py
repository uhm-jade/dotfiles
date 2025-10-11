import os
import subprocess
import shutil
import tomllib
from pathlib import Path

home = Path(os.path.expanduser("~"))
script = Path(os.path.abspath(__file__))

repo = script.parent # look a roblox reference

with open(str(script.parent / "config.toml"), "rb") as f:
    cfg = tomllib.load(f)

home_paths = cfg["files"]

def copy_if_not_exists(src, dst):
    if os.path.exists(dst):
        return
    shutil.copy2(src, dst)

source = repo
destination = home
if cfg["install"]["debug"]:
    destination = repo / "test-install"
if cfg["build"]["debug"]:
    source = repo / "test-build"
    destination.mkdir(parents=True, exist_ok=True)

if cfg["install"]["merge"]:
    for partial_path in home_paths:
        assert not Path(partial_path).is_absolute(), f"Absolute path not allowed: {partial_path}"

        if (source / partial_path).is_dir():
            joined_path = (destination / partial_path)
            joined_path.mkdir(parents=True,exist_ok=True)
            shutil.copytree(str(source / partial_path), str(joined_path), dirs_exist_ok=True, copy_function=copy_if_not_exists)
        else:
            # Avoid overwriting files
            if not (destination / partial_path).is_file():
                shutil.copy(str(source / partial_path), str(destination))
else:
    raise Exception("Yo i havent implemented that yet ok!")
