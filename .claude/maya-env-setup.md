# Maya Python LSP Environment Setup

## Command

```
/maya-env [2023|2024|2025]
```

Scaffolds a full Maya Python LSP/autocomplete environment in the **current working directory**. Safe to re-run on an existing repo — already-done steps are skipped.

## Arguments

| Argument | Python version |
|----------|---------------|
| `2025`   | 3.11           |
| `2024`   | 3.10 (default) |
| `2023`   | 3.9            |

Omitting the argument defaults to Maya 2024 (Python 3.10).

## What gets created / modified

| Path | Action |
|------|--------|
| `.venv/` | Created via `uv venv .venv` (skipped if already exists) |
| `.venv/` packages | `maya-stubs` + `pymel` installed via `uv pip install` |
| `pyrightconfig.json` | Written (overwritten) with `pythonVersion`, `venvPath`, `venv`, `typeCheckingMode` |
| `~/.config/nvim/lazyvim.json` | `lazyvim.plugins.extras.lang.python` appended to `extras` if not present |
| `.gitignore` | `.venv/` appended if not already there; file created if missing |

## Re-running safely

- `.venv/` exists → creation step skipped, packages are still reinstalled/updated
- `pyrightconfig.json` exists → overwritten with fresh config for the requested Maya version
- `lazyvim.json` already contains the Python extra → no change
- `.gitignore` already contains `.venv/` → no change

## Typical first-time output

```
Maya 2024 environment ready (Python 3.10)
  ✓ .venv created
  ✓ maya-stubs + pymel installed
  ✓ pyrightconfig.json written
  ✓ lazyvim.plugins.extras.lang.python added to ~/.config/nvim/lazyvim.json
  ✓ .venv/ added to .gitignore
```
