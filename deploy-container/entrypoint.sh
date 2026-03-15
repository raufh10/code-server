#!/bin/bash

START_DIR="${START_DIR:-/home/coder/project}"
PREFIX="deploy-code-server"

echo "[$PREFIX] Setting volume permissions..."
sudo chown -R coder:coder $START_DIR

mkdir -p $START_DIR

echo "[$PREFIX] Starting code-server..."
# Start code-server on the Railway port
/usr/bin/entrypoint.sh --bind-addr 0.0.0.0:${PORT:-8080} $START_DIR
