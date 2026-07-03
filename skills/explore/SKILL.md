---
name: explore
description: "Codebase-familiarity discipline. Load when working in a codebase you didn't write, before adding code to it. Covers reading before writing, searching for the existing solution before creating a new one, finding and matching the house style, copying the nearest neighbor, mapping the blast radius before changing shared code, and preferring codebase consistency over imported best practice."
---

# Explore

Codebase-familiarity skill for LLM coding agents. Load this when working in a codebase you didn't write — which for an agent is every codebase — before adding code to it.

Where [`deliberate`](../deliberate/SKILL.md) governs how to write and [`architect`](../architect/SKILL.md) governs where code belongs, this skill governs what to *learn first*. Counters the failure mode behind AI-era duplication data: changes that look fine in isolation but ignore the system — re-implemented helpers, pattern-blind additions, and edits to files the agent never read.

Scale the depth to the task: a one-line fix needs the surrounding function; a new feature needs the neighborhood.

---

## 1. Read Before You Write

**Never edit a file you haven't read. Never call code you haven't looked at.**

- Read the whole file you're changing, not just the hunk. The convention you're about to violate is usually 40 lines up.
- Read the functions you call and the callers of what you change. Signatures lie by omission; behavior lives in the body.
- Read the nearest test file. Tests are the executable documentation of intent.

Editing on the basis of a filename and a grep hit is how orthogonal breakage happens.

**Test:** Have I actually read every file this diff touches, top to bottom?

---

## 2. Search Before You Create

**The helper you're about to write probably exists. Find it first.**

Duplication is the signature failure of generated code — the same function re-implemented in three files because nobody looked. Before writing anything reusable-shaped:

- Search for the name you'd give it, and the names this codebase would give it.
- Search for the operation itself: the regex, the API call, the transformation.
- Check the utils/helpers/lib modules and the closest sibling feature.
- Found something close? Extend or reuse it. Only write new when you can say why the existing one doesn't fit.

**Test:** Can I name the search I ran to confirm this doesn't already exist?

---

## 3. Find the House Style and Match It

**Every codebase has a way of doing things. Your change should look like it was written by the same team.**

Before adding code, answer from evidence, not habit:

- How does this codebase handle errors — exceptions, result types, error codes?
- How does it do config, logging, validation, dependency injection, naming?
- How are tests structured, named, and located?
- What's the module layout for a feature like this one?

Two examples is a coincidence; three is the convention. When your training-data instinct disagrees with the local pattern, the local pattern wins (see §6).

**Test:** Could a maintainer tell which parts of this file an outsider wrote?

---

## 4. Copy the Nearest Neighbor

**The best spec for feature N+1 is feature N.**

Implementing an endpoint? Find the most recently touched, best-regarded endpoint and mirror its shape — structure, error handling, tests, registration, docs. Same for a migration, a job, a component, a CLI command.

- Prefer recent, actively maintained examples over old ones; the codebase's own dead patterns shouldn't be your template.
- Mirror the whole shape, including the parts that aren't code: where it's registered, how it's wired, what accompanies it.

This is the cheapest correctness lever available: the neighbor already survived review and production.

**Test:** Which existing feature did I use as the template — and would the team agree it's a good one?

---

## 5. Map the Blast Radius Before Changing Shared Code

**A change to shared code is a change to every caller — including the ones you haven't seen.**

Before modifying anything used more than once:

- Find all callers and importers. All of them, not the first page of results.
- Check for indirect consumers: reflection, dynamic dispatch, string-keyed lookups, serialized formats, external packages.
- Run the tests of the *callers*, not just the code you changed.
- If the caller list is too big to check, that's a signal: the change needs to be additive, not in-place (see [`architect`](../architect/SKILL.md) §3).

**Test:** Can I list who depends on what I'm changing — and did I check them, not assume them?

---

## 6. The Codebase Beats Best Practice

**Consistency is a feature. An imported "improvement" that fights the local idiom is a regression.**

- Match the existing pattern even when you know a better one. A codebase with one mediocre convention is more maintainable than one with three good ones.
- Don't modernize, reformat, or restructure in passing — that's [`deliberate`](../deliberate/SKILL.md) §5 territory.
- If the local pattern is genuinely harmful (a security hole, a data-loss risk), don't silently follow *or* silently fix it. Flag it and let the user decide.

**Test:** Does my change blend in — and if it deliberately doesn't, did I say why out loud?

---

## These Guidelines Are Working If

- Duplicate helpers stop appearing; existing ones grow callers instead.
- Diffs read as native to the codebase — reviewers stop commenting "we don't do it that way here."
- Changes to shared code stop breaking callers the agent "didn't know about."
- New features land in the same shape as their siblings.
- "It edited a file it never read" stops being a thing.

---

*Part of [Deliberate](https://github.com/angad729/deliberate). Load alongside [`deliberate`](../deliberate/SKILL.md); pairs with [`architect`](../architect/SKILL.md) for where code belongs once you know the terrain.*
