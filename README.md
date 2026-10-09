# Installation

```bash
cd
git clone https://github.com/lhuissier4/.git-templates.git
git config --global init.templateDir "$HOME/.git-templates"
```

# Fonctionnement

Git copie `hooks/` dans le `.git/hooks` de chaque dépôt créé ou cloné. Les hooks `pre-commit` et `post-checkout` lancent `scripts/setup.sh`, qui configure le projet sans jamais écraser un fichier existant :

- `git-hooks/` (`commit-msg`, `pre-push`) et `core.hooksPath`
- les instructions de commit pour Copilot (`.github/` et `.vscode/settings.json`)
- `kilo.jsonc`

# Structure

```txt
hooks/     hooks Git copiés par le template (appellent scripts/setup.sh)
scripts/   setup.sh (point d'entrée) et lib/ (une fonction par fonctionnalité)
assets/    fichiers copiés dans les projets cibles
docs/      documentation annexe
```

# Documentation

- [Alias `git open`](docs/open-alias.md)
