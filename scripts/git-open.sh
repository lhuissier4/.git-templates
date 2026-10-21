#!/bin/bash
GITLAB_REPO_URL=$(git config --get remote.origin.url)
case "$GITLAB_REPO_URL" in
  ssh://*)
    SSH_REMOTE=${GITLAB_REPO_URL#ssh://}
    SSH_AUTHORITY=${SSH_REMOTE%%/*}
    SSH_PATH=${SSH_REMOTE#*/}
    SSH_HOST=${SSH_AUTHORITY##*@}
    SSH_HOST=${SSH_HOST%%:*}
    HTTPS_GITLAB_URL="https://$SSH_HOST/$SSH_PATH"
    ;;
  *@*:*)
    SSH_REMOTE=${GITLAB_REPO_URL#*@}
    SSH_HOST=${SSH_REMOTE%%:*}
    SSH_PATH=${SSH_REMOTE#*:}
    HTTPS_GITLAB_URL="https://$SSH_HOST/$SSH_PATH"
    ;;
  *)
    HTTPS_GITLAB_URL=$GITLAB_REPO_URL
    ;;
esac
HTTPS_GITLAB_URL=${HTTPS_GITLAB_URL%.git}
echo "Ouverture du repo git : $HTTPS_GITLAB_URL"
xdg-open "$HTTPS_GITLAB_URL" >/dev/null 2>&1