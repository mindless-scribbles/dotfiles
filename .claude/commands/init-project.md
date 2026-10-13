---
description: Bootstrap CLAUDE.md / STATUS.md / LESSONS.md in the current repo from Don's session-loop template, adapted for the project's stack
argument-hint: [--force]
allowed-tools: Bash, Read, Write, Edit, Glob, AskUserQuestion
---

Scaffold the session-loop project docs (`CLAUDE.md`, `STATUS.md`, `LESSONS.md`) in the current working directory. Templates live at `~/.claude/templates/project-init/`. The command reads them, adapts placeholders to this project, and writes the results. Unreal repos also get the add-ons in `~/.claude/templates/unreal-plugin/` or `~/.claude/templates/unreal-python/` (Step 1b).

## Step 0: Sanity-check the location

Run `pwd` and `git rev-parse --show-toplevel 2>/dev/null` to confirm we're in a project root (or at least somewhere that looks like one — has a `README.md`, `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `*.uplugin`, `*.uproject` or `.git/`).

If the current directory looks empty or unrelated to a project (e.g. `$HOME`), stop and ask the user to `cd` somewhere else first.

## Step 1: Detect existing files

For each of `CLAUDE.md`, `STATUS.md`, `LESSONS.md` in the current directory:

- If `$ARGUMENTS` contains `--force`, plan to overwrite without asking.
- Otherwise, if the file exists, ask the user once: "Found existing `<file>`. Overwrite, preserve as `<NAME>_PREVIOUS.md`, or skip?"
- Apply the answer consistently across all three files unless the user gives per-file answers.

On a case-insensitive mount (`/mnt/*`), `lessons.md` and `LESSONS.md` are the same file; treat an existing `lessons.md` as an existing `LESSONS.md`.

## Step 1b: Detect an Unreal variant

Check, in this order, and confirm the variant with the user before writing anything:

- **unreal-plugin**: a `*.uplugin` in the root. Add-ons: `~/.claude/templates/unreal-plugin/plugin/` (`CLAUDE.addendum.md`, `STATUS.addendum.md`, `LESSONS.seed.md`, `FLOW.template.md`).
- **unreal-shell**: a `*.uproject` in the root. Ask (AskUserQuestion, recommended option first) whether it is an editor shell that hosts junctioned plugins or a real game project. A game project gets the plain base templates. A shell gets only the router: see Step 7, and skip Steps 2-5.
- **unreal-python**: `grep -rlE '^\s*(import unreal|from unreal )' --include=*.py .` (skip `.venv`, `__pycache__`) finds files. Add-ons: `~/.claude/templates/unreal-python/` (`CLAUDE.addendum.md`, `LESSONS.seed.md`, `STYLE.template.md`).
- Otherwise: no variant; Steps 2-6 run as written.

Fill the add-ons' `[SQUARE_BRACKET]` placeholders from the repo where you can and ask for the rest:

