#!/usr/bin/env bash
set -euo pipefail
OWNER="CjPetersonIX"
RAW_BASE="https://raw.githubusercontent.com"
MANIFEST_RAW="$RAW_BASE/$OWNER/brainframe-skills/main/manifest.json"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
printf '\033[96mBrainFrame skills bundle\033[0m\n'
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SRC_DIR/manifest.json" ]; then MANIFEST="$(cat "$SRC_DIR/manifest.json")"; else MANIFEST="$(curl -fsSL "$MANIFEST_RAW")"; fi
parse() {
  printf '%s' "$MANIFEST" | python3 -c 'import sys,json
for s in json.load(sys.stdin)["skills"]:
 print(s["name"], s["repo"], s["version"])'
}
WANT=("$@")
want_it() { [ ${#WANT[@]} -eq 0 ] && return 0; for w in "${WANT[@]}"; do [ "$w" = "$1" ] && return 0; done; return 1; }
mkdir -p "$SKILLS_DIR"
count=0
while read -r name repo version; do
  [ -z "${name:-}" ] && continue
  want_it "$name" || continue
  installer="$RAW_BASE/$OWNER/$repo/main/install.sh"
  if SKILLS_DIR="$SKILLS_DIR" bash -c "curl -fsSL '$installer' | SKILLS_DIR='$SKILLS_DIR' bash" >/dev/null 2>&1; then
    printf '  ok %s v%s\n' "$name" "$version"
    count=$((count+1))
  else
    printf '  skip %s\n' "$name"
  fi
done < <(parse)
printf '%d skill(s) -> %s\n' "$count" "$SKILLS_DIR"
