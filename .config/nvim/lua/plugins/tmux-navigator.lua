-- Seamless Ctrl-h/j/k/l movement between nvim splits and tmux panes.
-- Pairs with the "smart pane switching" block in ~/.tmux.conf.
-- With Caps=Ctrl, these are Caps+h/j/k/l — no tmux prefix needed.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate pane/split left" },
    { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate pane/split down" },
    { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate pane/split up" },
    { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate pane/split right" },
  },
}
