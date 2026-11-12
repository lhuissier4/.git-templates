#!/usr/bin/env bash
# Usage: git autoci [ignore]
# Configure la génération automatique des messages de commit dans le projet
# courant : instructions Copilot et settings VS Code. `ignore` ajoute ces fichiers
# au .gitignore du projet.

set -euo pipefail
GIT_TEMPLATES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
    exit 1
}
cd "$PROJECT_ROOT"

GITHUB_DIR=".github"
COMMIT_INSTRUCTIONS_FILE="$GITHUB_DIR/git-commit-instructions.md"
VSCODE_DIR=".vscode"
VSCODE_SETTINGS_FILE="$VSCODE_DIR/settings.json"
COPILOT_MAGIC_COMMIT_KEY="github.copilot.chat.commitMessageGeneration.instructions"
GITIGNORE_FILE=".gitignore"
GENERATED_FILES=("$COMMIT_INSTRUCTIONS_FILE" "$VSCODE_SETTINGS_FILE")

if (( $# > 0 )) && { (( $# != 1 )) || [[ "$1" != "ignore" ]]; }; then
    echo "Usage : git autoci [ignore]" >&2
    exit 2
fi

if [[ ! -f "$COMMIT_INSTRUCTIONS_FILE" ]]; then
    mkdir -p "$GITHUB_DIR"
    cp "$GIT_TEMPLATES/config_files/git-commit-instructions.md" "$COMMIT_INSTRUCTIONS_FILE"
    echo "Fichier créé : $COMMIT_INSTRUCTIONS_FILE"
fi

if [[ ! -f "$VSCODE_SETTINGS_FILE" ]]; then
    mkdir -p "$VSCODE_DIR"
    cat > "$VSCODE_SETTINGS_FILE" <<EOF
{
    "$COPILOT_MAGIC_COMMIT_KEY": [
        {
        "file": "$COMMIT_INSTRUCTIONS_FILE"
        }
    ]
}
EOF
    echo "Fichier créé : $VSCODE_SETTINGS_FILE"
elif ! jq -e --arg key "$COPILOT_MAGIC_COMMIT_KEY" 'has($key)' "$VSCODE_SETTINGS_FILE" >/dev/null 2>&1; then
    TMP_SETTINGS="$(mktemp)"
    jq --arg key "$COPILOT_MAGIC_COMMIT_KEY" --arg file "$COMMIT_INSTRUCTIONS_FILE" \
        '.[$key] = [{"file": $file}]' \
        "$VSCODE_SETTINGS_FILE" > "$TMP_SETTINGS"
    mv "$TMP_SETTINGS" "$VSCODE_SETTINGS_FILE"
    echo "Clé ajoutée dans $VSCODE_SETTINGS_FILE : $COPILOT_MAGIC_COMMIT_KEY"
fi

echo "Commits automatiques configurés."

if [[ "${1:-}" == "ignore" ]]; then
    for file in "${GENERATED_FILES[@]}"; do
        if ! grep -Fxq -- "$file" "$GITIGNORE_FILE" 2>/dev/null; then
            if [[ -s "$GITIGNORE_FILE" && -n "$(tail -c 1 "$GITIGNORE_FILE")" ]]; then
                printf '\n' >> "$GITIGNORE_FILE"
            fi
            printf '%s\n' "$file" >> "$GITIGNORE_FILE"
            echo "Ajouté dans $GITIGNORE_FILE : $file"
        fi
    done
fi
