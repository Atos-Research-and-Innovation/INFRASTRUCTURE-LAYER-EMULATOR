#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

SCRIPT_DIR=$(dirname "$0")

$SCRIPT_DIR/stop_all_running_containers.sh
$SCRIPT_DIR/delete_all_stopped_containers.sh