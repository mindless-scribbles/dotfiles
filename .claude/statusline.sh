#!/usr/bin/env bash
# Claude Code status line: model · cwd.
# Reads a JSON blob on stdin (provided by Claude Code after each message).
# Context use and the prompt-cache countdown are drawn by the cache-clock mod's
# band above the prompt. The earlier context-bar version is statusline.sh.bak-2026-10-12.

input=$(cat)

IFS=$'\t' read -r model dir < <(
  printf '%s' "$input" | jq -r '[(.model.display_name // "Claude"), (.workspace.current_dir // .cwd // "")] | @tsv'
)
dir=${dir##*/}   # basename

RESET='\033[0m'; DIM='\033[2m'; CYAN='\033[36m'
seg="${CYAN}${model}${RESET}"
[ -n "$dir" ] && seg="$seg ${DIM}·${RESET} 📁 $dir"

printf '%b' "$seg"
