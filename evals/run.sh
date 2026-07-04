#!/usr/bin/env bash
# Deliberate eval runner.
# Sends each scenario prompt to your agent and saves the transcript, so you can
# grade it against rubric.md. Run it twice — once with Deliberate loaded, once
# without — and compare the scorecards. This script does not grade; grading is
# a separate rubric pass (see README.md) so the numbers stay honest.
#
# Usage:
#   AGENT_CMD='claude -p'      ./run.sh with       # Deliberate installed/active
#   AGENT_CMD='claude -p'      ./run.sh without    # Deliberate removed/disabled
#   AGENT_CMD='codex exec'     ./run.sh with
#
# AGENT_CMD must read a prompt on stdin and write the response to stdout.
set -euo pipefail

label="${1:?usage: AGENT_CMD='<agent>' ./run.sh <with|without>}"
: "${AGENT_CMD:?set AGENT_CMD, e.g. AGENT_CMD='claude -p'}"

dir="$(cd "$(dirname "$0")" && pwd)"
out="$dir/results/$label"
mkdir -p "$out"

count=0
for f in "$dir"/scenarios/*.txt; do
  name=$(basename "$f" .txt)
  printf '→ %s\n' "$name"
  if ! $AGENT_CMD < "$f" > "$out/$name.transcript.md" 2>&1; then
    printf '  (agent exited non-zero; transcript still saved)\n'
  fi
  count=$((count + 1))
done

printf '\nSaved %d transcripts to %s\n' "$count" "$out"
printf 'Next: grade each transcript against rubric.md (pass/partial/fail) and\n'
printf 'record the results in SCORECARD.md. Run again with the other label to\n'
printf 'get the with-vs-without delta.\n'
