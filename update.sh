#!/usr/bin/env bash
#
# BRAINFRAME SKILLS — upgrade pack
#
#   curl -fsSL https://raw.githubusercontent.com/CjPetersonIX/brainframe-skills/main/update.sh | bash
#
# Compares the version installed under SKILLS_DIR/<skill>/VERSION against the latest in the
# bundle manifest and re-installs any skill that is missing or out of date. Like a package
# manager's update pack: pull the manifest, diff versions, apply only what changed.
#
set -euo pipefail

OWNER="CjPetersonIX"
RAW_BASE="https://raw.githubusercontent.com"
MANIFEST_RAW="$RAW_BASE/$OWNER/brainframe-skills/main/manifest.json"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"

c_ok()   { printf '\033[92m  ✓\033[0m %s\n' "$1"; }
c_upd()  { printf '\033[96m  ↑\033[0m %s\n' "$1"; }
c_warn() { printf '\033[93m  !\033[0m %s\n' "$1"; }

command -v curl >/dev/null 2>&1 || { echo "curl required"; exit 1; }
MANIFEST="$(curl -fsSL "$MANIFEST_RAW")"

parse() {
  if command -v python3 >/dev/null 2>&1; then
    printf '%s' "$MANIFEST" | python3 -c '
import sys, json
for s in json.load(sys.stdin)["skills"]:
    print(s["name"], s["repo"], s["version"])'
  else
    printf '%s' "$MANIFEST" | grep -oE '"(name|repo|version)": *"[^"]*"' \
      | sed -E 's/.*: *"([^"]*)"/\1/' | paste - - -
  fi
}

# numeric semver compare: returns 0 if $1 > $2
newer() { [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | tail -1)" = "$1" ] && [ "$1" != "$2" ]; }

printf '\033[95m▸ BRAINFRAME SKILLS — checking for updates\033[0m\n'
changed=0
while read -r name repo latest; do
  [ -z "${name:-}" ] && continue
  cur="none"
  [ -f "$SKILLS_DIR/$name/VERSION" ] && cur="$(tr -d '[:space:]' < "$SKILLS_DIR/$name/VERSION")"
  if [ "$cur" = "none" ] || newer "$latest" "$cur"; then
    installer="$RAW_BASE/$OWNER/$repo/main/install.sh"
    if curl -fsSL "$installer" | SKILLS_DIR="$SKILLS_DIR" bash >/dev/null 2>&1; then
      c_upd "$name  $cur → $latest"
      changed=$((changed+1))
    else
      c_warn "$name — update failed"
    fi
  else
    c_ok "$name  v$cur (up to date)"
  fi
done < <(parse)

echo
[ "$changed" -eq 0 ] && echo "Everything current." || printf '\033[92m%d skill(s) updated.\033[0m\n' "$changed"
