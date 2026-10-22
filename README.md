# Installation

Pour installer et configurer le template global : 

```bash
cd
git clone https://github.com/lhuissier4/.git-templates.git
git config --global init.templateDir "$HOME/.git-templates"
```

Pour créer les alias git, exécutez le fichier suivant :
```bash
cd "$HOME/.git-templates"
./git-set-alias.sh
```

# Alias Git

## Alias simples

| Alias | Commande | Description |
|-------|----------|-------------|
| `git co` | `checkout` | Change de branche ou restaure des fichiers |
| `git br` | `branch` | Liste / gère les branches |
| `git ci "msg"` | `commit -m` | Crée un commit avec le message donné |
| `git cia "msg"` | `commit --amend -m` | Modifie le dernier commit avec un nouveau message |
| `git st` | `status` | Affiche l'état du dépôt |
| `git last` | `log -1 HEAD` | Affiche le dernier commit |

## Alias basés sur des scripts

| Alias | Script | Description |
|-------|--------|-------------|
| `git open` | `scripts/git-open.sh` | Ouvre le dépôt distant (`origin`) dans le navigateur. Convertit les URL SSH en URL HTTPS. |
| `git sw <branche>` | `scripts/git-switch-branch.sh` | Bascule sur la branche : locale si elle existe, sinon la récupère depuis `origin`, sinon propose de la créer. |
| `git hooks` | `scripts/git-hooks.sh` | À lancer à la racine d'un projet : crée le dossier `git-hooks`, y copie `commit-msg` et `pre-push`, configure `core.hooksPath` et ajoute la section correspondante au README du projet. |
| `git autoci` | `scripts/auto-commit.sh` | Configure la génération automatique des messages de commit : copie `.github/git-commit-instructions.md` et déclare l'instruction Copilot dans `.vscode/settings.json` (nécessite `jq`). |
| `git kilo` | `scripts/git-kilo.sh` | Copie `kilo.jsonc` à la racine du projet et ajoute une section « Configuration Kilo » au README. |
| `git cial` | `scripts/git-commit-amend-last-msg.sh` | Refait un `commit --amend` en réutilisant le message du dernier commit (utile pour inclure des fichiers indexés sans retaper le message). Les options supplémentaires sont transmises à `git commit`. |
# Initialisation des hooks Git
Pour initialiser les hooks, exécutez la commande suivante :
```bash
git config core.hooksPath "git-hooks"
```
