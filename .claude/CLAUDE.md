# Global Claude Instructions

## References

- Python / uv environments: see `~/.claude/python-uv.md`

## Project session-loop docs

Repos under `~/workspace/` should follow the three-file session loop: `CLAUDE.md` (project doc + session-continuity rules), `STATUS.md` (last session, files modified, next steps), `LESSONS.md` (running list of project lessons).

- Templates live at `~/.claude/templates/project-init/` (CLAUDE/STATUS/LESSONS as `*.template.md`).
- To bootstrap a repo: run `/init-project` (slash command at `~/.claude/commands/init-project.md`).
- When entering a new session in a repo that has these files, read `STATUS.md` and `LESSONS.md` before doing anything else.

## LLM wikis

Template repo: `~/workspace/github.com/mindless-scribbles/llm-wiki` (raw sources in, LLM-maintained wiki + static site out).

- To turn a folder that already has a populated `raw/` into a wiki: run `/init-wiki` (slash command at `~/.claude/commands/init-wiki.md`). It copies the scaffold and rewrites the `CLAUDE.md` placeholders — purpose, entity types, tagging taxonomy — to match the sources actually present.
