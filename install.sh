#!/bin/bash
# Installs spring-boot-startup-notify as a macOS Login Item app.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_PATH="/Applications/SpringBootNotify.app"

# Check notify.conf exists
if [ ! -f "$SCRIPT_DIR/notify.conf" ]; then
    echo "Please create notify.conf first:"
    echo "  cp notify.conf.example notify.conf"
    echo "  # then edit notify.conf with your LOG_FILE and KEYWORD"
    exit 1
fi

chmod +x "$SCRIPT_DIR/notify.sh"

# Create AppleScript app that launches the monitor script
cat > /tmp/springboot-notify.applescript << EOF
on run
    do shell script "/bin/bash $SCRIPT_DIR/notify.sh > /tmp/springboot-notify.log 2>&1 &"
end run
EOF

osacompile -o "$APP_PATH" /tmp/springboot-notify.applescript
rm /tmp/springboot-notify.applescript

# Add to Login Items (runs at login with full user permissions)
osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$APP_PATH\", hidden:true}"

# Launch immediately
open "$APP_PATH"

echo "✅ Installed. Monitoring started."
echo "   Notification log: tail -f /tmp/springboot-notify.log"
echo "   To uninstall: bash uninstall.sh"
