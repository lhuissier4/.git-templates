#!/usr/bin/env bash
# Configure la génération de messages de commit de Copilot dans VS Code.

COMMIT_INSTRUCTIONS_FILE=".github/git-commit-instructions.md"
VSCODE_SETTINGS_FILE=".vscode/settings.json"
COPILOT_KEY="github.copilot.chat.commitMessageGeneration.instructions"

setup_copilot() {
    copy_if_missing "$ASSETS_DIR/git-commit-instructions.md" "$COMMIT_INSTRUCTIONS_FILE"

    if [[ ! -f "$VSCODE_SETTINGS_FILE" ]]; then
        mkdir -p "$(dirname "$VSCODE_SETTINGS_FILE")"
        echo '{}' > "$VSCODE_SETTINGS_FILE"
    fi

    if jq -e --arg key "$COPILOT_KEY" 'has($key)' "$VSCODE_SETTINGS_FILE" >/dev/null 2>&1; then
        return 0
    fi

    local tmp
    tmp="$(mktemp)"
    jq --arg key "$COPILOT_KEY" --arg file "$COMMIT_INSTRUCTIONS_FILE" \
        '.[$key] = [{"file": $file}]' "$VSCODE_SETTINGS_FILE" > "$tmp"
    mv "$tmp" "$VSCODE_SETTINGS_FILE"
    echo "Clé ajoutée dans $VSCODE_SETTINGS_FILE : $COPILOT_KEY"
}
