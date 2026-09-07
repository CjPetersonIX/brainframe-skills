#!/usr/bin/env bash
set -euo pipefail
OWNER="CjPetersonIX"
RAW_BASE="https://raw.githubusercontent.com"
MANIFEST_RAW="$RAW_BASE/$OWNER/brainframe-skills/main/manifest.json"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"
MANIFEST="$(curl -fsSL "$MANIFEST_RAW")"
parse() {
  printf '%s' "$MANIFEST" | python3 -c 'import sys,json
for s in json.load(sys.stdin)["skills"]:
 print(s["name"], s["repo"], s["version"])'
}
newer() { [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -1)" = "$1" ] && [ "$1" != "$2" ]; }
echo "checking skills"
changed=0
while read -r name repo latest; do
  [ -z "${name:-}" ] && continue
  cur="none"
  [ -f "$SKILLS_DIR/$name/VERSION" ] && cur="$(tr -d '[:space:]' < "$SKILLS_DIR/$name/VERSION")"
  if [ "$cur" = "none" ] || newer "$latest" "$cur"; then
    if curl -fsSL "$RAW_BASE/$OWNER/$repo/main/install.sh" | SKILLS_DIR="$SKILLS_DIR" bash >/dev/null 2>&1; then
      echo "  $name $cur -> $latest"
      changed=$((changed+1))
    else
      echo "  fail $name"
    fi
  else
    echo "  $name v$cur ok"
  fi
done < <(parse)
[ "$changed" -eq 0 ] && echo "current." || echo "$changed updated"
