#!/bin/bash
N="${1:-5}"
case "$N" in
  ''|*[!0-9]*)
    echo "Usage : git lasts [nombre]" >&2
    exit 1
    ;;
esac

git --no-pager log -n "$N" HEAD
