#!/usr/bin/env bash
# ~/.scripts/sync-claude-skills.sh
#
# Global Claude Code skills live in their own repo (mindless-scribbles/claude-skills),
# not in the dotfiles: on WSL2 ~/.claude/skills is a symlink into Windows
# (C:\Users\Owner\.claude\skills), and git can't track files through a symlink.
#
# This clones that repo to ~/.claude/skills, or pulls it if it is already there.
# On WSL2 it pulls inside the symlink's target. Safe to re-run.

SKILLS_REMOTE="https://github.com/mindless-scribbles/claude-skills.git"
LINK="$HOME/.claude/skills"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }

# Follow the WSL2 symlink to the real folder.
DIR=$(readlink -f "$LINK" 2>/dev/null || echo "$LINK")

if [[ -d "$DIR/.git" ]]; then
    info "Pulling skills in $DIR"
    git -C "$DIR" pull --ff-only || warn "Pull failed — check 'git -C $DIR status'"
    exit 0
fi

if [[ -d "$DIR" ]] && [[ -n "$(ls -A "$DIR" 2>/dev/null)" ]]; then
    BACKUP="$DIR.pre-repo-$(date +%Y-%m-%d)"
    warn "$DIR has skills but is not a clone — moving it to $BACKUP"
    mv "$DIR" "$BACKUP"
    warn "Compare $BACKUP with the clone and copy over anything missing"
fi

mkdir -p "$(dirname "$DIR")"
info "Cloning skills into $DIR"
if git clone "$SKILLS_REMOTE" "$DIR"; then
    # Files on a Windows drive show as mode changes and CRLF otherwise.
    git -C "$DIR" config core.fileMode false
    git -C "$DIR" config core.autocrlf false
    info "Skills ready: $(ls "$DIR" | tr '\n' ' ')"
else
    warn "Clone failed — is 'gh auth login' done on this machine?"
fi
