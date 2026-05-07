#!/usr/bin/env bash
# PreToolUse on Bash — deny obvious foot-guns.
# Output JSON with permissionDecision="deny" to block; silent exit 0 to allow.
set -u

cmd=$(jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":%s}}\n' \
    "$(printf '%s' "$1" | jq -Rs .)"
  exit 0
}

# rm -rf targeting / or ~ or $HOME
if echo "$cmd" | grep -qE '\brm[[:space:]]+(-[A-Za-z]*r[A-Za-z]*f[A-Za-z]*|-[A-Za-z]*f[A-Za-z]*r[A-Za-z]*|-r[[:space:]]+-f|-f[[:space:]]+-r)[[:space:]]+(/|/\*|/[[:space:]]|~|~/|\$HOME|"\$HOME")'; then
  deny "Blocked: rm -rf targeting / or \$HOME. Use 'trash' or be more specific."
fi

# git push with --force to main/master
if echo "$cmd" | grep -qE '\bgit[[:space:]]+push\b' \
   && echo "$cmd" | grep -qE '(--force([^-]|$)|--force-with-lease|[[:space:]]-f([[:space:]]|$))' \
   && echo "$cmd" | grep -qE '\b(main|master)\b'; then
  deny "Blocked: force push to main/master"
fi

# git reset --hard
if echo "$cmd" | grep -qE '\bgit[[:space:]]+reset[[:space:]]+--hard\b'; then
  deny "Blocked: git reset --hard — may discard uncommitted work"
fi

# sudo
if echo "$cmd" | grep -qE '(^|[;&|])[[:space:]]*sudo[[:space:]]'; then
  deny "Blocked: sudo — request user to run manually if needed"
fi

# disk-level destructive: dd, mkfs
if echo "$cmd" | grep -qE '(^|[;&|])[[:space:]]*(dd[[:space:]]+|mkfs)'; then
  deny "Blocked: dd/mkfs — disk-level destructive command"
fi

# pipe to shell: wget|bash, curl|sh, curl|bash
if echo "$cmd" | grep -qE '(wget|curl)[[:space:]].*\|[[:space:]]*(bash|sh|zsh)\b'; then
  deny "Blocked: piping remote content to shell — download and inspect first"
fi

# chmod 777
if echo "$cmd" | grep -qE '\bchmod[[:space:]]+777\b'; then
  deny "Blocked: chmod 777 — overly permissive, use specific permissions"
fi

exit 0
