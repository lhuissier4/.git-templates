#!/usr/bin/env bash
# Installe commit-msg et pre-push dans le projet et active core.hooksPath.

setup_git_hooks() {
    local hook
    for hook in commit-msg pre-push; do
        copy_if_missing "$ASSETS_DIR/git-hooks/$hook" "$HOOKS_DIR_NAME/$hook"
    done
    git config core.hooksPath "$HOOKS_DIR_NAME"
    chmod a+x "$HOOKS_DIR_NAME"/* 2>/dev/null || true
    echo "Hooks Git configurés : core.hooksPath = $HOOKS_DIR_NAME"

    append_readme_section "Initialisation des hooks Git" \
"Pour initialiser les hooks, executez la commande suivante :
\`\`\`bash
git config core.hooksPath \"$HOOKS_DIR_NAME\"
\`\`\`"
}
