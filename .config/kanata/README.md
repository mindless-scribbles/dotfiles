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

2. **Grant uinput access** (so a user service can create a virtual keyboard).
   The udev rule is tracked here as `99-uinput.rules` — copy it into place:
   ```sh
   echo uinput | sudo tee /etc/modules-load.d/uinput.conf
   sudo modprobe uinput
   sudo cp ~/.config/kanata/99-uinput.rules /etc/udev/rules.d/
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

## Recovering after an Omarchy upgrade

Omarchy upgrades wipe `/etc/udev/rules.d/`, which the dotfiles repo cannot track.
When that happens kanata crash-loops with `Permission denied (os error 13)` and
`Failed to open the output uinput device`, and Caps Lock reverts to Caps Lock.
(The 2026-08-28 "quattro" upgrade did exactly this — 8500+ restarts before it was
noticed.) To recover:

```sh
sudo cp ~/.config/kanata/99-uinput.rules /etc/udev/rules.d/
sudo chgrp input /dev/uinput && sudo chmod 660 /dev/uinput
```

The second line is the part that is easy to miss: `OPTIONS+="static_node=uinput"`
only applies when the `uinput` module is *loaded*. If the module is already loaded
(it is, from boot), `udevadm trigger` will NOT repermission the existing
`/dev/uinput` node — you must fix the live node by hand, or reboot. Verify with
`ls -l /dev/uinput`; it should read `crw-rw---- root input`, not `root root`.

kanata retries every 2s, so it comes back on its own once permissions are right.

### Notes
- Works under Wayland/Hyprland (Omarchy): kanata operates at the evdev/uinput
  layer, below the compositor.
- If installed via cargo, edit `ExecStart` in `kanata.service` to
  `%h/.cargo/bin/kanata`.
- Quick manual run without the service: `sudo kanata --cfg ~/.config/kanata/kanata.kbd`.
- Escape hatch if kanata ever wedges the keyboard: **lctl+spc+esc** force-exits it
  (pre-remap keys, i.e. the real left Ctrl — not Caps).
