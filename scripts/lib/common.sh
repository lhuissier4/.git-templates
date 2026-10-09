#!/usr/bin/env bash
# Fonctions partagées par les scripts d'installation.

TEMPLATE_DIR="${GIT_TEMPLATE_DIR:-$HOME/.git-templates}"
ASSETS_DIR="$TEMPLATE_DIR/assets"
HOOKS_DIR_NAME="git-hooks"

# copy_if_missing <source> <destination> : copie sans jamais écraser.
copy_if_missing() {
    local src="$1" dest="$2"
    [[ -f "$dest" ]] && return 0
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "Fichier créé : $dest"
}

# append_readme_section <titre> <contenu> : ajoute une section au README si absente.
append_readme_section() {
    local title="$1" body="$2"
    grep -qxF "# $title" README.md 2>/dev/null && return 0
    printf '# %s\n%s\n' "$title" "$body" >> README.md
    echo "Section ajoutée dans README.md : $title"
}
