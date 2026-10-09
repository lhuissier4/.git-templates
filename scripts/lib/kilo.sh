#!/usr/bin/env bash
# Copie la configuration Kilo dans le projet.

setup_kilo() {
    copy_if_missing "$ASSETS_DIR/kilo.jsonc" "kilo.jsonc"

    append_readme_section "Configuration Kilo" \
"Le fichier \`kilo.jsonc\` est automatiquement copié dans le projet pour configurer Kilo.
Pour voir la configuration actuelle, exécutez :
\`\`\`bash
cat kilo.jsonc
\`\`\`"
}
