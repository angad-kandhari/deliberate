#!/usr/bin/env bash
# Deliberate enforcement — test-gate
# Blocks the agent from ending the turn ("done") while the test command fails.
# Pairs with the `verify` skill: done means demonstrated, not asserted.
#
# Wire as a Stop hook (and optionally SubagentStop). Opt-in — see hooks/enforcement/README.md.
# Configure the command via either:
#   - env  DELIBERATE_TEST_CMD="npm test"
#   - file .deliberate/test-cmd  (one shell command, in the project root)
# With no command configured, this hook does nothing (safe by default).
# Requires: jq.
set -uo pipefail

proj="${CLAUDE_PROJECT_DIR:-.}"
cmd="${DELIBERATE_TEST_CMD:-}"
if [ -z "$cmd" ] && [ -f "$proj/.deliberate/test-cmd" ]; then
  cmd=$(grep -vE '^\s*(#|$)' "$proj/.deliberate/test-cmd" | head -n1)
fi
[ -z "$cmd" ] && exit 0   # nothing configured -> do not block

input=$(cat)
# Prevent an infinite block loop: if we're already inside a stop-hook block, let it end.
active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false')
[ "$active" = "true" ] && exit 0

log="${TMPDIR:-/tmp}/deliberate-test.log"
if ! ( cd "$proj" && sh -c "$cmd" ) >"$log" 2>&1; then
  tail=$(tail -n 20 "$log" 2>/dev/null | sed 's/"/\\"/g')
  jq -n --arg cmd "$cmd" --arg tail "$tail" '{
    decision: "block",
    reason: ("Deliberate: the test command is failing, so the task is not done. Command: `" + $cmd + "`. Fix the failures before ending the turn (see the verify skill).\n\nLast output:\n" + $tail)
  }'
  exit 0
fi

exit 0
