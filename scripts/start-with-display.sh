#!/bin/bash
set -e

# Start D-Bus session
eval $(dbus-launch --sh-syntax)
export DBUS_SESSION_BUS_ADDRESS

# Start Xvfb virtual display
Xvfb :99 -screen 0 1024x768x24 -nolisten tcp -nolisten unix &
XVFB_PID=$!

# Wait for Xvfb to start
sleep 2

# Set display and verify it's working
export DISPLAY=:99
xdpyinfo >/dev/null 2>&1 || {
    echo "ERROR: Xvfb failed to start properly"
    kill $XVFB_PID 2>/dev/null || true
    exit 1
}

echo "Xvfb started successfully on display :99"
echo "D-Bus session started: $DBUS_SESSION_BUS_ADDRESS"

# Cleanup function for graceful shutdown
cleanup() {
    echo "Shutting down..."
    kill $XVFB_PID 2>/dev/null || true
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

# Execute the command passed to this script
exec "$@"