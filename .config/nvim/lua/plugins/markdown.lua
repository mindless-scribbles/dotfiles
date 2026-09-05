-- Markdown: keep the lang.markdown extra (render-markdown, preview, marksman)
-- but drop markdownlint-cli2 so reading .md files isn't buried in diagnostics.
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
}
