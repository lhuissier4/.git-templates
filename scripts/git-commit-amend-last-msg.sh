#!/bin/bash
MSG="$(git log -1 --pretty=%B 2>/dev/null)" || {
    echo "Erreur : aucun commit trouvé." >&2
    exit 1
}

git commit --amend -m "${MSG%$'\n'}" "$@"
