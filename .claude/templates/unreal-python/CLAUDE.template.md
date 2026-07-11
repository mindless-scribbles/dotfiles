# CLAUDE.md — &lt;PROJECT NAME&gt;

&lt;ONE-LINE DESCRIPTION: what this repo's Unreal Python does, e.g. "UE5 Python scripts that build X programmatically"&gt;. If this repo consumes data from upstream producers (DCC tools, schema generators, pipeline repos), list them here.

## How a UE project consumes this repo

UE reads these scripts via **Project Settings → Python → Additional Paths**. On Windows (WSL-backed), the UNC path to this repo is:

```
\\wsl$\<distro>\<absolute-path-to-this-repo>
```

Add that string to `+AdditionalPaths=(Path="...")` under `[/Script/PythonScriptPlugin.PythonScriptPluginSettings]` in the consuming project's `Config/DefaultEditor.ini`. UE's Python interpreter then adds it to `sys.path` at editor startup.

Scripts run from the UE Python console via:
```python
exec(open(r"\\wsl$\<distro>\<absolute-path-to-this-repo>\<script_name>.py").read())
```
or by `import <module_name>` once the path is registered.

Notes:
- Restart the editor (or re-register paths) after editing `DefaultEditor.ini`.
- UE's embedded interpreter is Python 3.x; do not rely on packages that aren't either in the UE install or vendored into this repo.
- `exec(open(...).read())` reruns the whole script in the console's global scope — useful for iteration, but be aware any module-level side effects fire every time.

## Directory layout

```
<repo-root>/
├── <top_level_builder_scripts>.py      Primary build entry points run from UE console
├── <shared_primitives>.py              Reusable helpers (optional)
├── unreal_python_utilities/            inspect_*.py / run_*.py / test_*.py — graph builders + probes
├── ue_quick_run_python_scripts/        UE-console convenience wrappers (optional)
├── <data_folder>/                      Working copy of pipeline JSON / CSV inputs (optional)
├── STYLE.md                            Python style rules for this repo
├── <SUBSYSTEM>_CONVENTIONS.md          Per-UE-subsystem node/API conventions (add one per subsystem touched)
├── STATUS.md                           Session continuity — read at session start
└── lessons.md                          Accumulated lessons — read at session start
```

The `inspect_*.py` / `run_*.py` / `test_*.py` split in `unreal_python_utilities/` is a convention worth keeping: `inspect_*` dumps unknown API surfaces (pin names, class members, defaults) before you code against them, `run_*` executes a build, `test_*` probes a built asset for correctness.

## Conventions

- **Python style:** see `STYLE.md`.
- **UE subsystem conventions:** whenever this repo touches a UE subsystem (Control Rig / RigVM, Sequencer, Niagara, Animation, etc.), add a `<SUBSYSTEM>_CONVENTIONS.md` capturing the exact node/class/pin names that have been confirmed to work, and link it from this file. Deprecated APIs and their replacements belong here.
- **Inspect before you code:** before using any UE node/class/struct not previously confirmed working in this repo, write a one-off `inspect_*.py` that imports the class and dumps its pins/members/defaults. UE Python surfaces silent wrong-pin bugs that cost hours; an inspect script costs minutes.
- **Session continuity:** read `STATUS.md` and `lessons.md` at the start of every session before writing code.

## Data contracts

If this repo consumes JSON/CSV (or any other) data produced by another tool or repo, document here:

- **Input file** — expected path (usually under `<data_folder>/`)
- **Producer** — which script/repo generates it
- **Schema** — either inline here for small payloads, or a pointer to the producer script where the schema lives inline in code

Rule: **schemas live inline in the producer script**. When a schema changes, update both producer and consumer repos in lockstep — no shared code dependency, no separate schema package.

## Target asset path(s)

Scripts build into UE assets at fixed paths inside the consuming project, e.g.:

```
/Game/<path>/<to>/<Asset_Name>
```

Keep each such path as a single `<CONSTANT>` at the top of the relevant script (e.g. `BP_PATH`, `SK_PATH`). When deploying to another UE project, updating these constants should be the only change required.

## Learning loop

After any correction or mistake: (1) fix, (2) add a concrete short lesson to `lessons.md`. Lessons earn their keep by preventing the same mistake — write them so a future session reading `lessons.md` cold can avoid the bug without re-deriving it.
