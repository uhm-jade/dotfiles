import os
import subprocess
import shutil
import tomllib
from pathlib import Path

home = Path(os.path.expanduser("~"))
script = Path(os.path.abspath(__file__))

repo = script.parent # look a roblox reference

with open("config.toml", "rb") as f:
    cfg = tomllib.load(f)

is_debug = cfg["debug"]
home_paths = cfg["copy_from"]["home"]

destination = repo if not is_debug
destination = repo / "test" if is_debug

destination.mkdir(parents=True, exist_ok=True)

# print("home_directory is " + home_directory)

for partial_path in home_paths:
    assert not Path(partial_path).is_absolute(), f"Absolute path not allowed: {partial_path}"

    path = home / partial_path
    if path.is_dir():
        joined_path = (destination / partial_path)
        joined_path.mkdir(parents=True,exist_ok=True)
        shutil.copytree(str(path), str(joined_path), dirs_exist_ok=True)
    else:
        shutil.copy(str(path), str(destination))


# subprocess.run(["ls", "-l", home_directory + paths[0]])

