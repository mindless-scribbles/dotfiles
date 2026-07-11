---
name: Copilot nvim auth workaround
description: copilot.vim auth hangs in WSL2; must use manual terminal device flow to write apps.json
type: project
originSessionId: ed46d82f-dba0-4470-b2e2-8e0352d338ad
---
`:Copilot setup` reliably hangs in WSL2. Root causes: npx download races with device code expiry; `gh` CLI tokens rejected by copilot token endpoint even with `copilot` scope; language server historically wrote token with trailing space.

**Fix:** manual terminal device flow using `client_id=Iv1.b507a08c87ecfe98`, write result to `~/.config/github-copilot/apps.json`. Full steps in `~/.config/nvim/copilot-auth.md`.

**Why:** Copilot token endpoint only accepts tokens from the Copilot GitHub App specifically, not generic OAuth tokens.

**How to apply:** If user reports Copilot auth issues on any machine, point them to the script in `~/.config/nvim/copilot-auth.md`. Do NOT suggest `:Copilot setup` — it will hang.
