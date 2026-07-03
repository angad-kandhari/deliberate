---
name: memory
description: "Memory discipline. Load when the agent keeps persistent memory across sessions - CLAUDE.md, AGENTS.md, auto-memory, memory banks, or any notes file the next session will read. Covers writing selectively, never recording what the repo already knows, structuring memory as index plus topics, stamping claims that can go stale, trusting the repo over the memory, pruning on write, and routing each fact to the right home."
---

# Memory

Memory skill for LLM coding agents. Load this when the agent keeps persistent memory across sessions — `CLAUDE.md`, `AGENTS.md`, auto-memory, a memory-bank directory, or any notes file a future session will read.

Where [`deliberate`](../deliberate/SKILL.md) keeps code honest, this skill keeps *what the agent remembers* honest. Counters the failure modes of agent memory: bloat that buries the signal, stale entries acted on confidently, contradictory duplicates, and notes that restate what the repo already records.

How memory is stored and loaded is the harness's job. What gets written, kept, believed, and deleted is judgment — this skill governs that. The evidence is blunt: agents that record everything perform far worse than agents that record little and prune. Curation beats architecture.

---

## 1. Write Selectively

**A memory earns its place by changing future behavior. Most things don't.**

Before writing, both must hold:

- **It will change what a future session does.** A preference, a constraint, a correction, a decision with a *why*. Not narration of what happened.
- **It can't be re-derived.** If the next session could learn it from the repo, the docs, or one obvious command, writing it down is duplication, not memory.

The strongest write signal is repetition: the same mistake twice, the same correction twice, the same question twice. Once is an event; twice is a pattern worth a note.

**Test:** Will a future session act differently because this entry exists?

---

## 2. Never Record What the Repo Already Knows

**The repo is the source of truth. A memory that copies it is guaranteed to drift from it.**

Don't store:

- Code structure, file locations, function signatures — the file tree and search answer these fresh and correctly every time.
- Dependency lists, versions, scripts — the manifest already says.
- What changed and when — git history says, with proof.
- Anything a README, CLAUDE.md, or doc already states.

Store instead what the repo *can't* say: why a decision went this way, which approach was tried and rejected, what the user corrected, constraints that live outside the code.

**Test:** Could the next session get this from the repo in under a minute? Then it doesn't belong in memory.

---

## 3. Structure as Index Plus Topics

**Always-loaded memory should be pointers. Bodies load on demand.**

Every token of always-loaded memory is paid on every session, relevant or not:

- Keep the always-loaded layer a compact index: one line per memory, enough to decide whether to open it.
- Put the substance in small per-topic files, read only when the topic comes up.
- One topic per file. A file that mixes debugging notes with API conventions can't be recalled, updated, or deleted cleanly.
- Work with the harness's native format — if it already provides an index mechanism, feed it; don't build a rival one.

**Test:** Does the always-loaded layer fit in a screenful, with everything else reachable from it?

---

## 4. Stamp What Can Go Stale

**A fact without a timestamp becomes a lie on a schedule nobody set.**

- Convert relative time to absolute: "last week" is meaningless in three months; "2026-07-03" isn't.
- Pin claims to versions where they can rot: "as of v2.3, the importer chokes on files over 1GB."
- Separate the durable from the perishable: user preferences age slowly; "the staging environment is broken" expires in days. Mark which is which.

**Test:** Reading this entry cold in six months, could I tell whether it still holds — or at least when it was last true?

---

## 5. Trust the Repo Over the Memory

**A recalled memory is a hypothesis about the present, not a fact.**

- Before acting on a memory that names a file, flag, API, or behavior — verify it still exists. Recall is a pointer to check, not a license to skip checking.
- When memory and repo disagree, the repo wins. Every time.
- And fix the memory *in the same session* — a known-stale entry left standing will mislead the next session with the confidence of a fresh one.

Stale memory is worse than no memory: the agent doesn't re-derive what it thinks it already knows.

**Test:** Did I verify this memory against the current repo before acting on it?

---

## 6. Prune on Write

**Memory quality is maintained at write time, not in a someday cleanup.**

Every write is a maintenance moment:

- Check for an existing entry that covers the topic. Update it — don't append a near-duplicate beside it.
- Found a contradiction? Resolve it now. Two entries with different answers means the agent picks one arbitrarily.
- A memory that proved wrong gets deleted or corrected, not left as trivia.
- When the index nears its size cap, consolidate before adding — the cap is a triage forcing-function, not an obstacle.

Append-only memory rots into noise, and retrieval over noise propagates old errors forward.

**Test:** Is this a net addition of signal — or the third entry about the same thing?

---

## 7. Route Each Fact to Its Right Home

**One instruction, one home. Memory is one destination among several — and "nowhere" is a valid one.**

- **Always-loaded rules file** (CLAUDE.md, AGENTS.md): standing instructions that apply to most sessions. Expensive real estate — every line taxes every session.
- **Scoped rules**: conventions that only apply to part of the tree, loaded only there.
- **A skill**: a procedure worth pulling in on demand, not worth carrying always.
- **Memory**: project facts, decisions, and user preferences that accumulate across sessions.
- **Nowhere**: session ephemera, transcript narration, anything the repo records. Most of what happens belongs here.

Filing a standing rule as a memory means it won't fire; filing an ephemeral note as a rule means it never stops firing.

**Test:** If this were filed elsewhere — or nowhere — would anything be worse?

---

## These Guidelines Are Working If

- Memory stays small while sessions keep getting more informed.
- Recalled facts get verified before use — and stale ones die the day they're caught.
- No entry restates what the repo, manifest, or git history already records.
- Contradictory duplicates stop appearing; updates land on existing entries.
- The always-loaded layer stays a lean index, with detail one read away.

---

*Part of [Deliberate](https://github.com/angad-kandhari/deliberate). Load alongside [`deliberate`](../deliberate/SKILL.md); pairs with §9 (Maintain Context Integrity) within a session — this skill extends the same honesty across sessions.*
