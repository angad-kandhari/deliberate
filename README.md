# Deliberate

**Engineering discipline for AI harnesses.**

A drop-in skill library for LLM coding agents (Claude Code, Codex, Cursor, Gemini, and 40+ others) that mitigates the failure modes that show up once you're mostly programming in English: silent assumptions, sycophancy, overcomplication, orthogonal edits, runaway loops, half-finished migrations, tautological tests, and confidence without calibration.

One foundational skill. Twelve specialized skills. Each a standalone `SKILL.md` with frontmatter. Install with one command or drop in by hand.

Site: **[deliberate.work](https://deliberate.work)**

---

## Install

### One-liner (recommended)

```
npx skills add angad-kandhari/deliberate
```

Works with Cursor, Claude Code, Codex, Gemini CLI, Windsurf, Cline, Continue, Goose, Kilo, Roo, and 40+ other agents. Powered by [vercel-labs/skills](https://github.com/vercel-labs/skills).

### Manual

```
git clone https://github.com/angad-kandhari/deliberate.git /tmp/deliberate
cp -r /tmp/deliberate/skills ./
```

Then reference from your agent's config (see [Usage](#usage) below).

---

## Why this exists

In late 2025, [Andrej Karpathy](https://x.com/karpathy) posted [a thread](https://x.com/karpathy/status/2015883857489522876) on what changed - and what didn't - as agent coding crossed a coherence threshold:

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code… implement a bloated construction over 1000 lines when 100 would do."

> "They still sometimes change/remove comments and code they don't sufficiently understand as side effects, even if orthogonal to the task."

Those are the failure modes Deliberate pushes against. Credit for the diagnosis is Karpathy's; this library is the practical extrapolation into files you can drop into a project.

---

## What's in the library

### The foundation

**[`skills/deliberate/SKILL.md`](./skills/deliberate/SKILL.md)** — nine principles for how an agent should write code. The default load for any project.

| # | Principle | Counters |
|---|---|---|
| 1 | Think Before Coding | Silent assumptions, hidden confusion |
| 2 | Push Back When Warranted | Sycophancy |
| 3 | Plan Inline | Jumping to code on multi-step tasks |
| 4 | Simplicity First | Overcomplication, bloated abstractions |
| 5 | Surgical Changes | Orthogonal edits, scope creep, dead-code leftovers |
| 6 | Goal-Driven Execution | Weak success criteria, lost leverage |
| 7 | Know When to Stop | Runaway tenacity, grinding on a broken approach |
| 8 | Confidence Calibration | Guessing in an authoritative tone |
| 9 | Maintain Context Integrity | Silently reversing earlier decisions |

### The specialized skills

Load these alongside `deliberate` when the task calls for them. Each is a standalone file; take what you need.

| Skill | Use when | Counters |
|---|---|---|
| [`spec`](./skills/spec/SKILL.md) | Building a feature against a PRD or design doc | Reverse-engineering intent from code |
| [`debug`](./skills/debug/SKILL.md) | Fixing a bug, triaging a symptom | Random fixes until symptoms go away |
| [`review`](./skills/review/SKILL.md) | Reviewing a PR (yours or someone else's) | Rubber-stamp LGTMs, nit-only reviews |
| [`test`](./skills/test/SKILL.md) | Writing or auditing tests | Over-mocking, tautological suites |
| [`verify`](./skills/verify/SKILL.md) | Claiming work is done, handing off a change | False "done" claims, gamed tests, verification debt |
| [`secure`](./skills/secure/SKILL.md) | Touching auth, input, secrets, or data boundaries | Bypassed controls, injectable code, leaked secrets |
| [`pentest`](./skills/pentest/SKILL.md) | Authorized security testing of a running system | Unauthorized probing, unreproducible findings, collateral damage |
| [`explore`](./skills/explore/SKILL.md) | Working in a codebase you didn't write | Duplicate helpers, pattern-blind changes, editing unread files |
| [`memory`](./skills/memory/SKILL.md) | Keeping persistent memory across sessions | Memory bloat, stale recall, repo-duplicating notes |
| [`architect`](./skills/architect/SKILL.md) | Crossing component boundaries, shaping contracts | Premature abstraction, boundary blur |
| [`migrate`](./skills/migrate/SKILL.md) | DB schema, framework upgrade, API version bump | Big-bang rewrites, half-finished migrations |
| [`incident`](./skills/incident/SKILL.md) | Production is on fire, paging alert is active | Shotgun fixes under pressure, lost evidence |

Each skill has a short rule per section and a one-line test you can apply in the moment.

---

## Usage

### Claude Code

```md
# CLAUDE.md

Follow the guidelines in @skills/deliberate/SKILL.md for all code changes.
When working on features against a PRD or design doc, also follow @skills/spec/SKILL.md.
When debugging, also follow @skills/debug/SKILL.md.
When reviewing PRs, also follow @skills/review/SKILL.md.
When writing tests, also follow @skills/test/SKILL.md.
Before claiming work is done or handing off a change, also follow @skills/verify/SKILL.md.
When touching auth, user input, secrets, or data access, also follow @skills/secure/SKILL.md.
When running an authorized security assessment, also follow @skills/pentest/SKILL.md.
Before adding code to an unfamiliar part of the codebase, also follow @skills/explore/SKILL.md.
When writing to or recalling from persistent memory, also follow @skills/memory/SKILL.md.
When crossing component boundaries, also follow @skills/architect/SKILL.md.
When planning a migration, also follow @skills/migrate/SKILL.md.
When responding to an incident, also follow @skills/incident/SKILL.md.
```

### Cursor

Skills land in `.cursor/rules/` automatically via `npx skills add`. For manual installs, reference them from `.cursorrules`.

### Codex / Gemini / other agents

If you used `npx skills add`, you're done — it detects your agents and installs to each. Otherwise include the relevant `SKILL.md` files in your project context or system prompt. Plain markdown with frontmatter works everywhere.

### Team usage

Commit to your repo. Treat it like a linter config for agent behavior: shared, versioned, reviewed.

---

## When *not* to use it

- **Trivial one-liners.** Deliberate biases toward caution over speed. For throwaway scripts or obvious edits, the overhead isn't worth it.
- **Rapid prototyping where correctness doesn't matter yet.** Plan-first gets in the way of exploration.
- **You disagree with a principle.** Fork it. Delete sections. Rewrite for your taste. It's a starting point, not scripture.

---

## Signals it's working

- Diffs contain fewer unrelated changes.
- Clarifying questions arrive *before* implementation, not after a wrong turn.
- Fewer rewrites triggered by "couldn't you just…?"
- The agent says "I don't know" or "this might be wrong" when appropriate.
- The agent stops and escalates instead of grinding on a broken approach.
- Debugging sessions come with named causes, not just changed lines.
- Reviews surface architectural concerns before nits.
- Migrations ship in revertable steps, not big-bang cutovers.
- Incident postmortems produce concrete, dated follow-ups.

---

## Credits & references

- **Andrej Karpathy** - the original observations this work extrapolates from. Follow him on [x.com/karpathy](https://x.com/karpathy).
- Site design inspired by [Impeccable](https://impeccable.style/) by [pbakaus](https://github.com/pbakaus).
- CLI install powered by [vercel-labs/skills](https://github.com/vercel-labs/skills).

None of the diagnosis is mine; the packaging into drop-in planning files is.

---

## Contributing

Found a failure mode that isn't covered? Have a tighter phrasing for a principle? PRs welcome. Keep it short - each file earns its place by being readable in a single sitting.

---

## License

Apache 2.0. See [LICENSE](./LICENSE) and [NOTICE](./NOTICE). Use it, fork it, rewrite it, ship it - just preserve attribution.
