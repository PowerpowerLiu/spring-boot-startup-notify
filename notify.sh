#!/bin/bash
# Spring Boot Startup Notifier
# Monitors a log file and sends a macOS notification when the app starts up.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/notify.conf"

# Load config
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found: $CONFIG_FILE"
    echo "Please copy notify.conf.example to notify.conf and edit it."
    exit 1
fi

source "$CONFIG_FILE"

# Validate required config
if [ -z "$LOG_FILE" ] || [ -z "$KEYWORD" ]; then
    echo "LOG_FILE and KEYWORD must be set in notify.conf"
    exit 1
fi

echo "[$(date)] Watching: $LOG_FILE"
echo "[$(date)] Keyword:  $KEYWORD"

tail -F "$LOG_FILE" | grep --line-buffered "$KEYWORD" | while read -r line; do
    SECONDS_INFO=$(echo "$line" | grep -oE 'in [0-9.]+ seconds' || echo "")
    MESSAGE="${NOTIFY_MESSAGE:-App started} $SECONDS_INFO"
    TITLE="${NOTIFY_TITLE:-✅ Spring Boot Ready}"
    SOUND="${NOTIFY_SOUND:-Glass}"

    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"$SOUND\""
    echo "[$(date)] Notified: $line"
done
