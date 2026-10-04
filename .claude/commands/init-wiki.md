---
description: Scaffold the llm-wiki template into the current folder and adapt CLAUDE.md + site branding to whatever is already in ./raw/
argument-hint: [--ingest] [--force]
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

Turn the current directory into an LLM wiki: copy the `llm-wiki` template scaffold in, then rewrite its placeholders so the schema actually describes the sources sitting in `./raw/`.

**Design system: DDC Reel.** Every wiki site (past and future) is styled with Don's DDC Reel
design system: the `ddc-reel` skill (`~/.claude/skills/ddc-reel/`), artifact https://claude.ai/artifact/QBTm2jQ8DC1f9bjhwiuDvw.
`llm-wiki-site` bakes it in, so the site needs no per-wiki styling beyond the four branding
values in Step 5. Load the `ddc-reel` skill before making any other visual for the wiki
(Marp decks, Artifacts, concept widgets).

The wiki holds **markdown and nothing else** — it usually lives in an Obsidian vault, and Obsidian Sync carries only `*.md`. The static HTML site is built from the outside by a second repo, `llm-wiki-site`, which this command registers the new wiki with. Never scaffold a build script or a `site/` folder into the wiki.

Both repos are read-only templates — never write into `llm-wiki`; the only thing you write into `llm-wiki-site` is the new wiki's own `sites/<slug>/` entry.

## Step 0: Sanity-check the location

Run `pwd`. Refuse to continue if the current directory is `$HOME` or `~/.claude` — tell the user to `cd` into the wiki folder first.

Then confirm `./raw/` exists and contains at least one file other than `.gitkeep`. If `raw/` is missing or effectively empty, stop and say so: this command adapts the schema *to* existing sources, so there's nothing to adapt to. (Suggest they drop sources in first, or clone the template directly if they want an empty wiki.)

## Step 1: Resolve the template

```bash
TPL=~/workspace/github.com/mindless-scribbles/llm-wiki
BUILDER=~/workspace/github.com/mindless-scribbles/llm-wiki-site
```

If either path doesn't exist, clone it next to the other:
`git clone https://github.com/mindless-scribbles/llm-wiki{,-site}.git`
(the template may be a `--depth 1` clone; the builder should be a full clone since you write into it).

If the `llm-wiki-site` command isn't on `PATH`, use `node "$BUILDER"/bin/cli.mjs` in its place throughout.

Check for `mmdc` (`command -v mmdc`). It is optional: without it, diagrams stay code blocks on the
site (Obsidian still draws them). If it's missing, note it for the report and suggest
`npm i -g @mermaid-js/mermaid-cli`.

## Step 2: Copy the scaffold

Copy everything except `.git/`, `raw/`, `site/`, and `LICENSE` into the current directory, **without clobbering anything that already exists**:

```bash
rsync -a --ignore-existing \
  --exclude='.git' --exclude='raw' --exclude='site' --exclude='LICENSE' \
  "$TPL"/ ./
```

The template contains no `.mjs`, no `.js`, and no `site/`. If any appear in the target afterwards, something is wrong — say so rather than keeping them.

If `$ARGUMENTS` contains `--force`, drop `--ignore-existing` so template files are refreshed. `raw/` is excluded either way — the user's sources are never touched.

`rsync -a` also brings the template's `.claude/` skills, so every new wiki has them out of the box:

- **`add-diagram`** (`.claude/skills/add-diagram/SKILL.md`): structure described in prose becomes a Mermaid diagram of the matching UML type (state, sequence, component). The builder renders it to inline SVG.

Two global skills (in `~/.claude/skills/`, not copied) work in every wiki:

- **`add-lesson`**: the teaching layer on top of the reference wiki. It drafts a syllabus, then writes `type: lesson` pages (workshop days or tutorials), each phase led by its Why, with a visual or a capture slot per phase. Evidence comes from a reference snapshot in `raw/` or from a timecoded transcript (timecode pills).
- **`work-notes`**: the review loop. Don reads the site on `llm-wiki-site serve` and leaves content or design notes; this skill works them.

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
6. **Writing Rule → Terminology** — delete the `<!-- CUSTOMIZE -->` comment and replace the `[term]` placeholder row with 3–10 real rows drawn from Step 3. Look for things the sources name more than one way: an abbreviation and its long form (`PV` / `pole vector`), a product's old and new name, a vendor term and a generic one. Pick the one the sources use most for `Use`; list the others in `Not`; say why in `Note`. Only list a term in `Not` if it really means the same thing. If the sources are consistent, keep 2–3 rows rather than inventing conflicts. Leave the Writing Rule bullets themselves unchanged.

