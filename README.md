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
# Initialisation des hooks Git
Pour initialiser les hooks, exécutez la commande suivante :
```bash
git config core.hooksPath "git-hooks"
```
