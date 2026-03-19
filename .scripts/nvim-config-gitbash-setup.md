# Windows Git Bash Neovim Setup

Recreates the dotfiles environment (neovim + LazyVim) on Windows Git Bash from the existing bare-git dotfiles repo.

## One-liner (run from Windows Git Bash)

```bash
bash <(curl -s https://raw.githubusercontent.com/mindless-scribbles/dotfiles/main/.scripts/setup-windows.sh)
```

Or clone manually and run:

```bash
git clone --bare https://github.com/mindless-scribbles/dotfiles.git ~/.dotfiles
bash ~/.dotfiles/setup-windows.sh  # won't work for bare repo — use the curl method above
```

---

## What the script installs (via winget)

| Tool | Purpose |
|------|---------|
| `neovim` | Editor |
| `ripgrep` | Fast grep (snacks.nvim, grug-far) |
| `fd` | Fast file find |
| `node` (LTS) | TypeScript LSP, markdown-preview.nvim |
| `python 3.12` | Python LSP, venv-selector.nvim |
| `lazygit` | Git UI (LazyVim integration) |
| `eza` | ls replacement (used in .bash_aliases) |
| `LLVM` | C compiler for treesitter parser compilation |
| JetBrainsMono Nerd Font | Icons (mini.icons, bufferline, lualine) |

---

## How it works

### Dotfiles (bare git repo)
The dotfiles repo is a **bare git repo** at `~/.dotfiles`. Files are checked out directly to `$HOME`.

```
~/.dotfiles/   ← bare repo (no working tree)
$HOME/         ← working tree (actual files live here)
  .config/nvim/
  .bash_aliases
  .gitconfig
  .scripts/
```

Interact with it via the `dotfiles` alias (added by setup script):

```bash
dotfiles status
dotfiles add ~/.config/nvim/lua/plugins/new-plugin.lua
dotfiles commit -m "add new plugin"
dotfiles push
dotfiles pull
```

### Why XDG_CONFIG_HOME?
On Windows, neovim defaults to `%LOCALAPPDATA%\nvim` for config.
The setup script sets `XDG_CONFIG_HOME=$HOME/.config` in `.bash_profile`, which makes nvim use `~/.config/nvim` instead — the same path the dotfiles already track on Linux/WSL. **No duplicate config, no symlinks needed.**

---

## After running the script

1. **Restart Git Bash** to reload `.bash_profile`
2. **Set terminal font** to `JetBrainsMono Nerd Font` in your terminal settings
3. **Run `nvim`** — lazy.nvim will bootstrap and install all 38 plugins automatically
4. Inside nvim, run **`:Mason`** to install LSP servers:
   - `pyright` — Python
   - `ts_ls` — TypeScript/JavaScript
   - `jsonls` — JSON
   - `tailwindcss` — Tailwind

---

## Potential issues

### `.bash_aliases` symlink
The dotfiles repo tracks `.bash_aliases` as a symlink to a WSL path (`/mnt/c/...`), which doesn't exist in Git Bash. The setup script detects this and replaces it with the actual file content.

### Treesitter parser compilation
Treesitter compiles parsers from C source on first open. Requires LLVM/clang in PATH. If parsers fail to build, run `:TSUpdate` after ensuring `clang` is accessible.

### Mason LSP servers
Mason downloads LSP servers to `~/.local/share/nvim/mason/`. On first launch, run `:Mason` and install the servers for your languages.

### Windows paths in gitconfig
The existing `.gitconfig` uses the `gh` credential helper. Ensure `gh` (GitHub CLI) is installed: `winget install GitHub.cli`, then `gh auth login`.

---

## Syncing changes across machines

After changing nvim config or other dotfiles:

```bash
dotfiles add -u                          # stage all tracked changes
dotfiles commit -m "describe change"
dotfiles push

# On other machines (WSL / omarchy laptop):
dotfiles pull
```
