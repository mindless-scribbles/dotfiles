# ~/.config/powershell/profile.ps1
# Ported from Git Bash config (~/.bash_profile, ~/.bashrc, ~/.bash_aliases).
# Goal: make PowerShell behave as close to Git Bash as practical.
# Sourced by both PowerShell 7 and Windows PowerShell 5.1 profiles.
# Tracked in dotfiles (lives under $HOME) so it syncs across machines.

# --- XDG base dirs (keep nvim & friends unified with Linux paths) ---
$env:XDG_CONFIG_HOME = Join-Path $HOME '.config'
$env:XDG_DATA_HOME   = Join-Path $HOME '.local\share'
$env:XDG_STATE_HOME  = Join-Path $HOME '.local\state'
$env:XDG_CACHE_HOME  = Join-Path $HOME '.cache'

# --- Editor ---
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'

# --- Ensure Neovim is on PATH (matches the bash PATH append) ---
$nvimBin = 'C:\Program Files\Neovim\bin'
if ((Test-Path $nvimBin) -and ($env:PATH -notlike "*$nvimBin*")) {
    $env:PATH = "$env:PATH;$nvimBin"
}

# --- Editor aliases ---
function vi  { nvim @args }
function vim { nvim @args }

# --- Dotfiles bare repo: git --git-dir=~/.dotfiles --work-tree=~ ---
function dotfiles { git --git-dir="$HOME\.dotfiles" --work-tree="$HOME" @args }

# --- eza-based ls family (Git Bash muscle memory) ---
# Remove built-in ls alias so our function wins (aliases outrank functions).
if (Get-Alias ls -ErrorAction SilentlyContinue) { Remove-Item Alias:ls -Force }
function ls   { eza --color=auto --icons @args }
function ll   { eza -alF --icons --git @args }
function la   { eza -a --icons @args }
function l    { eza -F --icons @args }
function lrt  { eza -al -s modified -snew --icons --git @args }
function lt   { eza --tree --icons @args }
function lt2  { eza --tree --level=2 --icons @args }
# Native object-returning listing is still available via `gci` and `dir`.

# --- realpath -> lf (PowerShell has no realpath) ---
function lf { (Resolve-Path @args).Path }

# --- AutoHotkey v2 ---
function ahk { & 'C:\Program Files\AutoHotkey\v2\AutoHotkey.exe' @args }

# --- Small Git Bash conveniences ---
function which { (Get-Command @args -ErrorAction SilentlyContinue).Source }
