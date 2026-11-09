#!/bin/bash
GIT_TEMPLATES="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
    exit 1
}

# create_alias <alias> <commande>
# Si <commande> se termine par .sh, c'est un chemin de script : rendu exécutable puis lancé avec bash.
create_alias() {
    local alias_name="$1"
    local command="$2"

    if [[ "$command" == *.sh ]]; then
        chmod a+x "${command}"
        git config --global "alias.${alias_name}" "!bash ${command}"
    else
        git config --global "alias.${alias_name}" "${command}"
    fi
}

# Supprime tous les alias du git config global.
remove_all_aliases() {
    local key
    while IFS= read -r key; do
        git config --global --unset-all "$key"
    done < <(git config --global --name-only --get-regexp '^alias\.')
}

# add_source_line <fichier rc> <script> : ajoute `source <script>` s'il n'y est pas déjà.
add_source_line() {
    local rc_file="$1"
    local script="$2"

    if [[ ! -f "$rc_file" ]]; then
        echo "Ignoré : $rc_file n'existe pas."
        return
    fi
    if grep -qF "source ${script}" "$rc_file"; then
        return
    fi
    printf '\n# Autocomplétion des branches pour git sw\nsource %s\n' "$script" >> "$rc_file"
    echo "Ajouté dans $rc_file : source ${script}"
}

remove_all_aliases

# En fin de fichier, donc après compinit dans le .zshrc.
add_source_line "${HOME}/.bashrc" "${GIT_TEMPLATES}/scripts/git-auto-complet.sh"
add_source_line "${HOME}/.zshrc" "${GIT_TEMPLATES}/scripts/git-auto-complet.sh"

create_alias sw ${GIT_TEMPLATES}/scripts/git-switch-branch.sh
chmod a+x "${GIT_TEMPLATES}/scripts/git-auto-complet.sh"

create_alias rmb ${GIT_TEMPLATES}/scripts/git-rm-branch.sh
create_alias co checkout
create_alias br ${GIT_TEMPLATES}/scripts/print-all-branch.sh
create_alias ci 'commit -m'
create_alias cia 'commit --amend -m'
create_alias cial ${GIT_TEMPLATES}/scripts/git-commit-amend-last-msg.sh
create_alias st status
create_alias save '!f() { git stash push --staged -m "$1" && git stash apply --index; }; f'
create_alias open ${GIT_TEMPLATES}/scripts/git-open.sh
create_alias last '!git --no-pager log -1 HEAD'
create_alias lasts ${GIT_TEMPLATES}/scripts/git-lasts-commit.sh
create_alias hooks ${GIT_TEMPLATES}/scripts/git-hooks.sh
create_alias autoci ${GIT_TEMPLATES}/scripts/auto-commit.sh
create_alias kilo ${GIT_TEMPLATES}/scripts/git-kilo.sh
create_alias print-all-aliases '!git --no-pager config --get-regexp '^alias\.''

# git skills