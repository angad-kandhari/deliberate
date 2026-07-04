#!/usr/bin/env bash
# Deliberate enforcement — block-no-verify
# Denies git commit/push that bypasses the pre-commit gate (--no-verify / -n).
# Pairs with the `verify` and `secure` skills: fix what the gate flags, don't skip it.
#
# Wire as a PreToolUse hook with matcher "Bash". Opt-in — see hooks/enforcement/README.md.
# Requires: jq.
set -uo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

is_git_commit_or_push=0
printf '%s' "$cmd" | grep -Eiq '(^|[^[:alnum:]])git([[:space:]]|$).*(commit|push)' && is_git_commit_or_push=1

has_no_verify=0
printf '%s' "$cmd" | grep -Eiq '(--no-verify)' && has_no_verify=1
# `git commit -n` == --no-verify (only meaningful for commit)
if printf '%s' "$cmd" | grep -Eiq 'git([[:space:]]).*commit' \
   && printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])-n([[:space:]]|$)'; then
  has_no_verify=1
fi

if [ "$is_git_commit_or_push" -eq 1 ] && [ "$has_no_verify" -eq 1 ]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Deliberate: this git commit/push bypasses the pre-commit gate (--no-verify). The gate failing is the gate working — fix what it flags rather than skipping it. See the verify and secure skills."
    }
  }'
  exit 0
fi

exit 0
