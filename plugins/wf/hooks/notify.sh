#!/bin/bash
# Send notifications to Telegram, Discord, and/or Slack
# when Claude Code triggers a Notification event.
#
# Environment variables (set any combination):
#   NOTIFY_TELEGRAM - "bot_token|chat_id"
#   NOTIFY_DISCORD  - Discord webhook URL
#   NOTIFY_SLACK    - Slack webhook URL
set -uo pipefail

INPUT=$(cat)

# Parse JSON input (jq preferred, python3 fallback)
json_get() {
    local field="$1" default="${2:-}"
    local val
    if command -v jq &>/dev/null; then
        val=$(printf '%s' "$INPUT" | jq -r ".$field // empty" 2>/dev/null)
    else
        val=$(printf '%s' "$INPUT" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('$field',''))" 2>/dev/null)
    fi
    printf '%s' "${val:-$default}"
}

MESSAGE=$(json_get message "No message")
TITLE=$(json_get title "")
SESSION_ID=$(json_get session_id "unknown")
HOSTNAME=$(hostname -s)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Skip if no notification channels configured
if [ -z "${NOTIFY_TELEGRAM:-}" ] && [ -z "${NOTIFY_DISCORD:-}" ] && [ -z "${NOTIFY_SLACK:-}" ]; then
    exit 0
fi

# Build notification text
TITLE_LINE=""
[ -n "$TITLE" ] && TITLE_LINE="*${TITLE}*
"

TEXT="${TITLE_LINE}Host: ${HOSTNAME}
Time: ${TIMESTAMP}
Session: ${SESSION_ID}
Message: ${MESSAGE}

Resume: claude --continue ${SESSION_ID}"

# JSON-escape a string
json_escape() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\t'/\\t}"
    s="${s//$'\r'/\\r}"
    printf '%s' "$s"
}

# Telegram: NOTIFY_TELEGRAM="bot_token|chat_id"
if [ -n "${NOTIFY_TELEGRAM:-}" ]; then
    BOT_TOKEN="${NOTIFY_TELEGRAM%%|*}"
    CHAT_ID="${NOTIFY_TELEGRAM##*|}"
    if [ -n "$BOT_TOKEN" ] && [ -n "$CHAT_ID" ] && [ "$BOT_TOKEN" != "$CHAT_ID" ]; then
        curl -sf --max-time 10 -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
            -d "chat_id=${CHAT_ID}" \
            --data-urlencode "text=${TEXT}" \
            -d "parse_mode=Markdown" \
            >/dev/null 2>&1 &
    fi
fi

# Discord: NOTIFY_DISCORD is a webhook URL
if [ -n "${NOTIFY_DISCORD:-}" ]; then
    curl -sf --max-time 10 -X POST "${NOTIFY_DISCORD}" \
        -H "Content-Type: application/json" \
        -d "{\"content\": \"$(json_escape "$TEXT")\"}" \
        >/dev/null 2>&1 &
fi

# Slack: NOTIFY_SLACK is a webhook URL
if [ -n "${NOTIFY_SLACK:-}" ]; then
    curl -sf --max-time 10 -X POST "${NOTIFY_SLACK}" \
        -H "Content-Type: application/json" \
        -d "{\"text\": \"$(json_escape "$TEXT")\"}" \
        >/dev/null 2>&1 &
fi

wait
exit 0
