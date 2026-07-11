# Python / uv Environment Setup

Always use the `uv` project workflow when setting up Python virtual environments:

1. `uv init --python <version> --no-workspace` — initializes the project, generates `pyproject.toml`, `.python-version`
2. `uv add <packages>` — installs dependencies, generates `uv.lock` and `.venv`

Never use `uv venv` + `uv pip install` — that creates a bare `.venv` with no `pyproject.toml` or `uv.lock`, which is not a proper uv project.
