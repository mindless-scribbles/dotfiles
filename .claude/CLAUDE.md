# Global Claude Instructions

## References

- Python / uv environments: see `~/.claude/python-uv.md`

## Project session-loop docs

Repos under `~/workspace/` should follow the three-file session loop: `CLAUDE.md` (project doc + session-continuity rules), `STATUS.md` (last session, files modified, next steps), `LESSONS.md` (running list of project lessons).

- Templates live in `~/workspace/github.com/mindless-scribbles/claude-project-templates/project-init/` (CLAUDE/STATUS/LESSONS as `*.template.md`); `~/.claude/templates/project-init` is a symlink to that folder, so edit them in the repo.
- To bootstrap a repo: run `/init-project` (slash command at `~/.claude/commands/init-project.md`).
- When entering a new session in a repo that has these files, read `STATUS.md` and `LESSONS.md` before doing anything else.
- If the working folder has a `HANDOFF.md` (written by the cache-clock mod when a session went idle before its prompt cache went cold), read it first and check its header line (`session= written= branch= head=`). If the branch or HEAD differs from the repo's now, or it's over 24 hours old (file time when there's no header), say it's stale and don't offer to continue. Otherwise say in one line what it covers and how old it is, and offer to continue from it; that's far cheaper than resuming the old session. Either way the mod deletes the note after this first turn, so its content lives on only in this conversation.
- When refreshing STATUS.md at wrap-up, fold anything still live from `HANDOFF.md` into it and delete the handoff.

## LLM wikis

Template repo: `~/workspace/github.com/mindless-scribbles/llm-wiki` (raw sources in, LLM-maintained wiki + static site out).

- To turn a folder that already has a populated `raw/` into a wiki: run `/init-wiki` (slash command at `~/.claude/commands/init-wiki.md`). It copies the scaffold and rewrites the `CLAUDE.md` placeholders — purpose, entity types, tagging taxonomy — to match the sources actually present.

## Design default: DDC Reel

For any Artifact, HTML page, mockup, deck, Design canvas, social card or other visual I ask for, load the `ddc-reel` skill first (`~/.claude/skills/ddc-reel/`) and build on the DDC Reel design system (https://claude.ai/artifact/QBTm2jQ8DC1f9bjhwiuDvw). When the Artifact tool offers design systems, pick DDC Reel. Only use a different look when I ask for one.

## Advisor

When the advisor tool is available, consult it:

- before starting a risky plan (destructive, hard to reverse, or touching many files)
- after the same error occurs twice, before trying another fix
- before accepting complex work as complete

## Agents

Default for every session: the main session (Opus) executes, Fable advises through the advisor tool, and Sonnet `worker` agents take scoped changes.

Custom agents live in `~/.claude/agents/`. Default routing:

- Locating code (more than ~5 files to sweep): `explorer`, not the built-in `Explore`.
- Questions answered by docs, API references or changelogs: `researcher`.
- Executing an approved plan step: `worker`, not `general-purpose`. One scoped change per worker; run independent workers in parallel.
- Planning, design decisions and final verification stay in the main session (plus the advisor).
