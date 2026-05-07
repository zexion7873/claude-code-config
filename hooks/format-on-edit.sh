#!/usr/bin/env bash
# PostToolUse on Write|Edit|MultiEdit. Reads tool input JSON from stdin, formats by extension.
# Skips silently if formatter is missing — install prettier / ruff / gofmt to enable.

set -u

f=$(jq -r '.tool_input.file_path // empty')
[ -z "$f" ] && exit 0
[ -f "$f" ] || exit 0

case "$f" in
  *.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs|*.json|*.jsonc|*.css|*.scss|*.less|*.html|*.vue|*.svelte|*.md|*.mdx|*.yaml|*.yml)
    if command -v prettier >/dev/null 2>&1; then
      prettier --write --ignore-unknown --log-level=silent "$f" >/dev/null 2>&1 || true
    fi
    ;;
  *.py)
    if command -v ruff >/dev/null 2>&1; then
      ruff format --silent "$f" >/dev/null 2>&1 || true
    fi
    ;;
  *.go)
    if command -v gofmt >/dev/null 2>&1; then
      gofmt -w "$f" >/dev/null 2>&1 || true
    fi
    ;;
esac

exit 0
