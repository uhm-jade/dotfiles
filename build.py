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

is_debug = cfg["build"]["debug"]
home_paths = cfg["files"]

destination = repo
if is_debug:
    destination = repo / "test-build"

destination.mkdir(parents=True, exist_ok=True)

for partial_path in home_paths:
    assert not Path(partial_path).is_absolute(), f"Absolute path not allowed: {partial_path}"

    path = home / partial_path
    if path.is_dir():
        joined_path = (destination / partial_path)
        joined_path.mkdir(parents=True,exist_ok=True)
        shutil.copytree(str(path), str(joined_path), dirs_exist_ok=True)
    else:
        shutil.copy(str(path), str(destination))

