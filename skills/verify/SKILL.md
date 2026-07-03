---
name: verify
description: "Verification discipline. Load before claiming work is done, reporting progress, or handing off a change. Covers demonstrating done instead of declaring it, never weakening a check to make it pass, exercising real behavior beyond green tests, hunting the almost-right bug, reporting observations instead of expectations, disclosing what wasn't verified, and making human verification cheap."
---

# Verify

Verification skill for LLM coding agents. Load this before claiming a task is done, reporting progress on one, or handing off a change.

Where [`deliberate`](../deliberate/SKILL.md) keeps code honest and [`test`](../test/SKILL.md) keeps tests honest, this skill keeps *completion claims* honest. Counters the most-reported failure mode of agentic coding: work declared done that wasn't, output that looks right but isn't, and a verification burden silently dumped on the human.

---

## 1. Done Means Demonstrated

**A completion claim is a claim about observed behavior, not written code.**

- Before saying "done," "fixed," or "implemented" — run the thing. The test, the build, the command, the actual flow.
- Writing code that should work is half the task. Watching it work is the other half.
- If you can't run it (no environment, missing credentials, no harness), it isn't done — it's *written*. Say "written, not verified" and name what verification would take.
- "Should work," "this will now," and "the fix ensures" are predictions. Don't dress predictions as results.

**Test:** Did I watch this work, or am I predicting it will?

---

## 2. Never Game the Check

**When the check fails, fix the code — never the check.**

The check failing on your change is the check working. Off-limits moves:

- Deleting or skipping a failing test to get to green.
- Loosening an assertion until it passes.
- Hardcoding the expected output.
- Stubbing the implementation and reporting the feature complete.
- Catching and swallowing the error that's failing the build.

If you believe the check itself is wrong, stop and make that case out loud. Changing the check is a decision the user makes — not a side effect of reaching green.

**Test:** After my change, would the check still catch the bug it was written to catch?

---

## 3. Green Tests Are Not the Goal

**Tests passing is evidence, not the objective. The objective is behavior.**

- After green, exercise the change the way a caller would: run the CLI command, hit the endpoint, load the page, call the function with real-shaped data.
- Tests verify what tests cover. The gap between "suite passes" and "feature works" is exactly where "almost right" lives.
- Compiling, typechecking, and linting are necessary, not sufficient. They prove the code parses, not that it works.

**Test:** If the test suite vanished, could I still show the feature working?

---

## 4. Hunt the Almost-Right

**Plausible-looking output is the dangerous kind. Attack your own diff before handing it over.**

Code that looks clean and idiomatic survives review precisely because it looks right. Go looking for the subtle miss:

- Boundaries: empty, one, many, max, zero, negative.
- Inverted conditions, off-by-one, the similarly-named wrong variable.
- The path you didn't run: the error branch, the second call, the concurrent call.
- Callers you didn't look at whose behavior your change silently altered.

A minute of adversarial self-checking now is cheaper than the human's hour later.

**Test:** If this diff had a subtle bug, where would it be — and did I look there?

---

## 5. Report Observations, Not Expectations

**Separate what you saw from what you believe.**

- Observed: "Ran `pytest tests/auth` — 34 passed. Hit `/login` on dev — redirect works."
- Expected: "The retry path should also cover timeouts — I didn't trigger one."
- Keep the two visibly distinct in every handoff. Mixing them is how false confidence propagates.
- If a step failed or got skipped, it goes in the report. A tidy summary that omits the failing step is a false claim by omission.

**Test:** Can the reader tell which of my statements were observed and which are predictions?

---

## 6. Disclose the Unverified Remainder

**Every change has a verified core and an unverified edge. Name the edge.**

- List what you did not exercise: platforms, configs, permission levels, data volumes, integrations.
- TODOs, stubs, and known gaps go in the report — not buried in code comments.
- Partial completion honestly reported beats full completion falsely claimed. "Three of five endpoints done and tested; two remain" is a good report, not an admission of failure.

**Test:** If something breaks tomorrow, will the user say "you told me that part wasn't verified" — or "you said this was done"?

---

## 7. Make Human Verification Cheap

**Your claim will be re-verified by a human. Lowering that cost is part of the task.**

Generation is fast; review is not, and the difference lands on the reviewer. Every handoff should include:

- What changed, in one or two sentences.
- What you ran and what you observed.
- The riskiest hunk — where a reviewer should look first.
- The command to re-run your verification, so they can re-run instead of re-derive.

**Test:** Could the user verify my claim in minutes using only my handoff?

---

## These Guidelines Are Working If

- "Done" reliably means done — spot-checks stop finding undone work.
- "Should work" disappears from handoffs, replaced by "ran X, saw Y."
- Tests never get weakened, skipped, or deleted just to reach green.
- Almost-right bugs get caught before handoff, not in review or production.
- Human review time per change drops, because evidence arrives with the claim.

---

*Part of [Deliberate](https://github.com/angad729/deliberate). Load alongside [`deliberate`](../deliberate/SKILL.md); pairs with [`test`](../test/SKILL.md) for what the checks should be and [`review`](../review/SKILL.md) for how the human will judge the handoff.*
