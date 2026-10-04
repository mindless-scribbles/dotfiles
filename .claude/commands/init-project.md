---
description: Bootstrap CLAUDE.md / STATUS.md / LESSONS.md in the current repo from Don's session-loop template, adapted for the project's stack
argument-hint: [--force]
allowed-tools: Bash, Read, Write, Edit, Glob
---

Scaffold the session-loop project docs (`CLAUDE.md`, `STATUS.md`, `LESSONS.md`) in the current working directory. Templates live at `~/.claude/templates/project-init/`. The command reads them, adapts placeholders to this project, and writes the results.

## Step 0: Sanity-check the location

Run `pwd` and `git rev-parse --show-toplevel 2>/dev/null` to confirm we're in a project root (or at least somewhere that looks like one — has a `README.md`, `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, or `.git/`).

If the current directory looks empty or unrelated to a project (e.g. `$HOME`), stop and ask the user to `cd` somewhere else first.

## Step 1: Detect existing files

For each of `CLAUDE.md`, `STATUS.md`, `LESSONS.md` in the current directory:

- If `$ARGUMENTS` contains `--force`, plan to overwrite without asking.
- Otherwise, if the file exists, ask the user once: "Found existing `<file>`. Overwrite, preserve as `<NAME>_PREVIOUS.md`, or skip?"
- Apply the answer consistently across all three files unless the user gives per-file answers.

## Step 2: Inspect the project to fill placeholders

Read up to the first 80 lines of each that exists:
- `README.md` — for the project name + description
- `package.json` — language is TypeScript or JavaScript; test = `npm test` or look at `scripts.test`; lint via `scripts.lint`
- `pyproject.toml` — Python; pull `requires-python`; test = `pytest` if listed
- `Cargo.toml` — Rust; test = `cargo test`; lint = `cargo clippy`
- `go.mod` — Go; test = `go test ./...`
- `Makefile` — note any `make test` / `make lint` targets

If none of those exist, leave the Code Style block as `[fill in later]` placeholders. Don't fabricate a stack.

## Step 3: Write CLAUDE.md

Read the template at `~/.claude/templates/project-init/CLAUDE.template.md`. Replace:
- `[PROJECT_NAME]: [Brief description of what this project does]` → real project name and 1-2 sentence description (from README if available; otherwise infer from directory name + top-level structure).
- The four Code Style placeholder lines → real values detected in Step 2 (or leave as `[fill in later]` if unknown).

Write the result to `./CLAUDE.md` (respecting the overwrite/preserve/skip choice from Step 1).

## Step 4: Write STATUS.md

Read `~/.claude/templates/project-init/STATUS.template.md`. Fill in:
- `**Date:** [will be filled by Claude Code]` → today's actual date in YYYY-MM-DD.
- `**Summary:** No prior sessions recorded yet.` → keep as-is unless the user wants this command to also seed the first session note.

Write to `./STATUS.md` (respecting Step 1 choice).

## Step 5: Write LESSONS.md

Read `~/.claude/templates/project-init/LESSONS.template.md`. Write it verbatim to `./LESSONS.md` (respecting Step 1 choice). No adaptation needed — it starts empty.

## Step 6: Report

Print a compact summary:

```
Session-loop docs scaffolded for <project name>
  ✓ CLAUDE.md       written (Language: <detected>, Tests: <detected>)
  ✓ STATUS.md       written (date: YYYY-MM-DD)
  ✓ LESSONS.md      written
  ⏭  <file>          skipped (kept existing)
  💾 <file>_PREVIOUS.md  preserved
```

Then add this one-liner reminder:

> Templates live at `~/.claude/templates/project-init/`. Edit them once, every future `/init-project` picks up the change. If you sync via your dotfiles bare repo, run `dotfiles add ~/.claude/templates/project-init` before `dotfiles commit`.
