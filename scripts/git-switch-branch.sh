#!/bin/bash
# Usage: git-switch-branch.sh <branche>
# Bascule sur la branche (locale, sinon distante, sinon propose de la créer).

BRANCH=$1
REMOTE=origin

if [ -z "$BRANCH" ]; then
  echo "Usage: git sw <nom-de-branche>" >&2
  exit 1
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Erreur : pas dans un dépôt git." >&2
  exit 1
fi

if ! git check-ref-format --branch "$BRANCH" >/dev/null 2>&1; then
  echo "Erreur : nom de branche invalide : $BRANCH" >&2
  exit 1
fi

# 1. Branche locale
if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  echo "La branche locale '$BRANCH' existe."
  git switch "$BRANCH"
  exit $?
fi

# 2. Dépôt distant déclaré ?
if git remote | grep -qx "$REMOTE"; then
  echo "Branche locale absente, vérification sur '$REMOTE'..."
  if git ls-remote --exit-code --heads "$REMOTE" "$BRANCH" >/dev/null 2>&1; then
    echo "La branche '$BRANCH' existe sur '$REMOTE', récupération..."
    git fetch "$REMOTE" "$BRANCH" && git switch --track -c "$BRANCH" "$REMOTE/$BRANCH"
    exit $?
  fi
  echo "La branche '$BRANCH' n'existe pas sur '$REMOTE'."
else
  echo "Aucun dépôt distant '$REMOTE' déclaré."
fi

# 3. Création locale
read -r -p "Créer la branche locale '$BRANCH' ? [yN] " ANSWER
case "$ANSWER" in
  [yY]|[yY][eE][sS]|[oO]|[oO][uU][iI])
    git switch -c "$BRANCH"
    ;;
  *)
    echo "Annulé."
    exit 1
    ;;
esac
