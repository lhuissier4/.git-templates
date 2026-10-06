# Installation

Pour installer et configurer le template global : 

```bash
cd
git clone https://github.com/lhuissier4/.git-templates.git
git config --global init.templateDir "$HOME/.git-templates"
```

# Créer l'alias open

Pour créer l'alias `git open` qui permet d'ouvrir la page du repo distant, executez la commande suivante : 
```bash
git config --global alias.open '!f() {
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
    xdg-open "$HTTPS_GITLAB_URL"
}; f'

echo "configuration réussie !"
```
Cette configuration à été testée avec 4 type d'url : 
```txt
SSH avec port et préfixe .git : ssh://git@gitlab.example.com:2222/group/repo.git → https://gitlab.example.com/group/repo

SSH au format SCP : git@gitlab.example.com:group/repo.git → https://gitlab.example.com/group/repo

HTTPS avec .git : https://gitlab.example.com/group/repo.git → https://gitlab.example.com/group/repo

HTTPS sans .git : https://gitlab.example.com/group/repo → https://gitlab.example.com/group/repo
```