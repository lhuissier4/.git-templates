#!/bin/bash
# Usage: git-hooks.sh
# Utilise le dossier courant s'il s'appelle git-hooks, sinon le crée (uniquement
# à la racine d'un projet git), puis y copie commit-msg et pre-push.

TEMPLATES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
# Un alias git "!" s'exécute à la racine du dépôt : on revient là où l'utilisateur se trouvait.
[ -n "$GIT_PREFIX" ] && cd "$GIT_PREFIX"
CURRENT_DIR=$(pwd -P)

if [ "$(basename "$CURRENT_DIR")" = "git-hooks" ]; then
  TARGET_DIR=$CURRENT_DIR
else
  GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -z "$GIT_ROOT" ] || [ "$GIT_ROOT" != "$CURRENT_DIR" ]; then
    echo "Erreur : le dossier git-hooks doit être créé à la racine d'un projet git." >&2
    exit 1
  fi
  TARGET_DIR="$CURRENT_DIR/git-hooks"
  mkdir -p "$TARGET_DIR" || exit 1
  echo "Dossier créé : $TARGET_DIR"
fi

for hook in hooks/commit-msg config/pre-push; do
  name=$(basename "$hook")
  if ! cp "$TEMPLATES_DIR/$hook" "$TARGET_DIR/$name"; then
    echo "Erreur : impossible de copier $name." >&2
    exit 1
  fi
  chmod +x "$TARGET_DIR/$name"
  echo "Importé : $TARGET_DIR/$name"
done

GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
  exit 1
}
# Chemin du dossier de hooks relatif à la racine du projet
GIT_HOOKS_FOLDER=${TARGET_DIR#"$GIT_ROOT"/}
README="$GIT_ROOT/README.md"

if ! grep -q "^# Initialisation des hooks Git$" "$README" 2>/dev/null; then
  cat >> "$README" <<EOF

# Initialisation des hooks Git
Pour initialiser les hooks, exécutez la commande suivante :
\`\`\`bash
git config core.hooksPath "$GIT_HOOKS_FOLDER"
\`\`\`
EOF
  echo "Section ajoutée dans README.md : Initialisation des hooks Git"
fi

git config core.hooksPath "$GIT_HOOKS_FOLDER" && echo "core.hooksPath configuré : $GIT_HOOKS_FOLDER"
