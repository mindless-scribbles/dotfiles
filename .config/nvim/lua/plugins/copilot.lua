return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      vim.g.copilot_no_tab_map = true

      vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Copilot: Accept suggestion",
      })
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-next)", { desc = "Copilot: Next suggestion" })
      vim.keymap.set("i", "<C-[>", "<Plug>(copilot-previous)", { desc = "Copilot: Previous suggestion" })
      vim.keymap.set("i", "<C-e>", "<Plug>(copilot-dismiss)", { desc = "Copilot: Dismiss suggestion" })
    end,
  },
}
