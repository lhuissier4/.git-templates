#!/bin/bash
# Autocomplétion bash/zsh des branches pour `git sw` (scripts/git-switch-branch.sh).
# À sourcer depuis ~/.bashrc ou ~/.zshrc (après compinit pour zsh) :
#   source ~/.git-templates/scripts/git-auto-complet.sh
# Couleurs : jaune/marron = locale uniquement, rouge = distante uniquement, vert = locale et distante.

__GSW_REMOTE=origin

# Branche par défaut : HEAD du distant, sinon init.defaultBranch, sinon main/master.
__gsw_default_branch() {
  local ref
  if ref=$(git symbolic-ref --short -q "refs/remotes/$__GSW_REMOTE/HEAD" 2>/dev/null); then
    printf '%s\n' "${ref#"$__GSW_REMOTE"/}"
    return
  fi
  for ref in "$(git config --get init.defaultBranch)" main master; do
    if [ -n "$ref" ] && git show-ref --verify --quiet "refs/heads/$ref"; then
      printf '%s\n' "$ref"
      return
    fi
  done
}

# Affiche "<type>\t<branche>" avec type L (locale), R (distante) ou B (les deux), branche par défaut en tête.
# Les branches distantes sont celles connues localement (dernier fetch), sans accès réseau.
__gsw_branches() {
  git rev-parse --git-dir >/dev/null 2>&1 || return
  local def
  def=$(__gsw_default_branch)
  git for-each-ref --format='%(refname)' refs/heads/ "refs/remotes/$__GSW_REMOTE/" 2>/dev/null |
    awk -v r="refs/remotes/$__GSW_REMOTE/" '
      index($0, "refs/heads/") == 1 { l[substr($0, 12)] = 1; next }
      index($0, r) == 1 { n = substr($0, length(r) + 1); if (n != "HEAD") d[n] = 1 }
      END {
        for (n in l) print ((n in d) ? "B" : "L") "\t" n
        for (n in d) if (!(n in l)) print "R\t" n
      }' | sort -t $'\t' -k2 |
    awk -F '\t' -v def="$def" '$2 == def { print; next } { rest[++n] = $0 } END { for (i = 1; i <= n; i++) print rest[i] }'
}

# ---------------------------------------------------------------- zsh
if [ -n "$ZSH_VERSION" ]; then
  # Nom reconnu par le _git de zsh pour la sous-commande `git sw`.
  _git-sw() {
    local -a lonly ronly both ldisp rdisp bdisp dname ddisp expl
    local t n d dtype ret=1 def head
    def=$(__gsw_default_branch)
    head=$(git symbolic-ref --short -q HEAD 2>/dev/null)
    while IFS=$'\t' read -r t n; do
      if [[ "$n" == "$head" ]]; then d="* $n"; else d="  $n"; fi
      if [[ -n "$def" && "$n" == "$def" ]]; then
        dname=("$n"); ddisp=("$d"); dtype="$t"
        continue
      fi
      case "$t" in
        L) lonly+=("$n"); ldisp+=("$d") ;;
        R) ronly+=("$n"); rdisp+=("$d") ;;
        B) both+=("$n"); bdisp+=("$d") ;;
      esac
    done < <(__gsw_branches)

    case "$dtype" in
      L) zstyle ':completion:*:gsw-default' list-colors '=*=33' ;;
      R) zstyle ':completion:*:gsw-default' list-colors '=*=31' ;;
      *) zstyle ':completion:*:gsw-default' list-colors '=*=32' ;;
    esac

    _tags gsw-default gsw-both gsw-local gsw-remote
    while _tags; do
      _requested -V gsw-default expl 'branche par défaut' compadd -d ddisp -a dname && ret=0
      _requested -V gsw-both expl 'branches locales et distantes' compadd -d bdisp -a both && ret=0
      _requested -V gsw-local expl 'branches locales uniquement' compadd -d ldisp -a lonly && ret=0
      _requested -V gsw-remote expl 'branches distantes uniquement' compadd -d rdisp -a ronly && ret=0
      (( ret )) || break
    done
    return ret
  }

  # Nom reconnu par le _git de zsh pour la sous-commande `git br`.
  _git-br() {
    if (( CURRENT == 3 )) && [[ "$PREFIX" != -* ]]; then
      local -a cmds=('all:liste toutes les branches (locales et distantes)')
      _describe -t commands 'commande br' cmds
    else
      _git-branch
    fi
  }

  # Nom reconnu par le _git de zsh pour la sous-commande `git rmb` : branches locales uniquement.
  _git-rmb() {
    local -a lonly both ldisp bdisp expl
    local t n d ret=1 head
    head=$(git symbolic-ref --short -q HEAD 2>/dev/null)
    while IFS=$'\t' read -r t n; do
      if [[ "$n" == "$head" ]]; then d="* $n"; else d="  $n"; fi
      case "$t" in
        L) lonly+=("$n"); ldisp+=("$d") ;;
        B) both+=("$n"); bdisp+=("$d") ;;
      esac
    done < <(__gsw_branches)

    _tags gsw-both gsw-local
    while _tags; do
      _requested -V gsw-both expl 'branches locales et distantes' compadd -d bdisp -a both && ret=0
      _requested -V gsw-local expl 'branches locales uniquement' compadd -d ldisp -a lonly && ret=0
      (( ret )) || break
    done
    return ret
  }

  zstyle ':completion:*:*:git:*' user-commands \
    sw:'bascule sur une branche (locale ou distante)' \
    br:'liste les branches (all : locales et distantes)' \
    rmb:'supprime une branche locale'
  zstyle ':completion:*:gsw-*' group-name ''
  zstyle ':completion:*:gsw-local' list-colors '=*=33'
  zstyle ':completion:*:gsw-remote' list-colors '=*=31'
  zstyle ':completion:*:gsw-both' list-colors '=*=32'

  if (( $+functions[compdef] )); then
    compdef _git-sw git-switch-branch.sh
  fi
  return 0 2>/dev/null
