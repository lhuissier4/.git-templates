#!/bin/bash
# Usage: git br [all | <args de git branch>]
# `all` liste les branches locales/distantes avec le même format et les mêmes couleurs que l'autocomplétion de `git sw`.

if [ "$1" != "all" ]; then
  exec git --no-pager branch "$@"
fi

source "$(dirname "${BASH_SOURCE[0]}")/git-auto-complet.sh"

names=()
types=()
while IFS=$'\t' read -r t n; do
  types+=("$t")
  names+=("$n")
done < <(__gsw_branches)

(( ${#names[@]} == 0 )) && exit 0

head=$(git symbolic-ref --short -q HEAD 2>/dev/null)
w=0
for n in "${names[@]}"; do (( ${#n} > w )) && w=${#n}; done
(( w += 4 ))
cols=$(( ${COLUMNS:-$(tput cols 2>/dev/null || echo 80)} / w ))
(( cols < 1 )) && cols=1

col=0
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
exit 0
