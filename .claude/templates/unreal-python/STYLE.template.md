# Python Code Style — &lt;PROJECT NAME&gt;

Applies to all Python in this project (typical locations: `Content/Python/`, `PythonSandbox/`, plus whatever this repo uses — list them here).

**Naming:** Variable names describe what the data represents, not its type. Loop variables equally descriptive.

- Bad: `indices`, `float_values`, `conns`, `idx`, `fv`
- Good: `driver_slot_indices`, `driver_values`, `driver_matrix_conns`, `driver_slot_idx`, `driver_val`

**Docstrings:** Every function gets a docstring: what it does, inputs, return value with type. One-liners only for trivial helpers.

**Error handling:** No bare `except Exception: pass`. Every failure gets an explicit check with: `"WARNING: function_name - description on {node}"`. Use `continue` for non-fatal loop failures, `return []`/`return ""`/`return {}` for bail-outs after a warning.

**Defensive coding:** Guard None returns with `or []` / `or 0` / `or {}`. Critical for external-API calls (Maya `cmds`, UE `unreal.*` query functions, filesystem reads) that return `None` on miss rather than raising.

**Deduplication:** `dict.fromkeys()` when order matters. Never `list(set(...))` on ordered data.

**Guard clauses:** Early exits at function top for invalid data. Always warn before returning early. No silent `break` without a comment.

**List comprehensions:** Use for simple transforms. If logic gets complex, use a regular for loop.

**File output:** CSV for tabular human review (`csv.DictWriter` with explicit `fieldnames`). JSON for pipeline data exchange (always `indent=4`).
