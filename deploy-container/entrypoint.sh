#!/bin/bash

# Default the start directory to the project folder
START_DIR="${START_DIR:-/home/coder/project}"
PREFIX="deploy-code-server"

# Create the directory if it doesn't exist (Railway Volume mount point)
mkdir -p $START_DIR

# Function to clone the git repo if the volume is empty
project_init () {
  if [ -z "$(ls -A $START_DIR)" ]; then
    if [ -n "${GIT_REPO}" ]; then
      echo "[$PREFIX] Volume is empty. Cloning $GIT_REPO..."
      git clone $GIT_REPO $START_DIR
    else
      echo "[$PREFIX] No GIT_REPO specified and Volume is empty."
      echo "Welcome to code-server! Your files in $START_DIR will persist." > $START_DIR/coder.txt
    fi
  else
    echo "[$PREFIX] Volume already contains files. Skipping clone."
  fi
}

# Run the initialization
project_init

# --- Python & Rust Persistence Logic ---

# 1. Setup Python Virtual Environment on the Volume
if [ ! -d "$START_DIR/.venv" ]; then
  echo "[$PREFIX] Creating Python virtual environment in $START_DIR/.venv..."
  python3 -m venv $START_DIR/.venv
fi

# 2. Redirect Cargo (Rust) to store binaries/cache on the Volume
# This prevents re-downloading crates on every deploy
mkdir -p $START_DIR/.cargo_home
export CARGO_HOME="$START_DIR/.cargo_home"

# --- End Persistence Logic ---

# Handle Dotfiles (Customizing your bash/tools from a repo)
if [ -n "$DOTFILES_REPO" ]; then
  echo "[$PREFIX] Cloning dotfiles..."
  mkdir -p $HOME/dotfiles
  git clone $DOTFILES_REPO $HOME/dotfiles
    
  # Symlink files to $HOME (e.g., .bashrc, .gitconfig)
  shopt -s dotglob
  ln -sf $HOME/dotfiles/* $HOME
    
  # Run install script if it exists
  [ -f "$HOME/dotfiles/install.sh" ] && bash $HOME/dotfiles/install.sh
fi

echo "[$PREFIX] Starting code-server..."
# Start code-server on the Railway port
/usr/bin/entrypoint.sh --bind-addr 0.0.0.0:${PORT:-8080} $START_DIR

