#!/usr/bin/env bash
# Deliberate enforcement — scope-lock
# Denies edits to files outside a declared scope. Pairs with the `explore` skill
# and deliberate §5 (surgical changes): touch only what you must.
#
# Wire as a PreToolUse hook with matcher "Edit|Write|MultiEdit". Opt-in.
# Declare in-scope glob patterns (one per line) in .deliberate/scope, e.g.
#   src/auth/**
#   src/auth/*.ts
#   tests/auth/**
# Lines starting with # are comments. With no scope file, this hook does nothing.
# Requires: jq.
set -uo pipefail

proj="${CLAUDE_PROJECT_DIR:-.}"
scope_file="$proj/.deliberate/scope"
[ -f "$scope_file" ] || exit 0   # no scope declared -> no-op

input=$(cat)
path=$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // ""')
[ -z "$path" ] && exit 0

# Normalize to a project-relative path.
rel="${path#"$proj"/}"
rel="${rel#./}"

shopt -s extglob globstar nullglob 2>/dev/null || true
match=0
while IFS= read -r pat || [ -n "$pat" ]; do
  case "$pat" in ''|\#*) continue;; esac
  pat="${pat%/}"
  # ** should span directories; bash extglob doesn't do that in `case`, so
  # translate a trailing /** to a prefix match.
  case "$pat" in
    */\*\*) [ "${rel#"${pat%/**}"/}" != "$rel" ] && match=1 ;;
    \*\*) match=1 ;;
    *) case "$rel" in $pat) match=1;; esac ;;
  esac
  [ "$match" -eq 1 ] && break
done < "$scope_file"

if [ "$match" -eq 0 ]; then
  jq -n --arg p "$rel" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: ("Deliberate: " + $p + " is outside the declared scope (.deliberate/scope). Keep the change surgical — if this file genuinely belongs in scope, widen it deliberately rather than drifting into it.")
    }
  }'
  exit 0
fi

exit 0
