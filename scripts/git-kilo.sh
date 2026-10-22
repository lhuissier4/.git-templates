#!/bin/bash
# Usage: git-kilo.sh
# Copie la configuration kilo.jsonc à la racine du projet git courant
# et documente la configuration dans le README.md.

TEMPLATES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
  exit 1
}

KILO_FILE="$GIT_ROOT/kilo.jsonc"
README="$GIT_ROOT/README.md"

if [ ! -f "$KILO_FILE" ]; then
  if ! cp "$TEMPLATES_DIR/config/kilo.jsonc" "$KILO_FILE"; then
    echo "Erreur : impossible de copier kilo.jsonc." >&2
    exit 1
  fi
  echo "Fichier kilo.jsonc copié"
else
  echo "kilo.jsonc existe déjà : $KILO_FILE"
fi

if ! grep -q "^# Configuration Kilo$" "$README" 2>/dev/null; then
  cat >> "$README" <<EOF

# Configuration Kilo
Le fichier \`kilo.jsonc\` est automatiquement copié dans le projet pour configurer Kilo.
Pour voir la configuration actuelle, exécutez :
\`\`\`bash
cat kilo.jsonc
\`\`\`
EOF
  echo "Section ajoutée dans README.md : Configuration Kilo"
fi
