# CLAUDE.md

## Project
<!-- Replace with a 1-2 sentence description of what this project is -->
[PROJECT_NAME]: [Brief description of what this project does]

## Session Continuity

At the start of every session, read STATUS.md before doing anything else. Orient yourself before writing any code.

At the end of every session (when I say "wrap up", "park this", "let's stop", "goodnight", or similar), *refresh* STATUS.md in place with:

- What we worked on this session
- Which files were created or modified
- Key decisions made
- Clear next steps (specific, not vague)

## Learning Loop

Read lessons.md at session start alongside STATUS.md.

After any correction or mistake:

1. Fix the immediate problem
2. Add a lesson to lessons.md that prevents the same mistake
3. Keep lessons concrete and short

## Keeping STATUS.md and lessons.md lean

These two files trend toward bloat because each session *appends* to them. They are not archives — git history is the archive. Maintain them so a fresh session can absorb both in one read.

**STATUS.md is a SNAPSHOT, not a log.** Refresh it *in place* each session — overwrite the existing sections; do not stack a new dated section on top of the old ones. Soft budget: **~200 lines.** When a piece of work is done-and-merged, collapse its detail into one line + a git/doc pointer. Per-session narrative belongs in commit messages; deep design/derivation detail belongs in dedicated docs, never inline in STATUS.

**lessons.md is a list of tight rules.** Format: `**[label]:** what to do (or not), and why (date; doc pointer).` Soft budget: **~8 lines per lesson, ~600 lines total.** If a lesson needs more, the derivation belongs in a doc and the lesson links to it. Before adding, check for an existing lesson to *update* rather than duplicate. **Delete superseded lessons** outright — do not keep `[SUPERSEDED]` blocks inline; the git log has them.

**Bloat check:** if STATUS.md exceeds ~250 lines or lessons.md exceeds ~700, prune before adding more.

## Planning

Enter Plan Mode for any task that touches more than 2 files. Do not start coding until I approve the plan. If something goes sideways mid-implementation, stop and re-plan instead of patching.

## Code Style
<!-- Fill in your project-specific preferences -->
- Language: [e.g., Python 3.12, TypeScript, Rust]
- Test framework: [e.g., pytest, jest, cargo test]
- Run tests with: `[your test command]`
- Lint with: `[your lint command]`

## Verification

Never mark a task complete without running the tests and confirming they pass. If tests don't exist for the code you changed, write them.

## Context Management

Use subagents for any investigation that requires reading more than 5 files. Keep the main context clean. Run /compact proactively when context usage exceeds 50%.
