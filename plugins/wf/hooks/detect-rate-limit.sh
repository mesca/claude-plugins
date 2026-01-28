#!/bin/bash
# Hook to detect Claude Pro Max plan rate limiting
# Logs warnings when rate limits are approached or exceeded

LOG_FILE="${HOME}/.claude/rate-limit.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Read hook input from stdin
INPUT=$(cat)

# Check for rate limit indicators in the input
if echo "$INPUT" | grep -qiE "rate.?limit|too many requests|quota|capacity|throttl|overloaded|try again|429|503"; then
    echo "[$TIMESTAMP] RATE LIMIT WARNING" >> "$LOG_FILE"
    echo "Input: $INPUT" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"

    # Also output to stderr so user sees it
    echo "⚠️  Rate limit detected - logged to $LOG_FILE" >&2
fi

# Check for usage warnings
if echo "$INPUT" | grep -qiE "usage.?(limit|cap)|plan.?limit|exceeded|maximum"; then
    echo "[$TIMESTAMP] USAGE WARNING" >> "$LOG_FILE"
    echo "Input: $INPUT" >> "$LOG_FILE"
    echo "---" >> "$LOG_FILE"

    echo "⚠️  Usage warning detected - logged to $LOG_FILE" >&2
fi

# Always exit 0 to not block Claude Code
exit 0
