#!/usr/bin/env bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "Erro: Execute este script com sudo ou como root."
    exit 1
fi

TARGET_USER="${SUDO_USER:-$(logname 2>/dev/null || echo "$USER")}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Configurando permissões de sistema para o usuário $TARGET_USER ==="

# 1. Configurar Snapper root config se existir
if [ -f /etc/snapper/configs/root ]; then
    echo "[+] Ajustando /etc/snapper/configs/root..."
    sed -i "s/^ALLOW_USERS=.*/ALLOW_USERS=\"$TARGET_USER\"/" /etc/snapper/configs/root
    sed -i 's/^ALLOW_GROUPS=.*/ALLOW_GROUPS="wheel"/' /etc/snapper/configs/root
    sed -i 's/^SYNC_ACL=.*/SYNC_ACL="yes"/' /etc/snapper/configs/root
    chmod a+rx /.snapshots 2>/dev/null || true
    chmod 750 /etc/snapper/configs/root
    echo "[✓] Snapper configurado para '$TARGET_USER' e grupo 'wheel'."
fi

# 2. Registrar sessões Wayland se templates existirem
mkdir -p /usr/local/bin /usr/share/wayland-sessions

for profile_script in "$TARGET_HOME"/.local/bin/hypr-*; do
    if [ -f "$profile_script" ]; then
        name="$(basename "$profile_script")"
        cp -f "$profile_script" "/usr/local/bin/$name"
        chmod +x "/usr/local/bin/$name"
        echo "[✓] Copiado wrapper de sessão para /usr/local/bin/$name"
    fi
done

for desktop_file in "$TARGET_HOME"/.local/share/wayland-sessions/*.desktop; do
    if [ -f "$desktop_file" ]; then
        name="$(basename "$desktop_file")"
        cp -f "$desktop_file" "/usr/share/wayland-sessions/$name"
        chmod 644 "/usr/share/wayland-sessions/$name"
        echo "[✓] Registrada sessão Wayland /usr/share/wayland-sessions/$name"
    fi
done

echo "=== Concluído com sucesso ==="
