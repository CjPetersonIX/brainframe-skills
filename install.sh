#!/usr/bin/env bash
#
# BRAINFRAME SKILLS — bundle installer
#
#   curl -fsSL https://raw.githubusercontent.com/The9thRealm/brainframe-skills/main/install.sh | bash
#
# Installs every skill listed in manifest.json into your agent's skills directory.
# Non-interactive, idempotent. Defaults to Claude Code (~/.claude/skills); override with
# SKILLS_DIR. Install a subset by passing names:  install.sh qpulse handoff
#
set -euo pipefail

OWNER="The9thRealm"
RAW_BASE="https://raw.githubusercontent.com"
MANIFEST_RAW="$RAW_BASE/$OWNER/brainframe-skills/main/manifest.json"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.claude/skills}"

c_ok()   { printf '\033[92m  ✓\033[0m %s\n' "$1"; }
c_warn() { printf '\033[93m  !\033[0m %s\n' "$1"; }
c_step() { printf '\033[96m▸ %s\033[0m\n' "$1"; }

banner() {
  printf '\033[95m'
  cat <<'EOF'
██████╗ ██████╗  █████╗ ██╗███╗   ██╗███████╗██████╗  █████╗ ███╗   ███╗███████╗
██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝
██████╔╝██████╔╝███████║██║██╔██╗ ██║█████╗  ██████╔╝███████║██╔████╔██║█████╗
██╔══██╗██╔══██╗██╔══██║██║██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝
██████╔╝██║  ██║██║  ██║██║██║ ╚████║██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝
EOF
  printf '\033[0m\033[96m                    S K I L L S   ·   B U N D L E\033[0m\n\n'
}

# Resolve manifest: local checkout if present, else fetch.
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SRC_DIR/manifest.json" ]; then
  MANIFEST="$(cat "$SRC_DIR/manifest.json")"
else
  command -v curl >/dev/null 2>&1 || { echo "curl required"; exit 1; }
  MANIFEST="$(curl -fsSL "$MANIFEST_RAW")"
fi

# Parse name+repo+version from manifest (python3 if available, else a grep fallback).
parse() {
  if command -v python3 >/dev/null 2>&1; then
    printf '%s' "$MANIFEST" | python3 -c '
import sys, json
m = json.load(sys.stdin)
for s in m["skills"]:
    print(s["name"], s["repo"], s["version"])'
  else
    printf '%s' "$MANIFEST" | grep -oE '"(name|repo|version)": *"[^"]*"' \
      | sed -E 's/.*: *"([^"]*)"/\1/' | paste - - -
  fi
}

WANT=("$@")  # optional subset
want_it() { [ ${#WANT[@]} -eq 0 ] && return 0; for w in "${WANT[@]}"; do [ "$w" = "$1" ] && return 0; done; return 1; }

banner
c_step "Installing skills → $SKILLS_DIR"
mkdir -p "$SKILLS_DIR"
count=0
while read -r name repo version; do
  [ -z "${name:-}" ] && continue
  want_it "$name" || continue
  installer="$RAW_BASE/$OWNER/$repo/main/install.sh"
  if SKILLS_DIR="$SKILLS_DIR" bash -c "curl -fsSL '$installer' | SKILLS_DIR='$SKILLS_DIR' bash" >/dev/null 2>&1; then
    c_ok "$name  (v$version)"
    count=$((count+1))
  else
    c_warn "$name — install failed (skipped)"
  fi
done < <(parse)

echo
printf '\033[92m%d skill(s) installed into %s\033[0m\n' "$count" "$SKILLS_DIR"
echo "Upgrade later with:  curl -fsSL $RAW_BASE/$OWNER/brainframe-skills/main/update.sh | bash"
