#!/usr/bin/env bash

set -euo pipefail

JSON_FILE="./treesitter-parsers.json"

echo "{ fetchurl }:"
echo "{"

process_entry() {
  echo "Processing $1 from $2" > /dev/stderr
  local key="$1" src="$2" location="$3" language="$4"

  local repo="${src#https://github.com/}"
  local tag=$(curl -Ls -o /dev/null -w '%{url_effective}' \
    "https://github.com/${repo}/releases/latest"  | sed 's:.*/::')

  [ -z "$tag" ] && return

  local url="https://github.com/${repo}/archive/${tag}.tar.gz"
  local hash=$(nix store prefetch-file --json "$url" 2>/dev/null | jq -r '.hash')

  [ -z "$hash" ] && return

  echo "  $key = {"
  echo "    src = fetchurl {"
  echo "      url = \"$url\";"
  echo "      hash = \"$hash\";"
  echo "    };"
  [ -n "$location" ] && echo "    location = \"$location\";"
  [ -n "$language" ] && echo "    language = \"$language\";"
  echo "  };"
}

export -f process_entry

jq -r 'to_entries | .[] | 
  "\(.key)|\(.value.src)|\(.value.location // "")|\(.value.language // "")"' "$JSON_FILE" |
  while IFS='|' read -r key src location language; do
    process_entry "$key" "$src" "$location" "$language"
  done

  echo "}"
