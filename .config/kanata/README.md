# kanata — Caps Lock dual-role (tap=Esc, hold=Ctrl)

`kanata.kbd` is shared verbatim across Linux and Windows. This README covers the
**Linux (Omarchy/Arch)** setup; the Windows setup is a copy of the `.kbd` plus a
Task Scheduler entry (documented in the HTML guide). macOS uses Karabiner instead
(see `~/.config/karabiner/`).

## Linux setup (Arch / Omarchy)

1. **Install kanata**
   ```sh
   sudo pacman -S kanata      # or: yay -S kanata-bin   or: cargo install kanata
   ```

2. **Grant uinput access** (so a user service can create a virtual keyboard):
   ```sh
   echo uinput | sudo tee /etc/modules-load.d/uinput.conf
   sudo modprobe uinput
   printf 'KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"\n' \
     | sudo tee /etc/udev/rules.d/99-uinput.rules
   sudo usermod -aG input "$USER"
   sudo udevadm control --reload-rules && sudo udevadm trigger
   ```
   Log out and back in so the new `input` group membership takes effect.

3. **Enable the user service** (the unit is tracked at
   `~/.config/systemd/user/kanata.service`, so it's already in place):
   ```sh
   systemctl --user daemon-reload
   systemctl --user enable --now kanata.service
   systemctl --user status kanata     # verify it's running
   ```

4. **Test:** tap Caps → Esc; hold Caps + a → Ctrl-a (tmux prefix).

### Notes
- Works under Wayland/Hyprland (Omarchy): kanata operates at the evdev/uinput
  layer, below the compositor.
- If installed via cargo, edit `ExecStart` in `kanata.service` to
  `%h/.cargo/bin/kanata`.
- Quick manual run without the service: `sudo kanata --cfg ~/.config/kanata/kanata.kbd`.
