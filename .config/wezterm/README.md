# WezTerm config

WezTerm runs as a **Windows** app but this config is versioned in the WSL
`~/.dotfiles` bare repo. A tiny shim on the Windows side bridges the two.

## Files

| File | Tracked? | Purpose |
|------|----------|---------|
| `~/.config/wezterm/wezterm.lua` | ✅ dotfiles repo | The real config (Nord, JetBrainsMono Nerd Font, WSL shell) |
| `C:\Users\Owner\.wezterm.lua` | ❌ Windows-side | One-time shim that `dofile`s the WSL config over UNC |

## Bootstrapping on a new machine

WezTerm looks for `%USERPROFILE%\.wezterm.lua` first. Create it with:

```lua
local wezterm = require("wezterm")
local real = [[\\wsl.localhost\Ubuntu\home\ddecastro\.config\wezterm\wezterm.lua]]
wezterm.add_to_config_reload_watch_list(real)
return dofile(real)
```

Adjust `Ubuntu` (WSL distro) and `ddecastro` (user) in the path if they differ.

## Editing

Edit `~/.config/wezterm/wezterm.lua` from WSL as normal. WezTerm auto-reloads
on save (the shim registers the file in the reload watch list). Commit with the
`dotfiles` alias.
