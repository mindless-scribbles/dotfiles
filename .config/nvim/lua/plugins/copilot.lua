return {
  -- Retired in favour of zbirenbaum/copilot.lua, pulled in by
  -- lazyvim.plugins.extras.ai.copilot. copilot.vim only ever renders inline
  -- block-shaped ghost text and has no setting to cap suggestion length.
  -- Auth is shared (~/.config/github-copilot/apps.json), so nothing to redo.
  { "github/copilot.vim", enabled = false },

  -- Show Copilot as an entry in the completion menu, never as inline ghost text.
  --
  -- vim.g.ai_cmp (LazyVim default: true) already switches copilot.lua's own
  -- suggestion layer off and registers the blink-copilot source instead. But
  -- LazyVim's blink extra also ties completion.ghost_text to vim.g.ai_cmp, which
  -- previews the selected item inline -- and since the copilot source carries
  -- score_offset = 100 it is usually the selected item, so the whole block came
  -- straight back. Turn the preview off and let the menu do the showing.
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = { enabled = false },
      },
    },
  },
}
