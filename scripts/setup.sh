#!/usr/bin/env bash
# Point d'entrée : configure le dépôt courant (hooks, Copilot, Kilo).
# Appelé par les hooks Git de hooks/ (pre-commit, post-checkout).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/hooks.sh"
source "$SCRIPT_DIR/lib/copilot.sh"
source "$SCRIPT_DIR/lib/kilo.sh"

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
    exit 1
}
cd "$PROJECT_ROOT"

setup_git_hooks
setup_copilot
setup_kilo
