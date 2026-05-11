#!/bin/bash
# sync.sh - ARK Server Configuration Sync Tool
# Ensures server configurations are synchronized with root privileges.

set -euo pipefail

# Check for root/sudo
if [ $EUID -ne 0 ]; then
   echo "Error: This script must be run as root or with sudo." >&2
   exit 1
fi

function usage {
   echo "Usage: $0 <SOURCE> <SERVER>"
   echo
   echo "Arguments:"
   echo "  SOURCE    The source directory for configurations"
   echo "  SERVER    The target ARK server instance or directory"
}

SOURCE=${1:-}
SERVER=${2:-}

if [ -z "$SOURCE" ] || [ -z "$SERVER" ]; then
   usage
   exit 1
fi

if [ ! -d "$SOURCE" ]; then
   echo "Error: Source directory '$SOURCE' does not exist." >&2
   exit 1
fi

DEST="/mnt/.ix-apps/app_mounts/${SERVER}/ark-server"
if [ ! -d "$DEST" ]; then
   echo "Error: Server directory '$DEST' does not exist." >&2
   exit 1
fi

rsync -rltDv "$SOURCE/" "$DEST/"
