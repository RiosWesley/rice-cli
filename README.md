<div align="center">

# 🍚 rice-cli

### **Declarative Desktop Orchestrator & Sandboxed Installer for Arch Linux / CachyOS**
*Hyprland Profiles • Bubblewrap Sandboxing • BTRFS Root Snapshots (Snapper) • Declarative Dotfiles (chezmoi)*

<p align="center">
  <img src="https://img.shields.io/badge/status-early--stage%20%2F%20unstable-orange?style=for-the-badge" alt="Status" />
  <img src="https://img.shields.io/badge/target-Hyprland-blue?style=for-the-badge&logo=hyprland" alt="Hyprland" />
  <img src="https://img.shields.io/badge/sandbox-Bubblewrap-purple?style=for-the-badge" alt="Bubblewrap" />
  <img src="https://img.shields.io/badge/recovery-Snapper%20%2B%20BTRFS-red?style=for-the-badge" alt="Snapper" />
  <img src="https://img.shields.io/badge/dotfiles-chezmoi-green?style=for-the-badge" alt="chezmoi" />
</p>

</div>

> ⚠️ **EARLY-STAGE & EXPERIMENTAL**  
> `rice-cli` is under active development. While it provides strong sandboxing and two-tier rollback mechanisms, always keep a live USB handy when working with system-level kernel or BTRFS rollbacks.

---

## 💡 The Problem: Why does testing Rices destroy your system?

Whenever you find a cool desktop setup on GitHub (e.g. CyberArch, End4, Hyprcraft) and run `./install.sh`:
1. **The installer destroys your user config:** It forcibly overwrites `~/.config/hypr/hyprland.lua` or `hyprland.conf`, replaces your `kitty.conf`, and kills your personal window rules.
2. **The installer pollutes the root system (`/`):** It runs `sudo pacman -S`, replaces `/etc/sddm.conf` (breaking your login screen), and injects global hooks.
3. **Rollback is practically impossible:** You end up in emergency mode or spending hours manually untangling packages and config files.

---

## 🛡️ The Architecture: Two-Tier Virtualization & Rollback

`rice-cli` solves this with a **container-like workflow** for desktop ricing:

```text
┌─────────────────────────────────────────────────────────────┐
│  You run: rice wrap --name cyberarch ./install.sh           │
└──────────────────────────────┬──────────────────────────────┘
                               │
       ┌───────────────────────▼───────────────────────┐
       │ 1. AUTOMATIC SNAPPER BASELINE                 │
       │    Creates root snapshot #N before execution  │
       └───────────────────────┬───────────────────────┘
                               │
       ┌───────────────────────▼───────────────────────┐
       │ 2. BUBBLEWRAP SANDBOX REDIRECTION             │
       │    - ~/.config/hypr is bind-mounted to        │
       │      ~/.config/hypr/profiles/cyberarch/       │
       │    - The foreign installer thinks it's        │
       │      installing to root Hyprland!             │
       └───────────────────────┬───────────────────────┘
                               │
       ┌───────────────────────▼───────────────────────┐
       │ 3. ATOMIC REGISTRATION                        │
       │    - Auto-generates /usr/local/bin/hypr-NAME  │
       │    - Registers Display Manager session entry  │
       │    - Saves clean state metadata               │
       └───────────────────────────────────────────────┘
```

---

## 🚀 The Core Commands

### 1. `rice wrap` (The Sandboxed Installer)
Never run untrusted or invasive rice scripts directly in your live environment again. `rice wrap` intercepts filesystem operations and pins a baseline snapshot:
```bash
git clone https://github.com/someone/invasive-rice.git /tmp/rice
cd /tmp/rice
rice wrap --name coolrice ./install.sh
```
* The script's changes to `~/.config/hypr` are transparently jailed into `~/.config/hypr/profiles/coolrice/`.
* Your active desktop and dotfiles remain untouched.
* A dedicated session entry is generated for your Display Manager (SDDM/GDM).

---

### 2. `rice restore` (The Unified Panic Button)
Did something break? Don't panic. A single command reverts both user dotfiles AND the root system snapshot:
```bash
rice restore
```
What `rice restore` does automatically:
1. **Reverts Root Filesystem (BTRFS):** Calls `snapper -c root undochange <ID>..0` to purge foreign packages, modified PAM rules, and `/etc` pollution.
2. **Restores SDDM Login Theme:** Sets `/etc/sddm.conf` back to clean default (`breeze`).
3. **Restores User Dotfiles:** Runs `chezmoi apply --force` to bring back your clean keybinds, glass effects, and terminals.
4. **Re-links Active Profile:** Restores the symlink to your default profile (`end4`).
5. **Live Reloads Hyprland:** Sends reload signal to compositor.

---

### 3. `rice switch` (Zero-Risk Profile Switching)
Switch between completely independent desktops without restarting or losing hardware configs:
```bash
rice switch cyberarch
rice switch end4
rice switch vanilla
```

---

## 🛠️ Complete Command Reference

| Command | Description |
| :--- | :--- |
| `rice status` | Shows active profile, total package count, latest BTRFS snapshot, and git status. |
| `rice list` | Lists all installed desktop profiles. |
| `rice switch <profile>` | Atomically changes the active Hyprland profile symlink. |
| `rice wrap --name <name> <cmd>`| Runs an external rice installer inside a protected Bubblewrap sandbox. |
| `rice restore` | **The Master Panic Button:** Full two-tier rollback of BTRFS system + chezmoi dotfiles. |
| `rice save "<msg>"` | Dumps package manifests and commits current configuration to chezmoi. |
| `rice snapshot "<desc>"` | Creates an atomic BTRFS root snapshot with Snapper and pins it as clean state. |
| `rice diff` | Shows differences between your live filesystem and clean chezmoi state. |

---

## 📜 License
MIT License. Created by Wesley Rios.
