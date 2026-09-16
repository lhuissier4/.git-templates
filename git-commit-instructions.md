# Commit Message Instructions

Avoid overly verbose descriptions or unnecessary details.

## Language

- Use French for the commit message.
- Keep only the commit type in English.
- The commit message must follow this format:

  `<type>(<scope>): <description>`

- The scope is optional.

## Verb Conjugation

Conjugate the verb as if the sentence started with:

> Ce commit ...

Examples:

- `feat: ajoute l'authentification des utilisateurs`
- `fix(api): corrige le bug des jetons expirés`
- `docs: met à jour la documentation`
- `refactor: simplifie la gestion des utilisateurs`

Do not use the infinitive form.

Prefer:

- `ajoute`
- `corrige`
- `modifie`
- `supprime`
- `améliore`
- `met à jour`

Instead of:

- `ajouter`
- `corriger`
- `modifier`
- `supprimer`
- `améliorer`
- `mettre à jour`

## Semantic Release

Use Semantic Versioning rules when choosing the commit type.

Examples:

- `feat!: publie un changement incompatible`  
  → major release

- `feat: ajoute l'authentification des utilisateurs`  
  → minor release

- `fix(api): corrige le bug des jetons expirés`  
  → patch release

A breaking change must use `!`:

`<type>(<scope>)!: <description>`

or:

`<type>!: <description>`

## Angular Commit Types

Only use the following Angular Conventional Commit types:

| Type | Usage |
|---|---|
| `build` | Système de build ou dépendances externes, comme npm ou Docker |
| `chore` | Tâche de maintenance sans impact sur le code ou les tests |
| `ci` | Configuration ou scripts d'intégration continue |
| `docs` | Documentation uniquement |
| `feat` | Nouvelle fonctionnalité |
| `fix` | Correction de bug |
| `perf` | Amélioration de performance |
| `refactor` | Restructuration du code sans changement de comportement |
| `revert` | Annulation d'un commit précédent |
| `style` | Formatage sans impact sur la logique |
| `test` | Ajout ou modification de tests |

## Release Impact

The following types affect the Semantic Version:

- `feat!` or any commit containing a breaking change → major release
- `feat` → minor release
- `fix` → patch release
- `perf` → patch release

The following types normally do not trigger a version change:

- `build`
- `chore`
- `ci`
- `docs`
- `refactor`
- `revert`
- `style`
- `test`

## Style

- Keep the message concise.
- Avoid unnecessary explanations.
- Do not add a period at the end.
- Describe only the actual changes.
- Do not invent changes that are not present in the diff.
- Prefer a single clear sentence.
- Use lowercase after the colon.

Example:

`feat(auth): ajoute la connexion avec OAuth`