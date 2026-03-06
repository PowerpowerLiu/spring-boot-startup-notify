#!/bin/bash
# Removes spring-boot-startup-notify

APP_PATH="/Applications/SpringBootNotify.app"

# Kill running monitor
pkill -f "spring-boot-startup-notify/notify.sh" 2>/dev/null

# Remove from Login Items
osascript -e "tell application \"System Events\" to delete login item \"SpringBootNotify\"" 2>/dev/null

# Remove app
rm -rf "$APP_PATH"

echo "✅ Uninstalled."
