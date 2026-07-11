#!/usr/bin/env bash
# ~/.scripts/link-claude-memory.sh
#
# Claude Code stores auto-memory under a per-machine folder whose name is
# derived from the launch cwd (e.g. /home/ddecastro -> -home-ddecastro,
# C:\Users\ddecastro -> C--Users-ddecastro). That path differs per machine,
# so memory doesn't sync by path.
#
# This points the $HOME-project memory dir at a single canonical store
# (~/.claude/memory, which IS tracked in dotfiles) via a symlink on Linux
# or a directory junction on Windows Git Bash. Safe to re-run.
set -e

CANON="$HOME/.claude/memory"
mkdir -p "$CANON"

# Reproduce the folder name Claude derives from the *native* home path.
if command -v cygpath >/dev/null 2>&1; then
    native=$(cygpath -w "$HOME")          # e.g. C:\Users\ddecastro
else
    native="$HOME"                        # e.g. /home/ddecastro
fi
enc=$(printf '%s' "$native" | sed 's/[^a-zA-Z0-9]/-/g')
LINK="$HOME/.claude/projects/$enc/memory"
mkdir -p "$(dirname "$LINK")"

# First run on a machine that already has real memory files: fold them in once.
if [ -e "$LINK" ] && [ ! -L "$LINK" ]; then
    cp -rn "$LINK"/. "$CANON"/ 2>/dev/null || true
    rm -rf "$LINK"
fi

if command -v cygpath >/dev/null 2>&1; then
    # Windows: directory junction (no admin / Developer Mode needed).
    [ -e "$LINK" ] && rm -rf "$LINK"
    cmd //c mklink /J "$(cygpath -w "$LINK")" "$(cygpath -w "$CANON")" >/dev/null
else
    ln -sfn "$CANON" "$LINK"
fi

echo "Claude memory linked: $LINK -> $CANON"
