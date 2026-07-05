# Karabiner-Elements — Caps Lock dual-role (macOS)

macOS equivalent of the kanata setup on Linux/Windows: Caps Lock sends **Escape
when tapped** and **Left Control when held**.

Only the complex-modification asset is tracked
(`assets/complex_modifications/caps_esc_ctrl.json`). The main
`~/.config/karabiner/karabiner.json` is **app-managed and must NOT be tracked** —
Karabiner rewrites it constantly.

## Setup

1. **Install Karabiner-Elements**
   ```sh
   brew install --cask karabiner-elements
   ```
   Launch it once and grant the Input Monitoring / accessibility permissions it asks for.

2. **Enable the rule** (the asset file is already checked out via dotfiles):
   Karabiner-Elements → **Settings** → **Complex Modifications** → **Add rule** →
   enable **"Caps Lock: tap = Escape, hold = Left Control"**.

3. **Test:** tap Caps → Esc; hold Caps + a → Ctrl-a (tmux prefix).

That matches the tap-Esc / hold-Ctrl behavior from kanata on the other machines.