Leave Workflows, Page Format, Linking Conventions, Rules and the Writing Rule bullets untouched — they're domain-agnostic and already correct.

## Step 5: Customize the branding

Decide the four values first:

- `title` — the knowledge base name (e.g. "Options Trading KB", not "Knowledge Base")
- `brandLetters` — exactly 2 uppercase letters derived from the title (the short brand shown in the header on phones; anything longer is truncated)
- `footer` — `SYS.<SHORT_SLUG>_WIKI / <current year>`, matching the template's `SYS.WIKI / 2026` shape
- `accent` — DDC Reel's `#ff3300`. The design system allows one accent and every wiki shares it. Only use a different hex if the user asks for one.

Then write them into the `site:` block of `./wiki/index.md`'s frontmatter (the template ships it pre-seeded with the defaults):

```yaml
site:
  title: "Options Trading KB"
  brandLetters: "OT"
  footer: "SYS.OPTIONS_WIKI / 2026"
  accent: "#ff3300"
```

This is the primary home because it is markdown, so it survives an Obsidian Sync that carries only `*.md`.

Also write the same four values to `./site.config.json`. It takes precedence over the frontmatter and is what a plain-git wiki uses; keeping the two in step avoids a confusing split. If the wiki is inside an Obsidian vault, say so in the final report — the JSON file will not sync, and the frontmatter is what will actually be doing the work.

## Step 5b: Register the wiki with the builder

Pick a slug (the folder's basename is usually right) and register it, so future rebuilds are a single flag and the site lands **outside** the wiki.

First run `llm-wiki-site vault`. If no vault root is set and this wiki sits inside an Obsidian vault, set it to the vault's root folder (`llm-wiki-site vault <vault-path>`) so the registration stores a relative path and works on Don's other machines too.

```bash
llm-wiki-site register <slug> "$PWD" --out ~/sites/<slug>
```

Confirm with `llm-wiki-site list`. If the user has a preferred output location, use that for `--out` instead.

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

Run `llm-wiki-site build --site <slug>` to confirm the toolchain works before any content exists. Note the output path it prints. If it fails, report the error — don't try to patch the build script.

## Step 8: Report, then offer to ingest

Print a compact summary:

```
LLM wiki initialized: <domain>
  ✓ CLAUDE.md         adapted (entities: <types>, tags: <N> across <M> categories)
  ✓ branding          <title> / <brandLetters> / <accent>  (DDC Reel design system)
                      (wiki/index.md frontmatter + site.config.json)
  ✓ wiki/             scaffolded, index + log seeded — markdown only
  ✓ registered        <slug> -> <out-path>
  ✓ site              built (empty) at <out-path>
  ✓ add-diagram       skill installed (.claude/skills/) — UML-type Mermaid diagrams
                      (mmdc: <found | missing: diagrams stay code blocks on the site>)
  ✓ writing rule      STE-80, <N> terminology rows; `llm-wiki-site lint --site <slug>` checks it
  ⏭  <file>            kept existing
  📄 raw/             <N> sources staged
  👁  review           llm-wiki-site serve  →  http://127.0.0.1:4173/<slug>/  (notes always on)
```

If the sources are a course, a workshop, lecture transcripts (headings like `## MM:SS`) or a
reference project to teach from, mention that `add-lesson` builds the teaching layer after the
ingest: a syllabus first, then one pilot lesson to review on the site.

Then:

- If `$ARGUMENTS` contains `--ingest`, immediately run the **Ingest** workflow from the newly written `CLAUDE.md` for every source in `raw/`, oldest first. Follow that workflow exactly, including the final `llm-wiki-site build --site <slug>`.
- Otherwise, list the staged sources and ask whether to ingest them now, all at once or one at a time.
