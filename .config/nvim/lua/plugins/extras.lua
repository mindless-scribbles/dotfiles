return {
  -- Auto-close and auto-rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- HTTP client — send requests from .http files (no luarocks required)
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    opts = {},
    keys = {
      { "<leader>rr", function() require("kulala").run() end,           desc = "Run HTTP request" },
      { "<leader>rp", function() require("kulala").inspect() end,       desc = "Inspect HTTP request" },
      { "<leader>rl", function() require("kulala").replay() end,        desc = "Re-run last HTTP request" },
    },
  },
}
