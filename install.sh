#!/usr/bin/env bash
set -euo pipefail

R=$'\033[0m'; B=$'\033[1m'; GRN=$'\033[38;2;90;230;130m'; CYAN=$'\033[38;2;119;226;242m'; YEL=$'\033[38;2;255;214;31m'
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "${CYAN}${B}=== Instalador do rice-cli (Hyprland + chezmoi + Snapper) ===${R}"

# 1. Instalar binário rice em ~/.local/bin
mkdir -p "$HOME/.local/bin"
cp -f "$REPO_ROOT/bin/rice" "$HOME/.local/bin/rice"
chmod +x "$HOME/.local/bin/rice"
echo "${GRN}✓${R} CLI 'rice' instalada em ~/.local/bin/rice"

# 2. Assegurar chezmoi instalado
if ! command -v chezmoi >/dev/null 2>&1; then
    if [ ! -f "$HOME/.local/bin/chezmoi" ]; then
        echo "${CYAN}▸${R} Instalando chezmoi..."
        curl -fsSL https://get.chezmoi.io | sh -s -- -b "$HOME/.local/bin"
    fi
fi
echo "${GRN}✓${R} chezmoi disponível"

# 3. Inicializar repositório chezmoi se não existir
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
    echo "${CYAN}▸${R} Inicializando chezmoi..."
    "$HOME/.local/bin/chezmoi" init
    echo "${GRN}✓${R} chezmoi inicializado"
fi

# 4. Criar estrutura de diretórios hyprland
mkdir -p "$HOME/.config/hypr/shared" "$HOME/.config/hypr/profiles"

# 5. Executar script administrativo opcional para snapper e wayland-sessions
echo ""
echo "${YEL}${B}[Ação Administrativa Opcional]${R}"
echo "Para habilitar snapshots do Snapper sem sudo e registrar as sessões no Display Manager (SDDM/GDM/Plasma Login):"
echo "Execute: ${B}sudo bash $REPO_ROOT/install/setup-system.sh${R}"
echo ""
echo "${GRN}${B}Instalação de usuário concluída! Use 'rice status' ou 'rice list'.${R}"
