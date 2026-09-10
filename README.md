# 🍚 rice-cli

> **Declarative Rice & Reproducibility Orchestrator for Arch Linux / CachyOS (Hyprland + chezmoi + Snapper)**

`rice` is a CLI tool designed to make Linux desktop customization (*ricing*) completely **version-controlled**, **reproducible**, and **resilient**, inspired by Git workflows.

---

## ⚡ The Philosophy: Three Pillars

1. **System Disaster Recovery (BTRFS + Snapper):**
   * Instant atomic root snapshots (`/@`) before risky changes or package installs.
   * Rollback cleanly from broken system states without affecting user data in `/home`.

2. **Declarative State & Dotfiles (chezmoi + Package Manifests):**
   * Track dotfiles (`hypr`, `quickshell`, `fish`, `kitty`).
   * Auto-dumps package manifests (`pacman -Qqe`), AUR packages (`pacman -Qqem`), and enabled systemd services.
   * Everything versioned in Git.

3. **Modular Desktop Profiles (Hyprland):**
   * Separation between global hardware/input configuration (`~/.config/hypr/shared/`) and visual/shell desktop setups (`~/.config/hypr/profiles/<name>/`).
   * Switch between completely different rices atomically without breaking monitor resolutions or input rules.
   * Standalone Wayland session entries in your Display Manager (SDDM, GDM, Plasma Login).

---

## 🚀 Architecture

```text
~/.config/hypr/
├── hyprland.lua -> profiles/end4/hyprland.lua  (symlink to active profile)
├── shared/
│   ├── monitors.lua     (display resolution, refresh rate, scaling)
│   ├── input.lua        (keyboard layout, repeat rate, touchpad)
│   ├── env.lua          (NVIDIA drivers, Wayland Ozone hint, QT themes)
│   └── rules.lua        (file pickers, polkit, pip, pinentry)
└── profiles/
    ├── end4/            (Quickshell / illogical-impulse setup)
    │   └── hyprland.lua
    ├── vanilla/         (minimal fallback with Kitty terminal)
    │   └── hyprland.lua
    └── cyberarch/       (cyberpunk netrunner HUD setup)
        └── hyprland.lua
```

---

## 📦 Installation

```bash
git clone https://github.com/RiosWesley/rice-cli.git
cd rice-cli
./install.sh
```

### (Optional) Granting Snapper user permissions & Display Manager entries:
```bash
sudo ./install/setup-system.sh
```

---

## 🛠️ Commands

### `rice status`
Displays the active profile, total packages, latest BTRFS snapshot, and chezmoi status:
```text
=== Rice Environment Status ===
• Active Profile   : end4
• Packages (total) : 1368
• Snapper Root     : 91 │ single │ baseline-cachyos-hyprland-initial
• Chezmoi Commit   : feat(rice): add modular shared and profiles architecture
• Chezmoi Changes  : Clean
```

### `rice list`
Lists all installed profiles and highlights the active one:
```text
=== Available Profiles ===
 * (active) end4
    vanilla
```

### `rice switch <profile>`
Switches the active Hyprland profile symlink instantly:
```bash
rice switch vanilla
# Then run 'hyprctl reload' or re-login in Display Manager
```

### `rice save "<message>"`
Dumps package manifests, captures dotfiles with chezmoi, and creates a git commit:
```bash
rice save "feat: customized keybinds and theme colors"
```

### `rice snapshot "<description>"`
Creates an atomic root snapshot with Snapper:
```bash
rice snapshot "pre-system-upgrade"
```

### `rice diff`
Shows pending uncommitted changes in your live dotfiles compared to chezmoi:
```bash
rice diff
```

---

## 📜 License
MIT License. Feel free to use, fork, and hack!
