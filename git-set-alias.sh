#!/bin/bash
GIT_TEMPLATES="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
    exit 1
}

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci 'commit -m'
git config --global alias.cia 'commit --amend -m'
git config --global alias.st status

# TODO: ajouter les autres alias
chmod a+x "${GIT_TEMPLATES}/scripts/git-open.sh"
chmod a+x "${GIT_TEMPLATES}/scripts/git-switch-branch.sh"
chmod a+x "${GIT_TEMPLATES}/scripts/git-hooks.sh"
chmod a+x "${GIT_TEMPLATES}/scripts/auto-commit.sh"

git config --global alias.open "!bash ${GIT_TEMPLATES}/scripts/git-open.sh"
git config --global alias.sw "!bash ${GIT_TEMPLATES}/scripts/git-switch-branch.sh"
git config --global alias.hooks "!bash ${GIT_TEMPLATES}/scripts/git-hooks.sh"

# git skills

# configuration des commits automatiques
git config --global alias.autoci "!bash ${GIT_TEMPLATES}/scripts/auto-commit.sh"
