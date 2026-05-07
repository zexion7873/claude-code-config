#!/usr/bin/env bash

# Powerlevel10k style status line for Claude Code

input=$(cat)

eval "$(echo "$input" | jq -r '
  "cwd=" + (.workspace.current_dir // .cwd | @sh),
  "model=" + (.model.display_name // "Unknown" | @sh),
  "output_style=" + (.output_style.name // "default" | @sh),
  "remaining=" + (.context_window.remaining_percentage // "" | tostring | @sh),
  "rate_5h=" + (.rate_limits.five_hour.used_percentage // "" | tostring | @sh),
  "rate_5h_reset=" + (.rate_limits.five_hour.resets_at // "" | tostring | @sh),
  "effort=" + (.effort.level // "" | @sh),
  "thinking=" + (.thinking.enabled // false | tostring | @sh)
')"

git_branch=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi

display_dir="${cwd/#$HOME/\~}"

# Build output into a variable, then print once
out=""
prev_bg=""
segment() {
    local bg="$1" fg="$2" content="$3"
    if [ -n "$prev_bg" ]; then
        out+="\033[38;5;${prev_bg}m\033[48;5;${bg}m\033[0m"
    fi
    out+="\033[48;5;${bg}m\033[38;5;${fg}m ${content} \033[0m"
    prev_bg="$bg"
}

# Directory
segment 31 15 " $display_dir"

# Git branch
if [ -n "$git_branch" ]; then
    segment 58 15 " $git_branch"
fi

# Model
segment 55 15 " $model"

# Context window remaining
if [ -n "$remaining" ]; then
    r="${remaining%.*}"
    if [ "$r" -ge 50 ]; then bg=22
    elif [ "$r" -ge 20 ]; then bg=136
    else bg=124; fi
    segment "$bg" 15 "$(printf '%.0f%%' "$remaining")"
fi

# Effort + thinking
if [ -n "$effort" ] || [ "$thinking" = "true" ]; then
    label="$effort"
    if [ "$thinking" = "true" ]; then
        label="${label:+$label }thinking"
    fi
    segment 97 15 " $label"
fi

# Output style
segment 239 15 " $output_style"

# Rate limit
if [ -n "$rate_5h" ]; then
    r="${rate_5h%.*}"
    if [ "$r" -ge 80 ]; then bg=124
    elif [ "$r" -ge 50 ]; then bg=136
    else bg=22; fi
    label="$(printf '5h:%.0f%%' "$rate_5h")"
    if [ -n "$rate_5h_reset" ]; then
        now_ts=$(date "+%s")
        diff_min=$(( (rate_5h_reset - now_ts) / 60 ))
        if [ "$diff_min" -gt 0 ]; then
            hrs=$(( diff_min / 60 ))
            mins=$(( diff_min % 60 ))
            if [ "$hrs" -gt 0 ]; then
                label="$(printf '5h:%.0f%% %dh%dm' "$rate_5h" "$hrs" "$mins")"
            else
                label="$(printf '5h:%.0f%% %dm' "$rate_5h" "$mins")"
            fi
        fi
    fi
    segment "$bg" 15 " $label"
fi

# End powerline arrow
if [ -n "$prev_bg" ]; then
    out+="\033[38;5;${prev_bg}m\033[0m"
fi

printf "%b\n" "$out"
