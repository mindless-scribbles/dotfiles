#!/usr/bin/env bash
# Claude Code status line: model · cwd · live context-window usage.
# Reads a JSON blob on stdin (provided by Claude Code after each message).

input=$(cat)

# --- model + working directory ------------------------------------------
model=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=${dir##*/}   # basename

# --- context usage (defensive: field names vary across versions) --------
# Grab pre-calculated %, input tokens, and window size in one shot; any
# missing value becomes 0 so the arithmetic below never breaks.
read -r used intok ctxsize < <(
  printf '%s' "$input" | jq -r '
    [ (.context_window.used_percentage // 0),
      (.context_window.total_input_tokens // .context_window.current_usage.input_tokens // 0),
      (.context_window.context_window_size // 0)
    ] | map(. // 0) | @tsv'
)

# Normalise to a whole-number percentage.
pct=-1
used=${used%%.*}; intok=${intok%%.*}; ctxsize=${ctxsize%%.*}
if [ "${used:-0}" -gt 0 ] 2>/dev/null; then
  pct=$used
elif [ "${ctxsize:-0}" -gt 0 ] 2>/dev/null && [ "${intok:-0}" -gt 0 ] 2>/dev/null; then
  pct=$(( intok * 100 / ctxsize ))
fi

# --- render -------------------------------------------------------------
RESET='\033[0m'; DIM='\033[2m'; CYAN='\033[36m'
seg="${CYAN}${model}${RESET}"
[ -n "$dir" ] && seg="$seg ${DIM}·${RESET} 📁 $dir"

if [ "$pct" -ge 0 ] 2>/dev/null; then
  width=10
  filled=$(( pct * width / 100 )); [ "$filled" -gt "$width" ] && filled=$width
  empty=$(( width - filled ))
  bar=""
  [ "$filled" -gt 0 ] && printf -v f "%${filled}s" && bar="${f// /▓}"
  [ "$empty"  -gt 0 ] && printf -v e "%${empty}s"  && bar="${bar}${e// /░}"

  if   [ "$pct" -ge 90 ]; then c='\033[31m'   # red
  elif [ "$pct" -ge 70 ]; then c='\033[33m'   # yellow
  else                         c='\033[32m'   # green
  fi

  ctx="${c}${bar} ${pct}%${RESET}"
  if [ "${intok:-0}" -gt 0 ] 2>/dev/null; then
    ctx="$ctx ${DIM}($(( intok / 1000 ))k ctx)${RESET}"
  fi
  seg="$seg ${DIM}·${RESET} $ctx"
fi

printf '%b' "$seg"
