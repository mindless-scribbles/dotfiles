-- ~/.config/wezterm/wezterm.lua  (tracked in the ~/.dotfiles bare repo)
--
-- One config, shared across every machine (Omarchy laptop, Windows workstation
-- via WSL, macOS). Look & feel (Nord, font, padding) is identical everywhere;
-- only the shell-launch differs per OS. WezTerm auto-reloads on save.
--
-- WezTerm runs as a Windows app on the workstation and can't read this WSL
-- path directly — a shim at C:\Users\<user>\.wezterm.lua loads it over UNC.
-- See README.md in this directory.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ── OS detection ─────────────────────────────────────────────────────────
local triple = wezterm.target_triple
local is_windows = triple:find("windows") ~= nil
local is_mac     = triple:find("darwin") ~= nil
-- local is_linux = triple:find("linux") ~= nil

-- ── Shell (the ONLY thing that differs per OS) ───────────────────────────
-- Windows: launch WSL at ~ (preferred default). Native Linux/macOS: use the
-- login shell, so WezTerm just does the right thing there with no config.
if is_windows then
  config.default_prog = { "wsl.exe", "~" }

  -- Extra Windows shells, opened in a NEW WINDOW so the tab bar can stay off
  -- (keeps the Alacritty-clean look; your tmux/WSL window is untouched).
  local win_shells = {
    { label = "WSL",            args = { "wsl.exe", "~" } },
    { label = "Git Bash",       args = { "C:/Program Files/Git/bin/bash.exe", "-i", "-l" } },
    { label = "PowerShell",     args = { "powershell.exe", "-NoLogo" } },
    { label = "PowerShell 7",   args = { "pwsh.exe", "-NoLogo" } },   -- needs PS7 installed
    { label = "Command Prompt", args = { "cmd.exe" } },
  }

  local picker_choices = {}
  for i, s in ipairs(win_shells) do
    picker_choices[i] = { id = tostring(i), label = s.label }
  end

  config.keys = {
    -- Ctrl+Shift+L: fuzzy-pick any shell -> opens it in a new window.
    {
      key = "L",
      mods = "CTRL|SHIFT",
      action = wezterm.action.InputSelector({
        title = "Open a shell in a new window",
        choices = picker_choices,
        action = wezterm.action_callback(function(window, pane, id, _label)
          if not id then return end -- cancelled
          window:perform_action(
            wezterm.action.SpawnCommandInNewWindow({ args = win_shells[tonumber(id)].args }),
            pane
          )
        end),
      }),
    },
  }
end

-- ── Font (identical everywhere for a consistent feel) ────────────────────
-- Install "JetBrainsMono Nerd Font" on each machine:
--   Arch/Omarchy: pacman -S ttf-jetbrains-mono-nerd
--   macOS:        brew install --cask font-jetbrains-mono-nerd-font
--   Windows:      already installed
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 9.0
-- Retina Macs often read a touch large; bump per-machine if needed, e.g.:
-- if is_mac then config.font_size = 13.0 end

-- ── Window: 14px padding all round, no tab bar (you live in tmux) ─────────
config.window_padding = { left = 14, right = 14, top = 14, bottom = 14 }
config.enable_tab_bar = false                     -- Alacritty has no tabs
config.window_close_confirmation = "NeverPrompt"  -- close instantly, like Alacritty
config.scrollback_lines = 10000                   -- Alacritty's default history
config.audible_bell = "Disabled"
config.default_cursor_style = "SteadyBlock"       -- matches Alacritty's block cursor

-- macOS niceties (no-ops elsewhere): make the left Option key send Alt/Meta so
-- tmux/nvim Alt-bindings work, and use native fullscreen.
if is_mac then
  config.send_composed_key_when_left_alt_is_pressed = false
end

-- ── Colors: Nord (exact hex from the old Alacritty config) ───────────────
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
