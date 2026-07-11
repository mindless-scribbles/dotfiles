---
description: Scaffold Maya Python LSP environment (uv init + maya-stubs + pyrightconfig)
argument-hint: [2023|2024|2025]
allowed-tools: Bash, Read, Write, Edit, Glob
---

Set up a Maya Python LSP/autocomplete environment in the current working directory.

## Step 1: Determine Maya and Python versions

Parse `$ARGUMENTS` for a Maya version (2023, 2024, or 2025). Default to 2024 if not provided or unrecognized.

Map Maya version to Python version:
- 2025 → 3.11
- 2024 → 3.10
- 2023 → 3.9

## Step 2: Initialize the uv project

Check if `pyproject.toml` already exists in the current directory.

- If it exists: report "`pyproject.toml` already exists — skipping init" and skip to Step 3.
- If it does not exist: run `uv init --python <PYTHON_VERSION> --no-workspace` (e.g. `uv init --python 3.10 --no-workspace`) to create the project. This generates `pyproject.toml`, `uv.lock`, and `.python-version`.

## Step 3: Install packages

Run: `uv add maya-stubs pymel`

This installs into the project-managed `.venv` and updates `pyproject.toml` and `uv.lock`.

Report success or any errors.

## Step 4: Write `pyrightconfig.json`

Write (overwrite if present) `pyrightconfig.json` in the current directory with this exact content, substituting the correct Python version string (e.g. `"3.10"`):

```json
{
  "pythonVersion": "<PYTHON_VERSION>",
  "venvPath": ".",
  "venv": ".venv",
  "typeCheckingMode": "basic"
}
```

## Step 5: Update `~/.config/nvim/lazyvim.json`

Read `~/.config/nvim/lazyvim.json`. If it does not exist, skip this step and note it.

If the file exists, parse its JSON. Locate the `extras` array (create it if missing). If `"lazyvim.plugins.extras.lang.python"` is not already in the array, append it. Write the file back with 2-space indentation.

## Step 6: Update `.gitignore`

Check if `.gitignore` exists in the current directory.

- If it does not exist: create it with the single line `.venv/`.
- If it exists: read it and check whether `.venv/` (or `.venv`) is already present.
  - If present: skip and report "`.venv/` already in `.gitignore`".
  - If not present: append a newline followed by `.venv/` to the file.

## Step 7: Report

Print a summary of what was done and what was skipped, for example:

```
Maya 2024 environment ready (Python 3.10)
  ✓ .venv created
  ✓ maya-stubs + pymel installed
  ✓ pyrightconfig.json written
  ✓ lazyvim.plugins.extras.lang.python added to ~/.config/nvim/lazyvim.json
  ✓ .venv/ added to .gitignore
```
