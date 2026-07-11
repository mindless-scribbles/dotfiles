---
description: Scaffold the llm-wiki template into the current folder and adapt CLAUDE.md + site branding to whatever is already in ./raw/
argument-hint: [--ingest] [--force]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Turn the current directory into an LLM wiki: copy the `llm-wiki` template scaffold in, then rewrite its placeholders so the schema actually describes the sources sitting in `./raw/`.

The template is the repo at `~/workspace/github.com/mindless-scribbles/llm-wiki`. Treat it as read-only — never write into it.

## Step 0: Sanity-check the location

Run `pwd`. Refuse to continue if the current directory is `$HOME` or `~/.claude` — tell the user to `cd` into the wiki folder first.

Then confirm `./raw/` exists and contains at least one file other than `.gitkeep`. If `raw/` is missing or effectively empty, stop and say so: this command adapts the schema *to* existing sources, so there's nothing to adapt to. (Suggest they drop sources in first, or clone the template directly if they want an empty wiki.)

## Step 1: Resolve the template

```bash
TPL=~/workspace/github.com/mindless-scribbles/llm-wiki
```

If that path doesn't exist, clone it to a scratch dir instead:
`git clone --depth 1 https://github.com/mindless-scribbles/llm-wiki.git <scratch>/llm-wiki` and use that.

## Step 2: Copy the scaffold

Copy everything except `.git/`, `raw/`, `site/`, and `LICENSE` into the current directory, **without clobbering anything that already exists**:

```bash
rsync -a --ignore-existing \
  --exclude='.git' --exclude='raw' --exclude='site' --exclude='LICENSE' \
  "$TPL"/ ./
```

If `$ARGUMENTS` contains `--force`, drop `--ignore-existing` so template files are refreshed. `raw/` is excluded either way — the user's sources are never touched.

Note which files were newly created vs. already present; you'll report this at the end. If `README.md` already existed, leave it alone (it's probably the user's, not the template's).

## Step 3: Survey the sources

List `raw/` recursively. Read enough of each file to understand the domain — the first ~200 lines of each is usually plenty; if there are more than ~10 files, read all of the small ones and sample the large ones. For PDFs or binaries you can't read, note the filenames and infer from those.

You are looking for:

- **The domain** — what body of knowledge do these sources collectively cover?
- **Recurring concepts** — ideas, frameworks, methods, strategies that appear across sources.
- **Recurring entities** — what counts as a "thing" here? People, tools, companies, products, species, characters, protocols? Pick the term that actually fits.
- **Natural tag axes** — the 2-4 dimensions along which these sources vary (e.g. for trading sources: instrument / timeframe / strategy-type).

Don't guess beyond the evidence. If the sources are thin or heterogeneous, say so and keep the taxonomy small.

## Step 4: Customize CLAUDE.md

Edit `./CLAUDE.md` (the copy in the current directory, never the template):

1. **Title** — replace `# [Your Domain] Knowledge Base — Schema` with the real domain.
2. **Purpose** — delete the `<!-- CUSTOMIZE -->` comments and write the one-paragraph description of this knowledge domain, grounded in what's actually in `raw/`. Keep the sentences about the LLM writing `wiki/` and the human curating sources.
3. **Entity pages** — in Directory Layout and in "Required Sections by Page Type", replace the generic "(people, tools, organizations, products — whatever 'things' exist in your domain)" with the entity types that actually exist in these sources.
4. **Tagging Taxonomy** — delete the `<!-- CUSTOMIZE -->` comment block and replace `Category-A/B/C` and `tag-1..9` with 2-4 real categories, 3-8 real tags each, drawn from Step 3. Keep the `Scope` and `Status` categories as-is unless they make no sense for the domain.
5. **Confidence Levels** — adjust the descriptions only if the domain has a different evidence standard (e.g. peer-reviewed vs. anecdotal). Otherwise leave them.

Leave Workflows, Page Format, Linking Conventions, and Rules untouched — they're domain-agnostic and already correct.

## Step 5: Customize site.config.json

Write `./site.config.json` with real branding:

- `title` — the knowledge base name (e.g. "Options Trading KB", not "Knowledge Base")
- `brandLetters` — exactly 2 uppercase letters derived from the title (the header mark has two glyph slots; anything longer is truncated)
- `footer` — `SYS.<SHORT_SLUG>_WIKI / <current year>`, matching the template's `SYS.WIKI / 2026` shape
- `accent` — a 3- or 6-digit hex color. Sibling wikis in the same folder share one accent as a design system, so **check them first** (`cat ../*/site.config.json`) and match. Only diverge if the user asks for a distinct color.

## Step 6: Seed index.md and log.md

In `./wiki/index.md`, set `updated:` to today's date. Leave the empty tables — ingest fills them.

In `./wiki/log.md`, replace the template's `### 2026-04-08 00:00 — Setup` entry with a fresh one dated today:

```
### YYYY-MM-DD HH:MM — Setup
- **Source/Trigger**: /init-wiki — scaffolded from llm-wiki template, schema adapted to <domain>
- **Pages created**: index.md, log.md, dashboard.md, analytics.md, flashcards.md
- **Pages updated**: none
- **Notes**: <N> sources staged in raw/, not yet ingested
```

Get the real date/time from `date -u '+%Y-%m-%d %H:%M'`.

## Step 7: Build the empty site

Run `node build-site.mjs` to confirm the toolchain works before any content exists. If it fails, report the error — don't try to patch the build script.

## Step 8: Report, then offer to ingest

Print a compact summary:

```
LLM wiki initialized: <domain>
  ✓ CLAUDE.md         adapted (entities: <types>, tags: <N> across <M> categories)
  ✓ site.config.json  <title> / <brandLetters> / <accent>
  ✓ wiki/             scaffolded, index + log seeded
  ✓ site/             built (empty)
  ⏭  <file>            kept existing
  📄 raw/             <N> sources staged
```

Then:

- If `$ARGUMENTS` contains `--ingest`, immediately run the **Ingest** workflow from the newly written `CLAUDE.md` for every source in `raw/`, oldest first. Follow that workflow exactly, including the final `node build-site.mjs`.
- Otherwise, list the staged sources and ask whether to ingest them now, all at once or one at a time.
