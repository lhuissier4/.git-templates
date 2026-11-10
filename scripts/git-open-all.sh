#!/bin/bash

PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "Erreur : ce dossier ne fait pas partie d'un dépôt git." >&2
  exit 1
}
URL_FILE="$PROJECT_ROOT/.git-open-all"
GITIGNORE="$PROJECT_ROOT/.gitignore"

if [[ ! -e "$URL_FILE" ]]; then
  REPO_URL=$(bash "$(dirname "${BASH_SOURCE[0]}")/git-open.sh" --url)
  if [[ -z "$REPO_URL" ]]; then
    echo "Erreur : aucune URL trouvée pour le dépôt distant origin." >&2
    exit 1
  fi
  printf '%s\n' "$REPO_URL" > "$URL_FILE" || exit 1
fi

if [[ ! -f "$GITIGNORE" ]] || ! grep -qxE '/?\.git-open-all' "$GITIGNORE"; then
  printf '\n/.git-open-all\n' >> "$GITIGNORE" || exit 1
fi

while IFS= read -r URL || [[ -n "$URL" ]]; do
  [[ -z "$URL" ]] && continue
  echo "Ouverture : $URL"
  xdg-open "$URL" >/dev/null 2>&1
  sleep 0.5
done < "$URL_FILE"