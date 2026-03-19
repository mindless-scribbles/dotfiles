#!/usr/bin/env bash
# ~/.scripts/setup-windows.sh
#
# Sets up your dotfiles + neovim environment in Windows Git Bash.
# Run once on a new Windows machine.
#
# One-liner (run from Git Bash):
#   bash <(curl -s https://raw.githubusercontent.com/mindless-scribbles/dotfiles/main/.scripts/setup-windows.sh)

set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
step()  { echo -e "\n${CYAN}── $1 ──${NC}"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

[[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]] \
    || error "Run this from Windows Git Bash (detected OSTYPE='$OSTYPE')"

DOTFILES_REMOTE="https://github.com/mindless-scribbles/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
DOT="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"

# ── 1. Install packages via winget ────────────────────────────────────────────
step "Installing packages"

pkg() {
    local cmd=$1 id=$2
    if command -v "$cmd" &>/dev/null; then
        info "$cmd already installed"
    else
        info "Installing $cmd..."
        winget install --id "$id" -e --source winget --accept-package-agreements --accept-source-agreements
    fi
}

pkg "nvim"     "Neovim.Neovim"
pkg "rg"       "BurntSushi.ripgrep.MSVC"   # snacks.nvim grep
pkg "fd"       "sharkdp.fd"                 # file finding
pkg "node"     "OpenJS.NodeJS.LTS"           # TypeScript LSP, markdown-preview
pkg "python3"  "Python.Python.3.12"          # Python LSP / venv-selector
pkg "lazygit"  "JesseDuffield.lazygit"       # LazyVim git UI
pkg "eza"      "eza-community.eza"           # ls aliases in .bash_aliases

# Treesitter needs a C compiler to build parsers
if ! command -v gcc &>/dev/null && ! command -v clang &>/dev/null && ! command -v cc &>/dev/null; then
    info "Installing LLVM (clang) for treesitter parser compilation..."
    winget install --id LLVM.LLVM -e --source winget --accept-package-agreements --accept-source-agreements \
        || warn "LLVM install failed — treesitter parsers may not compile. Install manually: winget install LLVM.LLVM"
fi

# ── 2. Nerd Font ──────────────────────────────────────────────────────────────
step "Nerd Font"
if winget install --id DEVCOM.JetBrainsMonoNerdFont -e --source winget \
        --accept-package-agreements --accept-source-agreements 2>/dev/null; then
    info "JetBrainsMono Nerd Font installed"
else
    warn "Could not auto-install font — download from https://www.nerdfonts.com"
fi
warn "ACTION: Set your terminal font to 'JetBrainsMono Nerd Font' in terminal settings"

# ── 3. Clone bare dotfiles repo ───────────────────────────────────────────────
step "Dotfiles"

if [[ -d "$DOTFILES_DIR" ]]; then
    info "Dotfiles repo already at $DOTFILES_DIR — pulling latest"
    $DOT pull --rebase
else
    info "Cloning bare dotfiles repo..."
    git clone --bare "$DOTFILES_REMOTE" "$DOTFILES_DIR"
    $DOT config status.showUntrackedFiles no
fi

# Checkout tracked files to $HOME (skip on conflict — existing files win)
info "Checking out dotfiles to $HOME..."
$DOT checkout 2>/dev/null || {
    warn "Some files already exist — backing them up to ~/.dotfiles-backup/"
    mkdir -p "$HOME/.dotfiles-backup"
    $DOT checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | xargs -I{} sh -c \
        'mkdir -p "'"$HOME"'/.dotfiles-backup/$(dirname "{}")" && mv "'"$HOME"'/{}" "'"$HOME"'/.dotfiles-backup/{}"'
    $DOT checkout
}

# Fix .bash_aliases — the dotfiles version is a WSL symlink, which doesn't work in Git Bash
# Overwrite it with the actual content (using /c/... Git Bash paths instead of /mnt/...)
BASH_ALIASES="$HOME/.bash_aliases"
if [[ -L "$BASH_ALIASES" || "$(cat "$BASH_ALIASES" 2>/dev/null)" == /mnt/* ]]; then
    info "Fixing .bash_aliases for Git Bash (replacing WSL symlink)"
    cat > "$BASH_ALIASES" << 'EOF'
alias ls='eza --color=auto --icons'
alias ll='eza -alF --icons --git'
alias la='eza -a --icons'
alias l='eza -F --icons'
alias lrt='eza -al -s modified -snew --icons --git'
alias lt='eza --tree --icons'
alias lt2='eza --tree --level=2 --icons'
alias lf="realpath"
alias ahk='"/c/Program Files/AutoHotkey/v2/AutoHotkey.exe"'
EOF
fi

# ── 4. Shell profile ──────────────────────────────────────────────────────────
step "Shell profile"

PROFILE="$HOME/.bash_profile"
MARKER="# dotfiles-windows-setup"

if grep -q "$MARKER" "$PROFILE" 2>/dev/null; then
    info "Profile already configured"
else
    cat >> "$PROFILE" << 'EOF'

# dotfiles-windows-setup
# Make nvim use ~/.config/nvim (same path as Linux — keeps dotfiles unified)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Neovim
export PATH="$PATH:/c/Program Files/Neovim/bin"
export EDITOR="nvim"
alias vi="nvim"
alias vim="nvim"

# Dotfiles bare repo alias
alias dotfiles='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

# Source aliases
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
EOF
    info "Configured $PROFILE"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}┌─────────────────────────────────────────┐${NC}"
echo -e "${GREEN}│  Setup complete!                        │${NC}"
echo -e "${GREEN}└─────────────────────────────────────────┘${NC}"
echo ""
echo "Next steps:"
echo "  1. Restart Git Bash"
echo "  2. Set terminal font → 'JetBrainsMono Nerd Font'"
echo "  3. Run: nvim"
echo "     lazy.nvim will bootstrap and install all plugins automatically"
echo "     Then :Mason to install LSP servers (pyright, ts_ls, etc.)"
echo ""
echo "Future dotfile syncing:"
echo "  dotfiles pull    # pull changes"
echo "  dotfiles add -u  # stage tracked file changes"
echo "  dotfiles push    # push to GitHub"
