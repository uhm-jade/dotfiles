#!/usr/bin/env bash
set -e

# Regular colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"

BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"

BOLD_WHITE="\033[1;37m"
BOLD_RED="\033[1;31m"

RESET="\033[0m" # reset color to default

echo -e "${CYAN}Setting up windows specific stuff...${RESET}"
if command -v cmd.exe >/dev/null 2>&1; then
	echo -e "${BOLD_RED}WINDOWS USER DETECTED! 🚩🚩🚩${RESET}"

	if [ -d "$HOME/user" ]; then
		echo -e "${GREEN}Found link to windows user directory${RESET}"
	else
		echo -e "${CYAN}Creating link to windows user directory...${RESET}"
		user_name=$(cmd.exe /c echo %username%)
		user_name=${user_name%$'\r'} # remove trailing carriage return
		user_dir="/mnt/c/Users/$user_name"
		ln -s "$user_dir" "${HOME}/user"
		echo -e "${GREEN}Link created in ${HOME}/user${RESET}"
	fi
fi

echo -e "${CYAN}Installing dotfiles...${RESET}"

read -rp "Enter your dotfiles Git repository URL: " repo_url
repo_url=${repo_url:-https://github.com/uhm-jade/dotfiles.git}

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup"

# Clone the bare repo if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
	# git clone --bare "$repo_url" "$DOTFILES_DIR"
	git clone --bare "https://github.com/uhm-jade/dotfiles.git" "$DOTFILES_DIR"
fi

# Aliasing stuff need to get rid of this tbh
alias dotfiles="/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME"
shopt -s expand_aliases # For script to use alias

# Configure repo
dotfiles config --local status.showUntrackedFiles no
dotfiles remote set-url origin "$repo_url"

# Backup any existing dotfiles that would be overwritten
mkdir -p "$BACKUP_DIR"

conflicts=$(dotfiles checkout 2>&1 | grep "^\s" | awk '{print $1}')

if [ -n "$conflicts" ]; then
	echo -e "${YELLOW}Backing up existing files to $BACKUP_DIR:${RESET}"
	echo "$conflicts"
	for file in $conflicts; do
		mkdir -p "$(dirname "$BACKUP_DIR/$file")"

		cp "$HOME/$file" "$BACKUP_DIR/$file"
	done
fi

echo -e "${CYAN}Pulling latest changes from GitHub...${RESET}"

# Save local changes (if any) temporarily
dotfiles stash push -m "Auto-stash before pull" || true

# Pull from GitHub
dotfiles pull --rebase
echo -e "${CYAN}Downloaded repo files...${RESET}"

# Restore stashed changes
dotfiles stash pop || true

echo -e "${CYAN}Conflicting files moved to $BACKUP_DIR.${RESET}"

for dots in . .. ...; do
	echo -ne "$dots\r" # prints dots and returns cursor to start
	sleep 0.4
	echo # then move to a new line
done
echo -e "\r  ${YELLOW}🎺 doot${RESET}"

sleep 0.4

echo

echo
echo -e "${CYAN}how to doot:${RESET}"
echo
echo -e "  ${YELLOW}doot add <file>${RESET} - add a file to your dotfiles repo"

echo -e "  ${YELLOW}doot pull${RESET}       - update your dotfiles from GitHub"
echo -e "  ${YELLOW}doot push${RESET}       - push your local edits to GitHub"
echo -e "  ${YELLOW}doot status${RESET}     - show changes to tracked dotfiles"
echo -e "  ${YELLOW}doot checkout${RESET}   - restore tracked dotfiles and backup conflicts"

echo -e "${CYAN}and any other git command, e.g. ${YELLOW}doot log --oneline${RESET}${CYAN}.${RESET}"

# TODO for distribution
# - extract repo from url and then use the version that has the .git when cloning
# - make sure it doesn't clone mine (i am doing this so i can give it to aidan)
# - get rid of dotfiles aliasing stuff, just use doot
# - get rid of funny windows symlinking stuff
# - move everything into its own repo

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
