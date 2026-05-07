#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"

items=(
  "CLAUDE.md"
  "settings.json"
  "statusline-p10k.sh"
  "hooks"
  "commands"
  "agents"
  "rules"
)

for item in "${items[@]}"; do
  src="$REPO_DIR/$item"
  dest="$CLAUDE_DIR/$item"

  if [ ! -e "$src" ]; then
    echo "skip: $item (not found in repo)"
    continue
  fi

  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -e "$dest" ]; then
    backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    echo "backup: $dest -> $backup"
  fi

  ln -s "$src" "$dest"
  echo "linked: $dest -> $src"
done

echo "done."
