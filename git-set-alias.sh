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

remove_all_aliases

create_alias sw ${GIT_TEMPLATES}/scripts/git-switch-branch.sh
create_alias co checkout
create_alias br branch
create_alias ci 'commit -m'
create_alias cia 'commit --amend -m'
create_alias cial ${GIT_TEMPLATES}/scripts/git-commit-amend-last-msg.sh
create_alias st status
create_alias open ${GIT_TEMPLATES}/scripts/git-open.sh
create_alias last '!git --no-pager log -1 HEAD'
create_alias lasts ${GIT_TEMPLATES}/scripts/git-lasts-commit.sh
create_alias hooks ${GIT_TEMPLATES}/scripts/git-hooks.sh
create_alias autoci ${GIT_TEMPLATES}/scripts/auto-commit.sh
create_alias kilo ${GIT_TEMPLATES}/scripts/git-kilo.sh
create_alias print-all-aliases '!git --no-pager config --get-regexp '^alias\.''

# git skills