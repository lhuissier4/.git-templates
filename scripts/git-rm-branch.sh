#!/bin/bash
# Usage: git-rm-branch.sh <branche>
# Supprime une branche locale uniquement (jamais la distante).

BRANCH=$1

if [ -z "$BRANCH" ]; then
  echo "Usage: git rmb <nom-de-branche>" >&2
  exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Erreur : pas dans un dépôt git." >&2
  exit 1
fi

if ! git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "Erreur : la branche locale '$BRANCH' n'existe pas." >&2
  exit 1
fi

if [ "$(git symbolic-ref --short -q HEAD)" = "$BRANCH" ]; then
  echo "Erreur : impossible de supprimer la branche courante '$BRANCH'." >&2
  exit 1
fi

read -r -p "Supprimer la branche locale '$BRANCH' ? [Yn] " ANSWER
case "$ANSWER" in
  [nN]|[nN][oO]|[nN][oO][nN])
    echo "Annulé."
    exit 1
    ;;
esac

if git branch -d "$BRANCH"; then
  exit 0
fi

read -r -p "Forcer la suppression de '$BRANCH' (non fusionnée) ? [yN] " FORCE
case "$FORCE" in
  [yY]|[yY][eE][sS]|[oO]|[oO][uU][iI])
    git branch -D "$BRANCH"
    ;;
  *)
    echo "Annulé."
    exit 1
    ;;
esac
