# Enforcement hooks (opt-in)

Skills are advisory — the model can reason around them. Hooks are deterministic: a hook that blocks a tool call cannot be reasoned around. These three recipes give the discipline skills teeth for the handful of things that must happen **100% of the time**.

They are **opt-in and off by default** — installing the Deliberate plugin does *not* enable them. Reserve them for non-negotiables; over-gating an agent is its own failure mode.

Each maps onto a skill:

| Hook | Event | Enforces | Skill |
|---|---|---|---|
| [`block-no-verify.sh`](./block-no-verify.sh) | `PreToolUse` (Bash) | No `git commit/push --no-verify` — can't skip the pre-commit gate | [`verify`](../../skills/verify/SKILL.md), [`secure`](../../skills/secure/SKILL.md) |
| [`test-gate.sh`](./test-gate.sh) | `Stop` | Can't end the turn claiming "done" while tests fail | [`verify`](../../skills/verify/SKILL.md) |
| [`scope-lock.sh`](./scope-lock.sh) | `PreToolUse` (Edit/Write) | No edits outside a declared scope | [`explore`](../../skills/explore/SKILL.md) |

**Requires `jq`** (used to parse the hook payload).

## Enabling one

Two ways: reference the plugin's copies, or copy the scripts into your repo. Copying is the most portable (works even without the plugin installed).

1. Copy the script(s) into your project, e.g. `.claude/hooks/`, and make them executable:

   ```
   mkdir -p .claude/hooks
   cp <deliberate>/hooks/enforcement/block-no-verify.sh .claude/hooks/
   chmod +x .claude/hooks/block-no-verify.sh
   ```

2. Add the matching entry to your project `.claude/settings.json`:

   ```json
   {
     "hooks": {
       "PreToolUse": [
         {
           "matcher": "Bash",
           "hooks": [
             { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-no-verify.sh" }
           ]
         },
         {
           "matcher": "Edit|Write|MultiEdit",
           "hooks": [
             { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/scope-lock.sh" }
           ]
         }
       ],
       "Stop": [
         {
           "hooks": [
             { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/test-gate.sh" }
           ]
         }
       ]
     }
   }
   ```

## Configuring

- **test-gate** needs a test command. Set `DELIBERATE_TEST_CMD="npm test"` in the environment, or drop the command in `.deliberate/test-cmd` at the project root. With neither set, it does nothing.
- **scope-lock** needs a scope. List in-scope glob patterns (one per line) in `.deliberate/scope`:

  ```
  # only touch the auth module this session
  src/auth/**
  tests/auth/**
  ```

  With no `.deliberate/scope` file, it does nothing.

## Behaviour

- `block-no-verify` and `scope-lock` return a `PreToolUse` `deny` with a reason the model sees — it's blocked and told why.
- `test-gate` returns a `Stop` `block` with the failing output, so the agent keeps working instead of ending. It respects `stop_hook_active` to avoid loops; if you truly need to stop with tests red, the harness lets the block be overridden after repeated attempts.

All three fail open: any misconfiguration or missing config means the hook does nothing rather than wedging your session.
