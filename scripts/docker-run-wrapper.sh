#!/bin/bash
set -e

# Set default values if not provided
PUID=${PUID:-1000}
PGID=${PGID:-100}

echo "Setting up user with PUID=$PUID and PGID=$PGID (optimized build)"

# Modify existing group and user to match desired IDs
groupmod -o -g "$PGID" mautrix
usermod -o -u "$PUID" mautrix

# Ensure data directory exists and has correct permissions
mkdir -p /data

# Only change ownership if we can (i.e., if running as root)
if [ "$(id -u)" = "0" ]; then
    chown -R "$PUID:$PGID" /data 2>/dev/null || {
        echo "Warning: Could not change ownership of some files in /data"
        echo "This is normal if files already have correct ownership"
    }
fi

echo "User setup complete. Running bridge as mautrix (UID=$PUID, GID=$PGID)"

# Execute the original docker-run.sh script directly (it will handle gosu internally)
exec /docker-run.sh "$@"