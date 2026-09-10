<div align="center">

# 🍚 rice-cli

### **Declarative Desktop Orchestrator for Arch Linux / CachyOS**
*Hyprland Profiles • BTRFS Root Snapshots (Snapper) • Declarative Dotfiles & Manifests (chezmoi)*

<p align="center">
  <img src="https://img.shields.io/badge/status-early--stage%20%2F%20unstable-orange?style=for-the-badge" alt="Status" />
  <img src="https://img.shields.io/badge/target-Hyprland-blue?style=for-the-badge&logo=hyprland" alt="Hyprland" />
  <img src="https://img.shields.io/badge/recovery-Snapper%20%2B%20BTRFS-red?style=for-the-badge" alt="Snapper" />
  <img src="https://img.shields.io/badge/dotfiles-chezmoi-green?style=for-the-badge" alt="chezmoi" />
</p>

</div>

> ⚠️ **EARLY-STAGE & HIGHLY EXPERIMENTAL**  
> This project is in active development. APIs, directory conventions, and CLI flags may shift between commits. Always verify your BTRFS subvolumes and keep an external live USB handy when dealing with system-level rollbacks.

---

## 💡 The Problem: Why does ricing break Linux?

Whenever you stumble upon an awesome rice on GitHub (e.g. CyberArch, End4, Hyprcraft) and want to test it:
1. **The installer destroys your user config:** It forcibly overwrites `~/.config/hypr/hyprland.conf` or `hyprland.lua`, replaces your `kitty.conf`, kills your running daemons (`waybar`, `mako`, `quickshell`), and overrides your font settings.
2. **The installer pollutes the system:** It runs `sudo pacman -S` or AUR scripts that touch `/usr/share/`, `/etc/`, and systemd units.
3. **Rollback is a nightmare:** If you don't like the new theme or if your second monitor stops working, you spend hours manually cleaning directories or end up reinstalling the OS.

`rice-cli` solves this by introducing **Two-Tier Disaster Recovery**:
* **Layer 1: System Disaster Recovery (BTRFS + Snapper):** Atomic root snapshots (`/@`). Reverts kernel/driver breaks, systemd units, and `/usr` changes in seconds.
* **Layer 2: User State Rollback (chezmoi + Git):** Tracks dotfiles and dumps native (`pacman -Qqe`) and AUR package lists. Reverts invasive dotfile overwrites instantly with `rice restore`.
* **Layer 3: Modular Profiles:** Segregates hardware/inputs (`shared/`) from theme layouts (`profiles/`).

---

## 🏗️ Architecture

```text
~/.config/hypr/
├── hyprland.lua -> profiles/end4/hyprland.lua   # Active profile symlink
├── shared/                                     # Global hardware / core settings
│   ├── monitors.lua     (resolution, refresh rates, scaling)
│   ├── input.lua        (keyboard layout, repeat rate, touchpad)
│   ├── env.lua          (GPU/NVIDIA flags, Ozone Wayland, QT theming)
│   └── rules.lua        (file pickers, polkit, pip, pinentry)
└── profiles/                                   # Isolated desktop setups
    ├── end4/            (Quickshell / illogical-impulse setup)
    │   └── hyprland.lua
    ├── vanilla/         (minimal fallback with Kitty terminal)
    │   └── hyprland.lua
    └── <other-rices>/
        └── hyprland.lua
```

---

## ⚡ Quick Start & Workflow

### 1. Save your baseline state
Before doing anything crazy or testing random scripts from GitHub:
```bash
rice save "my clean baseline setup"
rice snapshot "pre-experiment-checkpoint"
```

### 2. Test any foreign rice without fear
Clone any rice you want and run their installer:
```bash
git clone https://github.com/someone/crazy-aggressive-rice.git /tmp/rice
cd /tmp/rice && ./install.sh
```
Let it overwrite whatever it wants in `~/.config/`.

### 3. Didn't like it? Revert everything in 1 command:
```bash
rice restore
```
`rice restore`:
* Force-reapplies your saved dotfiles from `chezmoi`.
* Re-points `~/.config/hypr/hyprland.lua` back to your default profile (`end4`).
* Reloads the compositor (`hyprctl reload`).
* If the foreign rice also messed up system packages or `/etc`, you can also rollback the BTRFS snapshot via `snapper undochange`.

---

## 🛠️ Command Reference

| Command | Description |
| :--- | :--- |
| `rice status` | Displays active profile, total package count, latest BTRFS snapshot, and chezmoi status. |
| `rice list` | Lists all installed profiles in `~/.config/hypr/profiles/`. |
| `rice switch <profile>` | Atomically changes the active profile symlink to `<profile>`. |
| `rice save "<message>"` | Dumps package manifests, commits all tracked configs to chezmoi. |
| `rice snapshot "<desc>"` | Creates an atomic BTRFS root snapshot via Snapper (no sudo required once configured). |
| `rice restore [--profile name]`| **The Panic Button:** Wipes uncommitted changes, force-restores dotfiles from chezmoi, re-links profile. |
| `rice diff` | Shows differences between your live filesystem and the clean chezmoi state. |

---

## 📦 Installation

```bash
git clone https://github.com/RiosWesley/rice-cli.git
cd rice-cli
./install.sh
```

### Enable passwordless Snapper snapshots & Display Manager sessions:
```bash
sudo ./install/setup-system.sh
```

---

## ⚠️ Disclaimer
`rice-cli` is in **early-stage** alpha. Features are actively being designed around real-world ricing experiments. Contributions, issues, and ideas are welcome!

## 📜 License
MIT License.
