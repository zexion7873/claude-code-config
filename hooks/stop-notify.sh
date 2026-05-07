#!/usr/bin/env bash
# Stop hook — desktop notification + sound on macOS.
# Fires on every Stop event (turn end, /clear, /compact, resume).
osascript -e 'display notification "任務完成" with title "Claude Code"' >/dev/null 2>&1 &
afplay /System/Library/Sounds/Glass.aiff >/dev/null 2>&1 &
exit 0