fi

# ---------------------------------------------------------------- bash
# Complétion colorée générique ; $1 = fonction qui liste "<type>\t<branche>".
__gsw_complete() {
  local lister="$1"
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local -a names types
  local t n

  COMPREPLY=()
  while IFS=$'\t' read -r t n; do
    [[ "$n" == "$cur"* ]] || continue
    types+=("$t")
    names+=("$n")
  done < <("$lister")

  (( ${#names[@]} == 0 )) && return

  # git-completion enregistre `git` avec -o nospace : l'espace final est ajouté à la main.
  if (( ${#names[@]} == 1 )); then
    COMPREPLY=("${names[0]} ")
    return
  fi

  local lcp="${names[0]}"
  for n in "${names[@]}"; do
    while [[ "$n" != "$lcp"* ]]; do lcp="${lcp%?}"; done
  done
  if (( ${#lcp} > ${#cur} )); then
    COMPREPLY=("$lcp")
    return
  fi

  # ${PS1@P} (bash >= 4.4) est requis pour réafficher le prompt après la liste colorée.
  if (( BASH_VERSINFO[0] < 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] < 4) )); then
    COMPREPLY=("${names[@]}")
    return
  fi

  # readline ne sait pas colorer les candidats : la liste est affichée ici, puis le prompt redessiné.
  local w=0 cols col=0 color i mark head
  head=$(git symbolic-ref --short -q HEAD 2>/dev/null)
  for n in "${names[@]}"; do (( ${#n} > w )) && w=${#n}; done
  (( w += 4 ))
  cols=$(( ${COLUMNS:-80} / w ))
  (( cols < 1 )) && cols=1

  printf '\n'
  for i in "${!names[@]}"; do
    case "${types[i]}" in
      L) color=33 ;;
      R) color=31 ;;
      *) color=32 ;;
    esac
    if [[ "${names[i]}" == "$head" ]]; then mark='* '; else mark='  '; fi
    printf '\033[%sm%-*s\033[0m' "$color" "$w" "$mark${names[i]}"
    (( ++col % cols == 0 )) && printf '\n'
  done
  (( col % cols )) && printf '\n'

  printf '%s%s' "${PS1@P}" "$COMP_LINE"
  (( ${#COMP_LINE} > COMP_POINT )) && printf '\033[%dD' $(( ${#COMP_LINE} - COMP_POINT ))
  return 0
}

# Appelée par git-completion.bash pour `git sw` ; utilisable aussi seule via `complete -F`.
_git_sw() { __gsw_complete __gsw_branches; }

# Branches locales uniquement (jaune : locale, vert : locale et distante).
__gsw_local_branches() { __gsw_branches | awk -F '\t' '$1 != "R"'; }
_git_rmb() { __gsw_complete __gsw_local_branches; }

# Appelée par git-completion.bash pour `git br`.
_git_br() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  if (( COMP_CWORD == 2 )) && [[ "$cur" != -* ]]; then
    COMPREPLY=()
    [[ "all" == "$cur"* ]] && COMPREPLY=("all ")
  elif declare -F _git_branch >/dev/null; then
    _git_branch
  fi
}

complete -o nospace -F _git_sw git-switch-branch.sh
