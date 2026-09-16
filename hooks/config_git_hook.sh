#!/usr/bin/env bash

set -euo pipefail
GIT_HOOKS_FOLDER="git-hooks"
GIT_GLOBAL_TEMPLATE="$HOME/.git-templates"

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
    exit 1
}

if [[ "$(pwd -P)" != "$PROJECT_ROOT" ]]; then
    echo "Déplacement vers la racine du projet : $PROJECT_ROOT"
    cd "$PROJECT_ROOT"
fi

if [[ ! -f "$GIT_HOOKS_FOLDER/commit-msg" ]]; then
    mkdir -p "$GIT_HOOKS_FOLDER"
    cp "$GIT_GLOBAL_TEMPLATE/commit-msg" "$GIT_HOOKS_FOLDER/commit-msg"
fi
git config core.hooksPath "$GIT_HOOKS_FOLDER"
echo "Hooks Git configurés : core.hooksPath = $GIT_HOOKS_FOLDER"

GITHUB_DIR=".github"
COMMIT_INSTRUCTIONS_FILE="$GITHUB_DIR/git-commit-instructions.md"
VSCODE_DIR=".vscode"
VSCODE_SETTINGS_FILE="$VSCODE_DIR/settings.json"
COPILOT_MAGIC_COMMIT_KEY="github.copilot.chat.commitMessageGeneration.instructions"

if [[ ! -f "$COMMIT_INSTRUCTIONS_FILE" ]]; then
    mkdir -p "$GITHUB_DIR"
    cp "$GIT_GLOBAL_TEMPLATE/git-commit-instructions.md" "$COMMIT_INSTRUCTIONS_FILE"
    echo "Fichier créé : $COMMIT_INSTRUCTIONS_FILE"
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "Erreur : jq est requis pour configurer $VSCODE_SETTINGS_FILE." >&2
    exit 1
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