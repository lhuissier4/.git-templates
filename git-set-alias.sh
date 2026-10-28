#!/bin/bash
GIT_TEMPLATES="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
    exit 1
}

# create_alias <alias> <commande> [is_file]
# is_file=true : <commande> est un script relatif à GIT_TEMPLATES, rendu exécutable puis lancé avec bash.
create_alias() {
    local alias_name="$1"
    local command="$2"
    local is_bash_file="${3:-false}"
    
    if [[ "$is_bash_file" == "true" ]]; then
        chmod a+x "${GIT_TEMPLATES}/${command}"
        git config --global "alias.${alias_name}" "!bash ${command}"
    else
        git config --global "alias.${alias_name}" "${command}"
    fi
}

create_alias sw ${GIT_TEMPLATES}/scripts/git-switch-branch.sh true
create_alias co checkout false
create_alias br branch false
create_alias ci 'commit -m' false
create_alias cia 'commit --amend -m' false
create_alias cial ${GIT_TEMPLATES}/scripts/git-commit-amend-last-msg.sh true
create_alias st status false
create_alias open ${GIT_TEMPLATES}/scripts/git-open.sh true
create_alias last '!git --no-pager log -1 HEAD' false
create_alias lasts ${GIT_TEMPLATES}/scripts/git-lasts-commit.sh true
create_alias hooks ${GIT_TEMPLATES}/scripts/git-hooks.sh true
create_alias autoci ${GIT_TEMPLATES}/scripts/auto-commit.sh true
create_alias kilo ${GIT_TEMPLATES}/scripts/git-kilo.sh true



# git skills