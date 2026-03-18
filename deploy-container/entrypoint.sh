#!/bin/bash

# ----------------------------------------
# ⚙️ General Configuration
# ----------------------------------------
START_DIR="${START_DIR:-/home/coder/project}"
PREFIX="deploy-code-server"

mkdir -p $START_DIR

echo "[$PREFIX] Setting volume permissions..."
sudo chown -R coder:coder $START_DIR

echo "[$PREFIX] Cleaning Git askpass environment..."
unset GIT_ASKPASS
unset VSCODE_GIT_ASKPASS_NODE
unset VSCODE_GIT_ASKPASS_EXTRA_ARGS
unset VSCODE_GIT_ASKPASS_MAIN

# ----------------------------------------
# 🔧 Configure Git identity
# ----------------------------------------
if [ -n "$GIT_USERNAME" ]; then
  echo "[$PREFIX] Setting git username..."
  git config --global user.name "$GIT_USERNAME"
fi

if [ -n "$GIT_EMAIL" ]; then
  echo "[$PREFIX] Setting git email..."
  git config --global user.email "$GIT_EMAIL"
fi

if [ -n "$GIT_USERNAME" ] && [ -n "$GIT_PASSWORD" ]; then
  echo "[$PREFIX] Configuring persistent git credentials..."

  CREDS_FILE="$START_DIR/.git-credentials"

  # Configure git to use this specific file
  git config --global credential.helper "store --file=$CREDS_FILE"

  # Write credentials (overwrite each start to stay fresh)
  cat <<EOF > "$CREDS_FILE"
https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com
EOF

  chmod 600 "$CREDS_FILE"
  chown coder:coder "$CREDS_FILE"
fi

# ----------------------------------------
# 🚀 Start code-server
# ----------------------------------------
echo "[$PREFIX] Starting code-server (Idle Timeout: 15m, No Telemetry)..."
exec /usr/bin/entrypoint.sh \
  --bind-addr 0.0.0.0:${PORT:-8080} \
  --disable-telemetry \
  --idle-timeout-seconds 900 \
  $START_DIR
