# spring-boot-startup-notify

> Get a macOS desktop notification the moment your Spring Boot app finishes starting up — no more staring at fast-scrolling logs.

![macOS notification popup showing "Spring Boot Ready - in 48.2 seconds"](https://img.shields.io/badge/platform-macOS-lightgrey)
![Shell](https://img.shields.io/badge/shell-bash-green)

## The Problem

Spring Boot logs scroll fast. The "Started XxxApplication in XX seconds" line disappears before you notice it, especially with large multi-module projects.

## How It Works

A background shell script watches your log file with `tail -F`, detects the startup keyword, and fires a macOS notification via `osascript`.

It runs as a **macOS LaunchAgent** — starts on login, restarts automatically, and works regardless of how you launch the app (IntelliJ Run, Debug, command line, etc.).

## Setup

### 1. Clone the repo

```bash
git clone https://github.com/PowerpowerLiu/spring-boot-startup-notify.git
cd spring-boot-startup-notify
```

### 2. Create your config

```bash
cp notify.conf.example notify.conf
```

Edit `notify.conf`:

```bash
# Path to your log file
LOG_FILE="/Users/yourname/logs/app.log"

# Match the startup success line in your logs.
# Spring Boot default looks like: "Started AllInOne in 48.2 seconds"
KEYWORD="Started AllInOne in"
```

### 3. Install

```bash
bash install.sh
```

That's it. The next time your app starts, you'll get a notification like:

```
✅ Spring Boot Ready
in 48.2 seconds
```

## Finding Your Keyword

Check your log file for the startup completion line:

```bash
grep "Started.*in.*seconds" /path/to/your/app.log | tail -5
```

Use the relevant part as your `KEYWORD`. Common patterns:

| Framework | Example log line | Keyword |
|-----------|-----------------|---------|
| Spring Boot | `Started AllInOne in 48.2 seconds` | `Started AllInOne in` |
| Spring Boot | `Started Scheduler in 72.9 seconds` | `Started Scheduler in` |
| Custom | `Application startup complete` | `Application startup complete` |

## Uninstall

```bash
launchctl unload ~/Library/LaunchAgents/com.springboot-notify.plist
rm ~/Library/LaunchAgents/com.springboot-notify.plist
```

## Troubleshooting

**No notification?**
1. Check macOS notification permissions: System Settings → Notifications → Terminal (or your shell) → Allow
2. Check the monitor log: `tail -f /tmp/springboot-notify.log`
3. Test manually: `osascript -e 'display notification "test" with title "test"'`

**Notification permission denied?**
Run the osascript test above — macOS will prompt you to allow notifications the first time.
