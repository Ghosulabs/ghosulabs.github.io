# Shared bits for the blog commands. Not a command itself.
# shellcheck shell=bash

# BLOG = the Blog folder, wherever the command was called from (works through symlinks).
BLOG="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)"
OWNER="Ghosulabs"
REPO="ghosulabs.github.io"
SITE="https://ghosulabs.github.io/"

say()  { printf '\033[1;35m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m ok\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m !!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merr\033[0m %s\n' "$*" >&2; exit 1; }

need() { command -v "$1" >/dev/null 2>&1 || die "$1 isn't installed. $2"; }

# Wait for the GitHub Actions run for commit $1 and follow it to the end.
watch_deploy() {
  local sha="$1" id="" i
  command -v gh >/dev/null 2>&1 || { say "Pushed. The site updates in about a minute: $SITE"; return 0; }
  say "Waiting for GitHub to build the site (Ctrl+C stops watching, the build carries on)..."
  for i in $(seq 1 20); do
    id="$(gh run list -R "$OWNER/$REPO" --commit "$sha" --limit 1 \
          --json databaseId --jq '.[0].databaseId // empty' 2>/dev/null || true)"
    [ -n "$id" ] && break
    sleep 3
  done
  if [ -z "$id" ]; then
    warn "Couldn't find the build. Check https://github.com/$OWNER/$REPO/actions"
    return 0
  fi
  if gh run watch "$id" -R "$OWNER/$REPO" --exit-status --interval 5 >/dev/null; then
    ok "Live: $SITE"
  else
    warn "The build failed. Details: gh run view $id -R $OWNER/$REPO --log-failed"
    return 1
  fi
}