- `[PLUGIN_NAME]`: the `.uplugin` filename. `[PLUGIN_TYPE]`: the first module's `"Type"`. `[LOADING_PHASE]`: its `"LoadingPhase"` (default `Default`). `[MODULE_CLASS]`: from `IMPLEMENT_MODULE(<class>, ...)` under `Source/`.
- `[UE_VERSION]`: major.minor (`5.8`, matching the `UE_5.8` install folder) from the `.uplugin`/`.uproject` `EngineVersion`/`EngineAssociation`, or `ls /mnt/c/Program\ Files/Epic\ Games/`, or ask.
- `[PLUGIN_REPO_PATH]`, `[SHELL_PATH]`: Windows paths (`/mnt/z/Foo` is `Z:\Foo`). Find the shell by asking; to confirm, `ls -la /mnt/z/*/Plugins/` shows junctions pointing here.
- `[SHELL_PROJECT]`: the shell's `.uproject` name without the extension.
- Shell router: one row per junction under `Plugins/` (`[PLUGIN_NAME]`, `[PLUGIN_REPO_PATH]`, `[PLUGIN_DESCRIPTION]` from that repo's CLAUDE.md or README); real folders such as vendored content go in the "ignore" comment. Ask which plugin is the active default.
- Python: `[ONE_LINE: ...]` (from the README, like the base project description), `[UE_PROJECT_PATH]` (ask; a Windows path such as `Z:\Proj`), `[DISTRO]` (`$WSL_DISTRO_NAME`), `[ABS_REPO_PATH]` (`pwd` without its leading slash, so `//wsl$/[DISTRO]/[ABS_REPO_PATH]` has no double slash). Fill STYLE.md's folder list from the repo's top-level Python folders.

## Step 2: Inspect the project to fill placeholders

Read up to the first 80 lines of each that exists:
- `README.md` — for the project name + description
- `package.json` — language is TypeScript or JavaScript; test = `npm test` or look at `scripts.test`; lint via `scripts.lint`
- `pyproject.toml` — Python; pull `requires-python`; test = `pytest` if listed
- `Cargo.toml` — Rust; test = `cargo test`; lint = `cargo clippy`
- `go.mod` — Go; test = `go test ./...`
- `Makefile` — note any `make test` / `make lint` targets

If none of those exist, leave the Code Style block as `[fill in later]` placeholders. Don't fabricate a stack. (An Unreal add-on supplies its own Code Style block in Step 3.)

## Step 3: Write CLAUDE.md

Read the template at `~/.claude/templates/project-init/CLAUDE.template.md`. Replace:
- `[PROJECT_NAME]: [Brief description of what this project does]` → real project name and 1-2 sentence description (from README if available; otherwise infer from directory name + top-level structure).
- The four Code Style placeholder lines → real values detected in Step 2 (or leave as `[fill in later]` if unknown).

For an Unreal variant, merge `CLAUDE.addendum.md` into that result:
- Its `## Code Style` and `## Verification` sections replace the base sections of the same name, in place.
- Every other `## ` section is appended after the base's last section, in the add-on's order.
- Drop the add-on's opening HTML comment, and fill its placeholders (Step 1b).

Write the result to `./CLAUDE.md` (respecting the overwrite/preserve/skip choice from Step 1).

## Step 4: Write STATUS.md

Read `~/.claude/templates/project-init/STATUS.template.md`. Fill in:
- `**Date:** [will be filled by Claude Code]` → today's actual date in YYYY-MM-DD.
- `**Summary:** No prior sessions recorded yet.` → keep as-is unless the user wants this command to also seed the first session note.

For unreal-plugin, append the sections of `STATUS.addendum.md` after Active Context, with placeholders filled.

Write to `./STATUS.md` (respecting Step 1 choice).

## Step 5: Write LESSONS.md

Read `~/.claude/templates/project-init/LESSONS.template.md`. Write it verbatim to `./LESSONS.md` (respecting Step 1 choice). No adaptation needed — it starts empty.

For an Unreal variant, replace the line `(No lessons yet. This file will grow as we work together.)` with the rules in `LESSONS.seed.md` (without its opening HTML comment), placeholders filled. Leave out seeded rules for subsystems the repo doesn't touch (e.g. Sequencer or RigVM rules in a repo with neither) and list what you left out in the report.

## Step 6: Unreal extras

- unreal-plugin: copy `FLOW.template.md` to `./FLOW.md` with placeholders filled, unless `FLOW.md` exists.
- unreal-python: copy `STYLE.template.md` to `./STYLE.md` with `[PROJECT_NAME]` filled, unless `STYLE.md` exists.
- Every Unreal variant: offer `.claude/settings.local.json` from `~/.claude/templates/unreal-mcp/settings.local.template.json`. If the file exists, merge its `enabledMcpjsonServers` and `permissions.allow` entries instead of overwriting. Point the user at `~/.claude/templates/unreal-mcp/README.md` if `claude mcp list` doesn't show `unreal-mcp` as connected.

## Step 7: Unreal editor shell

Only for a shell (Step 1b):

1. Write `./CLAUDE.md` from `~/.claude/templates/unreal-plugin/shell/CLAUDE.router.template.md`, one table row per junctioned plugin (`ls -la Plugins/`).
   Drop the HTML comments once their rows and notes are filled.
2. If the shell is under Perforce (`p4config.txt`, `.p4ignore`, or the user says so), offer `p4config.template.txt` and `p4ignore.template` from the same folder, following `~/.claude/templates/unreal-plugin/reference/perforce-multi-project.md`.
   If it isn't, follow the router's comment and drop the Perforce bullets.
3. Offer the settings file as in Step 6.

No STATUS.md or LESSONS.md: those live in the plugin repos.

## Step 8: Report

Print a compact summary:

```
Session-loop docs scaffolded for <project name>  [variant: <none|unreal-plugin|unreal-shell|unreal-python>]
  ✓ CLAUDE.md       written (Language: <detected>, Tests: <detected>)
  ✓ STATUS.md       written (date: YYYY-MM-DD)
  ✓ LESSONS.md      written (<n> seeded rules)
  ✓ <extra>         written (FLOW.md / STYLE.md / .claude/settings.local.json)
  ⏭  <file>          skipped (kept existing)
  💾 <file>_PREVIOUS.md  preserved
```

For a shell, the lines are CLAUDE.md (router, <n> plugin rows), the settings file, and the p4 files if written; there is no STATUS.md or LESSONS.md.

List any placeholder left unfilled.

Then add this one-liner reminder:

> Templates live in `claude-project-templates/project-init/` (symlinked from `~/.claude/templates/project-init/`), with Unreal add-ons in `unreal-plugin/`, `unreal-python/` and `unreal-mcp/` beside it. Edit them in that repo and commit; every future `/init-project` picks up the change.
