#!/bin/bash
# Installs spring-boot-startup-notify as a macOS LaunchAgent.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLIST_DEST="$HOME/Library/LaunchAgents/com.springboot-notify.plist"

# Check notify.conf exists
if [ ! -f "$SCRIPT_DIR/notify.conf" ]; then
    echo "Please create notify.conf first:"
    echo "  cp notify.conf.example notify.conf"
    echo "  # then edit notify.conf with your LOG_FILE and KEYWORD"
    exit 1
fi

# Generate plist from example, injecting the real script path
sed "s|/path/to/spring-boot-startup-notify/notify.sh|$SCRIPT_DIR/notify.sh|g" \
    "$SCRIPT_DIR/com.springboot-notify.plist.example" > "$PLIST_DEST"

chmod +x "$SCRIPT_DIR/notify.sh"

# Unload if already loaded
launchctl unload "$PLIST_DEST" 2>/dev/null

# Load
launchctl load "$PLIST_DEST"

echo "✅ Installed. Monitoring started."
echo "   Log: tail -f /tmp/springboot-notify.log"
