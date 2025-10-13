#!/usr/bin/env bash
set -e

echo "Dotfiles requested! You've got it boss!"

echo "Setting up windows specific stuff..."
if command -v cmd.exe >/dev/null 2>&1; then
	echo "WINDOWS USER DETECTED! 🚩🚩🚩"

	if [ -d "$HOME/user" ]; then
		echo "Found link to windows user directory"
	else
		echo "Creating link to windows user directory..."
		echo ""
		user_name=$(cmd.exe /c echo %username%)
		user_name=${user_name%$'\r'} # remove trailing carriage return
		user_dir="/mnt/c/Users/$user_name"
		ln -s "$user_dir" "${HOME}/user"
		echo "Link created in ${HOME}/user"
		echo "Done!"
	fi
fi

echo "Installing dotfiles..."

DOTFILES_REPO="https://github.com/uhm-jade/dotfiles.git"

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"

# Clone the bare repo if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
	git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

alias dotfiles="/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
shopt -s expand_aliases # For script to use alias

# Backup any existing dotfiles that would be overwritten
mkdir -p "$BACKUP_DIR"

conflicts=$(dotfiles checkout 2>&1 | grep "^\s" | awk '{print $1}')

if [ -n "$conflicts" ]; then
	echo "Backing up existing files to $BACKUP_DIR:"
	echo "$conflicts"
	for file in $conflicts; do
		mkdir -p "$(dirname "$BACKUP_DIR/$file")"

		cp "$HOME/$file" "$BACKUP_DIR/$file"
	done
fi

# Hide untracked files
dotfiles config --local status.showUntrackedFiles no

echo "Pulling latest changes from GitHub..."

# Save local changes (if any) temporarily
dotfiles stash push -m "Auto-stash before pull" || true

# Pull from GitHub
dotfiles pull --rebase

# Restore stashed changes
dotfiles stash pop || true

echo "Dotfiles are up to date! Conflicting files (if any) were also moved to $BACKUP_DIR."

# TODO
# Set upstream remote automatically:
#
# if ! dotfiles remote | grep -q origin; then
#     echo -e "${CYAN}Setting remote origin...${RESET}"
#     dotfiles remote add origin https://github.com/uhm-jade/dotfiles.git
# fi
# dotfiles branch --set-upstream-to=origin/main main 2>/dev/null || true
#
# Need a config file first tho
# Ideally have an installer that prompts you for your git repo

# TODO:
# Find existing .zshrc and .bashrc for tab completions
# And write this to it
# _doot_completions() {
#     local cur=${COMP_WORDS[COMP_CWORD]}
#
#     COMPREPLY=($(compgen -W "status pull checkout stash add commit push" -- "$cur"))
# }
#
# complete -F _doot_completions doot
#
# Ideally prompt the user before-hand asking if they want it (warning them it will update their .zshrc/.bashrc)
