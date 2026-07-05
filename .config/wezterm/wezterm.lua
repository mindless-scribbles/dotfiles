-- ~/.config/wezterm/wezterm.lua  (tracked in the ~/.dotfiles bare repo)
--
-- Canonical WezTerm config. WezTerm runs as a Windows app, so it can't read
-- this WSL path directly — a small shim at C:\Users\<user>\.wezterm.lua loads
-- this file over the WSL UNC path. See README.md in this directory.
--
-- Faithful port of the old Alacritty config: Nord theme, JetBrainsMono Nerd
-- Font, launches straight into WSL at ~. WezTerm auto-reloads on save.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── Shell: launch WSL at the home dir (matches `wsl.exe ~`) ───────────────
config.default_prog = { "wsl.exe", "~" }

-- ── Font (JetBrainsMono Nerd Font 9) ─────────────────────────────────────
-- WezTerm derives bold/italic from the same family automatically.
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 9.0

-- ── Window: 14px padding all round, no tab bar (you live in tmux) ─────────
config.window_padding = { left = 14, right = 14, top = 14, bottom = 14 }
config.enable_tab_bar = false                     -- Alacritty has no tabs
config.window_close_confirmation = "NeverPrompt"  -- close instantly, like Alacritty
config.scrollback_lines = 10000                   -- Alacritty's default history
config.audible_bell = "Disabled"
config.default_cursor_style = "SteadyBlock"       -- matches Alacritty's block cursor

-- ── Colors: Nord (exact hex from the Alacritty config) ───────────────────
config.colors = {
  foreground = "#d8dee9",
  background = "#2e3440",

  cursor_bg = "#d8dee9",
  cursor_fg = "#2e3440",
  cursor_border = "#d8dee9",

  selection_fg = "#d8dee9",
  selection_bg = "#4c566a",

  -- normal: black red green yellow blue magenta cyan white
  ansi = {
    "#3b4252", "#bf616a", "#a3be8c", "#ebcb8b",
    "#81a1c1", "#b48ead", "#88c0d0", "#e5e9f0",
  },
  -- bright
  brights = {
    "#4c566a", "#bf616a", "#a3be8c", "#ebcb8b",
    "#81a1c1", "#b48ead", "#8fbcbb", "#eceff4",
  },
}

return config
