#!/usr/bin/env bash
#
# scripts/check-pii.sh — privacy gate for the interview-loop repo.
#
# Two layers:
#   1) GENERIC detection (always on; this file holds NO real PII):
#        - absolute home paths            /Users/<name>
#        - email addresses
#        - Chinese mobile numbers         1[3-9]xxxxxxxxx
#        - forbidden artifact files       .DS_Store / __MACOSX/ / *.zip
#   2) PROJECT-SPECIFIC real-PII patterns (NEVER stored in this file):
#        loaded from $PII_PATTERNS (CI secret) or scripts/pii-patterns.local
#        (gitignored). If both are absent, only generic detection runs.
#
# This script deliberately contains NO real names / companies / paths — not even
# in comments — so committing it can never leak PII. It scans every file
# INCLUDING itself (to guarantee this file stays clean); only the gitignored
# local pattern file is excluded, since it legitimately holds the real patterns.
#
# Exit: 1 on any hit, 0 if clean.
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR/.." rev-parse --show-toplevel 2>/dev/null)"
[ -z "$REPO_ROOT" ] && REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

STATUS=0

# --- generic patterns (NO real PII) ------------------------------------------
# absolute macOS home path with a real username char; email; CN mobile number.
GENERIC='/Users/[A-Za-z0-9_]|[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}|1[3-9][0-9]{9}'

# --- project-specific real patterns (external, never committed) --------------
EXT_SRC=""
if [ -n "${PII_PATTERNS:-}" ]; then
  EXT_SRC="$PII_PATTERNS"
elif [ -f "$REPO_ROOT/scripts/pii-patterns.local" ]; then
  EXT_SRC="$(cat "$REPO_ROOT/scripts/pii-patterns.local")"
fi
# one regex per non-empty/non-comment line, OR-joined into one alternation
EXT="$(printf '%s\n' "$EXT_SRC" | grep -vE '^[[:space:]]*#' | grep -vE '^[[:space:]]*$' | paste -sd '|' -)"

if [ -n "$EXT" ]; then
  echo "[pii] project patterns: loaded (generic + project detection active)"
  PATTERN="$GENERIC|$EXT"
else
  echo "[pii] project patterns: ABSENT (PII_PATTERNS / pii-patterns.local missing) — generic detection only"
  PATTERN="$GENERIC"
fi

echo "== [1/3] content scan: working tree (excl .git and local pattern file) =="
if grep -rInE -I --exclude-dir=.git --exclude=pii-patterns.local "$PATTERN" "$REPO_ROOT"; then
  STATUS=1
fi

echo "== [2/3] artifact scan: working tree (.DS_Store / __MACOSX/ / *.zip must be absent) =="
if find "$REPO_ROOT" -path "$REPO_ROOT/.git" -prune -o -type f \( -name '.DS_Store' -o -path '*__MACOSX*' -o -name '*.zip' \) -print | grep .; then
  STATUS=1
fi

if git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  REVS="$(git -C "$REPO_ROOT" rev-list --all 2>/dev/null)"
  echo "== [3/3] content + artifact scan: git history (all commits) =="
  if [ -n "$REVS" ]; then
    if git -C "$REPO_ROOT" grep -nE "$PATTERN" $REVS -- . 2>/dev/null; then
      STATUS=1
    fi
    if git -C "$REPO_ROOT" log --all --name-only --pretty=format: 2>/dev/null | sort -u | grep -E '(^|/)\.DS_Store$|(^|/)__MACOSX/|\.zip$'; then
      STATUS=1
    fi
  fi
else
  echo "== [3/3] git history: skipped (not a git repo) =="
fi

echo
if [ "$STATUS" -ne 0 ]; then
  echo "FAIL: PII or forbidden artifacts detected above."
  exit 1
fi
echo "OK: no PII or forbidden artifacts matched."
exit 0
